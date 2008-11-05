//
//  NSManagedObject+DSExtensions.h
//  Ampede
//
//  Created by Erich Ocean.
//  Copyright 2006 Erich Atlas Ocean. All rights reserved.
//

@interface NSManagedObject ( DSExtensions )

- (NSArray *)propertyKeys;
- (NSDictionary *)committedValues;
- (NSDictionary *)uncommitedValues;
- (BOOL)canBeDeleted;

@end
