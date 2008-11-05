//
//  NSBundle+DSExtensions.m
//  Ampede
//
//  Created by Erich Ocean on 11/20/06.
//  Copyright 2006 Erich Atlas Ocean. All rights reserved.
//

#import "NSBundle+DSExtensions.h"


@implementation NSBundle ( DSExtensions )

+ (NSString *) pathForPlist: (NSString *) plistName
{
    return [[self mainBundle] pathForResource: plistName
                              ofType:          @"plist" ];
}

@end
