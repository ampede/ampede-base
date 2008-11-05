//
//  NSManagedObject+DSExtensions.m
//  Ampede
//
//  Created by Erich Ocean.
//  Copyright 2006 Erich Atlas Ocean. All rights reserved.
//

#import "NSManagedObject+DSExtensions.h"


@implementation NSManagedObject ( DSExtensions )

- (NSArray *) propertyKeys
{
    return [[[self entity] propertiesByName] allKeys];
}

- (NSDictionary *) committedValues
{
    return [self committedValuesForKeys:nil];
}

- (NSDictionary *) uncommitedValues
{
    return [self dictionaryWithValuesForKeys:[self propertyKeys]];
}

// TODO: enhance this to handle min/max counts and inverse relationships

- (BOOL) canBeDeleted
{
    // this method looks for any relatioships of the managed object with a value of DENY
    // and returns NO if any of those relationships contain objects at the destination
    
    BOOL canBeDeleted = YES;
    NSDictionary *relationships = [[self entity] relationshipsByName];
    
    foreach( relationshipName, [relationships allKeys] )
    {
        NSRelationshipDescription *rd = [relationships valueForKey: relationshipName];
        
        if ( ([rd deleteRule] == NSDenyDeleteRule) && ([[self valueForKey: relationshipName] count] > 0) )
        {
            NSString *selfName = [[[self entity] name] lowercaseString];
            NSString *entity = [[[rd destinationEntity] name] lowercaseString];
            int relCardinality = [[self valueForKey: relationshipName] count];
            if ( relCardinality == 1 )
            {
                NSRunAlertPanel( @"Oops!"
                               , @"The %@ you're trying to delete has one %@ using it. You must first remove that %@ from the %@ before you can delete it."
                               , @"OK"
                               , nil
                               , nil
                               , selfName
                               , entity
                               , entity
                               , selfName
                               ) ;
            }
            else
            {
                NSRunAlertPanel( @"Oops!"
                               , @"The %@ you're trying to delete has %d %@s using it. You must first remove those %@s from the %@ before you can delete it."
                               , @"OK"
                               , nil
                               , nil
                               , selfName
                               , relCardinality
                               , entity
                               , entity
                               , selfName
                               ) ;
            }
            canBeDeleted = NO;
        }
    }
    return canBeDeleted;
}

@end
