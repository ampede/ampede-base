//
//  NSBezierPath+DSExtensions.m
//  Ampede
//
//  Created by Erich Ocean.
//  Copyright 2006 Erich Atlas Ocean. All rights reserved.
//

#import "NSBezierPath+DSExtensions.h"


@implementation NSBezierPath ( DSExtensions )

- (void) strokeInside
{
    /* Stroke within path using no additional clipping rectangle. */
    [self strokeInsideWithinRect: NSZeroRect];
}

- (void)
strokeInsideWithinRect: (NSRect) clipRect
{
    NSGraphicsContext *thisContext = [NSGraphicsContext currentContext];
    float lineWidth = [self lineWidth];
    
    /* Save the current graphics context. */
    [thisContext saveGraphicsState];
    
    /* Double the stroke width, since -stroke centers strokes on paths. */
    [self setLineWidth: (lineWidth * 2.0)];
    
    /* Clip drawing to this path; draw nothing outwith the path. */
    [self setClip];
    
    /* Further clip drawing to clipRect, usually the view's frame. */
    if ( clipRect.size.width > 0.0 && clipRect.size.height > 0.0 )  [NSBezierPath clipRect:clipRect];
    
    /* Stroke the path. */
    [self stroke];
    
    /* Restore the previous graphics context. */
    [thisContext restoreGraphicsState];
    [self setLineWidth: lineWidth];
}

@end
