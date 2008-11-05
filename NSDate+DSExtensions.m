//
//  NSDate+DSExtensions.m
//  Ampede
//
//  Created by Erich Ocean.
//  Copyright 2006 Erich Atlas Ocean. All rights reserved.
//

#import "NSDate+DSExtensions.h"


@implementation NSDate ( DSExtensions )

- (NSDate *) dateForSorting
{
    return self;
}

// returns the time at the beginning of the day, in the local time zone
+ (NSDate *) today
{
    NSString *todaysDateAsString = [[NSDate date] descriptionWithCalendarFormat: @"%Y-%m-%d 00:00:00 %z"
                                                  timeZone:                      [NSTimeZone systemTimeZone]
                                                  locale:                        [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
    
    return [NSDate dateWithString: todaysDateAsString];
}

+ (NSDate *) todayGMT
{
    return [[NSDate today] addTimeInterval: [[NSTimeZone systemTimeZone] secondsFromGMT]];
}

// returns the time at the beginning of the day, in the local time zone
+ (NSDate *) now
{
    NSString *todaysDateAsString = [[NSDate date] descriptionWithCalendarFormat: @"%Y-%m-%d %H:%M:%S %z"
                                                  timeZone:                      [NSTimeZone systemTimeZone]
                                                  locale:                        [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
    
    return [NSDate dateWithString: todaysDateAsString];
}

+ (NSDate *) nowGMT
{
    return [[NSDate now] addTimeInterval: [[NSTimeZone systemTimeZone] secondsFromGMT]];
}

+ (NSDate *) dateFromCalendarDate: (NSCalendarDate *) cDate
{
    NSString *dateString = [cDate descriptionWithCalendarFormat: @"%Y-%m-%d %H:%M:%S %z"];
    
    return [NSDate dateWithString: dateString];
}

@end
