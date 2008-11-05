//
//  NSTreeController+DSExtensions.h
//  Ampede
//
//  Taken from Will Shipley, at http://www.wilshipley.com/blog/2006/04/pimp-my-code-part-10-whining-about.html
//
//  Created by Erich Ocean.
//  Copyright 2006 Erich Atlas Ocean. All rights reserved.
//

@interface NSTreeController (DMExtensions)

- (BOOL)setSelectedObjects:(NSArray *)newSelectedObjects;
- (NSIndexPath *)indexPathToObject:(id)object;

@end