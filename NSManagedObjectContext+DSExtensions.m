//
//  NSManagedObjectContext+DSExtensions.m
//  Ampede
//
//  Created by Erich Ocean on 11/20/06.
//  Copyright 2006 Erich Atlas Ocean. All rights reserved.
//

#import "NSManagedObjectContext+DSExtensions.h"


@implementation NSManagedObjectContext ( DSExtensions )

- (NSManagedObject *)
insertNewObjectForEntityNamed: (NSString *) anEntityName
{
    return [NSEntityDescription insertNewObjectForEntityForName: anEntityName 
                                inManagedObjectContext:          self        ];
}

@end
