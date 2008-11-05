//
//  NSView+DSExtensions.m
//  Ampede
//
//  Created by Erich Ocean.
//  Copyright 2006 Erich Atlas Ocean. All rights reserved.
//

#import "NSView+DSExtensions.h"
#import <CoreFoundation/CFDictionary.h>


static CFMutableDictionaryRef _overlayViewDict = NULL;

@class OverlayHelperWindow;
@class OverlayHelperView;

@interface OverlayHelperWindow : NSWindow
{
	OverlayHelperView    * helperView;
	NSView               * parentView;
	NSWindowOrderingMode   order;
}

- initWithContentRect: (NSRect)               contentRect
  styleMask:           (unsigned int)         aStyle
  backing:             (NSBackingStoreType)   bufferingType
  defer:               (BOOL)                 flag
  parentView:          (NSView *)             aView
  helperView:          (OverlayHelperView *)  helper
  ordered:             (NSWindowOrderingMode) place;
  
- (void) parentViewWillMoveToWindow: (NSWindow *) window;
- (void) parentViewDidMoveToWindow;

- (OverlayHelperView *) helperView;

@end

@interface OverlayHelperView : NSView
{
	OverlayHelperWindow * helperWindow;
}

- (void) setHelperWindow: (OverlayHelperWindow *) helper;

@end

@implementation NSView ( DSExtensions )

- (void)
addOverlayView: (NSView *)             theView
ordered:        (NSWindowOrderingMode) place
{
	NSMutableArray *overlayviews;
	OverlayHelperWindow *childWindow;
	OverlayHelperView *helperView;
    
	if ( !_overlayViewDict ) _overlayViewDict = CFDictionaryCreateMutable( NULL, 0, NULL, &kCFTypeDictionaryValueCallBacks );
    
	overlayviews = (NSMutableArray *)CFDictionaryGetValue( _overlayViewDict, self );
    
	if( !overlayviews )
	{
		overlayviews = [[NSMutableArray alloc] init];
		CFDictionarySetValue( _overlayViewDict, self, overlayviews );
		[overlayviews release];
	}
    
	[overlayviews addObject:theView];
    
	// Add a special NSView to the parent so we can track a few things...
	helperView = [[OverlayHelperView alloc] initWithFrame: NSMakeRect( 0, 0, 0, 0 )];
    
	childWindow = [[OverlayHelperWindow alloc] initWithContentRect: NSMakeRect( -10000, -10000, 1, 1 )
                                               styleMask:           NSBorderlessWindowMask
                                               backing:             NSBackingStoreBuffered
                                               defer:               NO
                                               parentView:          self
                                               helperView:          helperView
                                               ordered:             place                            ];
	[childWindow setContentView: theView];
	[helperView setHelperWindow: childWindow];
	[self addSubview: helperView];
	[helperView release];
	[childWindow display];
}

- (void)
removeOverlayView: (NSView *) theView
{
	NSMutableArray *overlayviews;
	OverlayHelperWindow *childWindow;
	OverlayHelperView *helperView;
    
	if ( !_overlayViewDict ) return;
    
	overlayviews = (NSMutableArray *)CFDictionaryGetValue( _overlayViewDict, self );
    
	if ( !overlayviews ) return;
    
	[overlayviews removeObject: theView];
    
	// Grab helper window and helper views
	childWindow = (OverlayHelperWindow *)[theView window];
	helperView = [childWindow helperView];
	
	[helperView removeFromSuperview];

	[childWindow release];

	if ( [overlayviews count] == 0 ) CFDictionaryRemoveValue( _overlayViewDict, self );
    
	[self setNeedsDisplay:YES];
}

- (NSArray *) overlayViews
{
	if ( !_overlayViewDict ) return nil;
    
	return [[(NSMutableArray *)CFDictionaryGetValue( _overlayViewDict, self ) copy] autorelease];
}

- (void) viewWillBecomeOverlay {}
- (void) viewDidBecomeOverlay {}
- (void) viewWillResignOverlay {}
- (void) viewDidResignOverlay {}

@end

@implementation OverlayHelperView

- (void)
setHelperWindow: (OverlayHelperWindow *) theWindow
{
	helperWindow = theWindow;
}

- (void)
viewWillMoveToWindow: (NSWindow *) theWindow
{
	[helperWindow parentViewWillMoveToWindow: theWindow];
}

- (void) viewDidMoveToWindow
{
	[helperWindow parentViewDidMoveToWindow];
}

@end

@implementation OverlayHelperWindow

- (void)
parentViewChanged: (NSNotification *) note
{
	NSRect viewRect, windowRect;
	
	viewRect = [parentView convertRect: [parentView bounds]
                           toView:      nil               ];
	
	windowRect = [[helperView window] frame];
	
	viewRect.origin.x += windowRect.origin.x;
	viewRect.origin.y += windowRect.origin.y;
    
	[self setFrame: viewRect
          display:  YES     ];
}

- (void)
parentViewWillMoveToWindow: (NSWindow *) window
{
	if ( !window && window != [self parentWindow] )
	{
		NSView *overlayView = [self contentView];
        
		if ( [overlayView respondsToSelector: @selector( viewWillResignOverlay )] ) [overlayView viewWillResignOverlay];
        
		[[self parentWindow] removeChildWindow:self];
        
		if ( [overlayView respondsToSelector: @selector( viewDidResignOverlay ) ]) [overlayView viewDidResignOverlay];
	}
}

- (void) parentViewDidMoveToWindow
{
	NSView *overlayView = [self contentView];
    
	if ( [helperView window] )
	{
		if ( [overlayView respondsToSelector: @selector( viewWillBecomeOverlay )] ) [overlayView viewWillBecomeOverlay];
        
		[[helperView window] addChildWindow: self
                             ordered:        order];
        
		if ( [[helperView window] isVisible] ) [self orderFront:nil];
        
		[self parentViewChanged:nil];
        
		if ( [overlayView respondsToSelector: @selector( viewDidBecomeOverlay )] ) [overlayView viewDidBecomeOverlay];
	}
}

- initWithContentRect: (NSRect)               contentRect
  styleMask:           (unsigned int)         aStyle
  backing:             (NSBackingStoreType)   bufferingType
  defer:               (BOOL)                 flag
  parentView:          (NSView *)             aView
  helperView:          (OverlayHelperView *)  helper
  ordered:             (NSWindowOrderingMode) place
{
	if ( self = [super initWithContentRect: contentRect
                       styleMask:           aStyle
                       backing:             bufferingType
                       defer:               flag         ] )
	{
		parentView = aView;
		helperView = helper;
		order = place;
		
		[self setOpaque: NO];
		[self setAlphaValue: 0.999];
		[self setIgnoresMouseEvents: YES];

		// Ask to get notifications when our parent view's frame changes.
		[[NSNotificationCenter defaultCenter] addObserver: self
                                              selector:    @selector( parentViewChanged: )
                                              name:        NSViewFrameDidChangeNotification
                                              object:      aView                           ];

	}
	return self;
}

- (OverlayHelperView *) helperView
{
	return helperView;
}

@end
