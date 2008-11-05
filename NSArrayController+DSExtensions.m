//
//  NSArrayController+DSExtensions.m
//  Ampede
//
//  Created by Erich Ocean.
//  Copyright 2006 Erich Atlas Ocean. All rights reserved.
//

#import "NSArrayController+DSExtensions.h"

@implementation NSArrayController (DSExtensions)

- (BOOL)
setSelectedObject: (id) object
{
    id ary = [[NSArray alloc] initWithObjects: &object count: 1];
    BOOL result = [self setSelectedObjects: ary];
    [ary release];
    return result;
}

@end
