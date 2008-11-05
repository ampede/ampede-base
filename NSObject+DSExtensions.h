//
//  NSObject+DSExtensions.h
//  Ampede
//
//  Created by Erich Ocean.
//  Copyright 2006 Erich Atlas Ocean. All rights reserved.
//

@interface NSObject ( DSExtensions )

//- (NSError *)
//errorFromOriginalError: (NSError *) originalError
//error:                  (NSError *) secondError;

+ (void)
key:           (NSString *) dependentKey
dependsOnKeys: (NSArray *)  keys;

- observedObject;

- (void)
performSelector:   (SEL)            aSelector
afterTimeInterval: (NSTimeInterval) aTimeInterval;

- (void)
loadNibNamed: (NSString *) aNibName;

@end
