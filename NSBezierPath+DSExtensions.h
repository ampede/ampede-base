//
//  NSBezierPath+DSExtensions.h
//  Ampede
//
//  Based on NSBezierPath+StrokeExtensions.h by Matt Gemmell <http://iratescotsman.com/> and Rainer Brockerhoff <http://www.brockerhoff.net/>
//
//  Created by Erich Ocean.
//  Copyright 2006 Erich Atlas Ocean. All rights reserved.
//

@interface NSBezierPath ( DSExtensions )

- (void)strokeInside;
- (void)strokeInsideWithinRect:(NSRect)clipRect;

@end
