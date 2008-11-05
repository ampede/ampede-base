//
//  NSView+DSExtensions.h
//  Ampede
//
//  Derived from sample code in Apple's GLChildWindowDemo sample.
//
//  Created by Erich Ocean.
//  Copyright 2006 Erich Atlas Ocean. All rights reserved.
//

@interface NSView ( DSExtensions )

- (void) addOverlayView: (NSView *)             theView
         ordered:        (NSWindowOrderingMode) place;

- (void) removeOverlayView: (NSView *) theView;

- (NSArray *) overlayViews;

// implement the folowing in your view if you want them to be called
- (void) viewWillBecomeOverlay;
- (void) viewDidBecomeOverlay;
- (void) viewWillResignOverlay;
- (void) viewDidResignOverlay;

@end
