//
//  NSTreeController+DSExtensions.m
//  Ampede
//
//  Taken from Will Shipley, at http://www.wilshipley.com/blog/2006/04/pimp-my-code-part-10-whining-about.html
//  Substantially modified.
//
//  Created by Erich Ocean.
//  Copyright 2006 Erich Atlas Ocean. All rights reserved.
//

#import "NSTreeController+DSExtensions.h"


@interface NSTreeController (DSExtensions_Private)
- (NSIndexPath *)_indexPathFromIndexPath:(NSIndexPath *)baseIndexPath inChildren:(id)children
    childCount:(unsigned int)childCount toObject:(id)object;
@end


@implementation NSTreeController (DSExtensions)

- (BOOL)
setSelectedObjects: (NSArray *) newSelectedObjects;
{
    NSMutableArray *indexPaths = [NSMutableArray array];

    foreach ( selectedObject, newSelectedObjects )
    {
        NSIndexPath *indexPath = [self indexPathToObject: selectedObject];
        if ( indexPath ) [indexPaths addObject: indexPath];
    }

    return [self setSelectionIndexPaths: indexPaths];
}

- (NSIndexPath *)
indexPathToObject: (id) object
{
  NSArray *children = [self content];
  return [self _indexPathFromIndexPath: nil
               inChildren:              children
               childCount:              [children count]
               toObject:                object         ];
}

@end


@implementation NSTreeController (DSExtensions_Private)

- (NSIndexPath *)
_indexPathFromIndexPath: (NSIndexPath *) baseIndexPath
inChildren:              (id)            children      // we expect an array, but can get a set due to Core Data faulting, which foreach handles but Wil's code doesn't
childCount:              (unsigned int)  childCount
toObject:                (id)            object
{
    unsigned int childIndex = -1;
    foreach( childObject, children )
    {
        childIndex++;
        NSArray *childsChildren = nil;
        unsigned int childsChildrenCount = 0;
        NSString *leafKeyPath = [self leafKeyPath];
        if (!leafKeyPath || [[childObject valueForKey:leafKeyPath] boolValue] == NO)
        {
            NSString *countKeyPath = [self countKeyPath];
            if ( countKeyPath ) childsChildrenCount = [[childObject valueForKey: leafKeyPath] unsignedIntValue];
            if ( !countKeyPath || childsChildrenCount != 0 )
            {
                NSString *childrenKeyPath = [self childrenKeyPath];
                
                childsChildren = [childObject valueForKey: childrenKeyPath];
                if ( !countKeyPath ) childsChildrenCount = [childsChildren count];
            }
        }

        BOOL objectFound = [object isEqual: childObject];
        if ( !objectFound && childsChildrenCount == 0 ) continue;

        NSIndexPath *indexPath = ( baseIndexPath == nil ) ? [NSIndexPath indexPathWithIndex: childIndex] : [baseIndexPath indexPathByAddingIndex: childIndex];

        if ( objectFound ) return indexPath;

        NSIndexPath *childIndexPath = [self _indexPathFromIndexPath: indexPath
                                            inChildren:              childsChildren
                                            childCount:              childsChildrenCount
                                            toObject:                object             ];
        if ( childIndexPath ) return childIndexPath;
    }

    return nil;
}

@end
