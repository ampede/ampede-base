//
//  NSDate+DSExtensions.h
//  Ampede
//
//  Created by Erich Ocean.
//  Copyright 2006 Erich Atlas Ocean. All rights reserved.
//

@interface NSDate ( DSExtensions )

- (NSDate *) dateForSorting;

+ (NSDate *) today;
+ (NSDate *) todayGMT;
+ (NSDate *) now;
+ (NSDate *) nowGMT;

+ (NSDate *) dateFromCalendarDate: (NSCalendarDate *) cDate;

@end
