//
//  NSObject+DSExtensions.m
//  Ampede
//
//  Created by Erich Ocean.
//  Copyright 2006 Erich Atlas Ocean. All rights reserved.
//

#import "NSObject+DSExtensions.h"


@implementation NSObject ( DSExtensions )

// taken from http://developer.apple.com/documentation/Cocoa/Conceptual/CoreData/index.html#//apple_ref/doc/uid/TP40001075

//- (NSError *)
//errorFromOriginalError: (NSError *) originalError
//error:                  (NSError *) secondError
//{
//    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//    NSMutableArray *errors = [NSMutableArray arrayWithObject: secondError];
//    
//    if ( [originalError code] == NSValidationMultipleErrorsError )
//    {
//        [userInfo addEntriesFromDictionary: [originalError userInfo]];
//        [errors addObjectsFromArray: [userInfo objectForKey: NSDetailedErrorsKey]];
//    }
//    else [errors addObject: originalError];
//    
//    [userInfo setObject: errors
//              forKey:    NSDetailedErrorsKey];
//    
//    return [NSError errorWithDomain: NSCocoaErrorDomain
//                    code:            NSValidationMultipleErrorsError
//                    userInfo:        userInfo                       ];
//}

+ (void)
key:           (NSString *) dependentKey
dependsOnKeys: (NSArray *)  keys
{
    [self setKeys:                                   keys
          triggerChangeNotificationsForDependentKey: dependentKey];
}

- observedObject
{
    return self;
}

- (void)
performSelector:   (SEL)            aSelector
afterTimeInterval: (NSTimeInterval) aTimeInterval
{
    [NSTimer scheduledTimerWithTimeInterval: aTimeInterval
             target:                         self
             selector:                       aSelector
             userInfo:                       nil
             repeats:                        NO           ];
}

- (void)
loadNibNamed: (NSString *) aNibName
{
    [NSBundle loadNibNamed: aNibName
              owner:        self    ];
}

@end
