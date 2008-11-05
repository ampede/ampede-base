//
//  NSManagedObjectContext+DSExtensions.h
//  Ampede
//
//  Created by Erich Ocean on 11/20/06.
//  Copyright 2006 Erich Atlas Ocean. All rights reserved.
//

@interface NSManagedObjectContext ( DSExtensions )

- (NSManagedObject *) insertNewObjectForEntityNamed: (NSString *) anEntityName;

@end
