//
//  NSOutlineView+DSExtensions.m
//  Ampede
//
//  Taken from Will Shipley, at http://www.wilshipley.com/blog/2006/04/pimp-my-code-part-10-whining-about.html
//
//  Created by Erich Ocean.
//  Copyright 2006 Erich Atlas Ocean. All rights reserved.
//

#import "NSOutlineView+DSExtensions.h"


@interface NSOutlineView (DSExtensions_Private)
- (NSTreeController *)_treeController;
- (id)_realItemForOpaqueItem:(id)findOpaqueItem outlineRowIndex:(int *)outlineRowIndex
    items:(NSArray *)items;
@end


@implementation NSOutlineView (DSExtensions)

- (id)realItemForOpaqueItem:(id)opaqueItem;
{
  int outlineRowIndex = 0;
  return [self _realItemForOpaqueItem:opaqueItem outlineRowIndex:&outlineRowIndex
      items:[[self _treeController] content]];
}

@end


@implementation NSOutlineView (DSExtensions_Private)

- (NSTreeController *)_treeController;
{
    return nil;
    // Wil's code doesn't compile, because of contentAttributeKey isn't defined anywhere
    // return (NSTreeController *)[[self infoForBinding:contentAttributeKey] objectForKey:@"NSObservedObject"];
}

- (id)_realItemForOpaqueItem:(id)findOpaqueItem outlineRowIndex:(int *)outlineRowIndex
    items:(NSArray *)items;
{
  unsigned int itemIndex;
  for (itemIndex = 0; itemIndex < [items count] && *outlineRowIndex < [self numberOfRows];
      itemIndex++, (*outlineRowIndex)++) {
    id realItem = [items objectAtIndex:itemIndex];
    id opaqueItem = [self itemAtRow:*outlineRowIndex];
    if (opaqueItem == findOpaqueItem)
      return realItem;
    if ([self isItemExpanded:opaqueItem]) {
      realItem = [self _realItemForOpaqueItem:findOpaqueItem outlineRowIndex:outlineRowIndex
          items:[realItem valueForKeyPath:[[self _treeController] childrenKeyPath]]];
      if (realItem)
        return realItem;
    }
  }

  return nil;
}

@end