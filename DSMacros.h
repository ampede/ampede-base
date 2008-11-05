//
//  DSMacros.h
//  Ampede
//
//  Taken from OmniBase/OBUtilities.h
//
//  Created by Erich Ocean.
//  Copyright 2006 Erich Atlas Ocean. All rights reserved.
//

#define METHOD_LOG \
do { \
    if ( [self class] == (Class)self ) \
    { \
        NSLog( @"+[%@ %@]", [self class], NSStringFromSelector( _cmd )); \
    } \
    else \
    { \
        NSLog( @"-[%@ %@]", [self class], NSStringFromSelector( _cmd )); \
    } \
} while ( 0 )
#define LOG METHOD_LOG;
#define LOGO( objekt ) METHOD_LOG; NSLog(@"-> %@", objekt);
#define LOGS METHOD_LOG; NSLog(@"-> %@", self);
#define METHOD_STRING (( [self class] == (Class)self ) ? [NSString stringWithFormat:@"+[%@ %@]", [self class], NSStringFromSelector(_cmd)] : [NSString stringWithFormat:@"-[%@ %@]", [self class], NSStringFromSelector(_cmd)])

#define release( objekt ) [objekt release]; objekt = nil;

//
// from http://mjtsai.com/blog/2006/07/15/cocoa-foreach-macro/
//
#define foreachGetEnumerator(c) \
    ([c respondsToSelector:@selector(objectEnumerator)] ? \
     [c objectEnumerator] : \
     c)
#define foreacht(type, object, collection) \
for ( id foreachCollection = collection; \
      foreachCollection; \
      foreachCollection = nil ) \
    for ( id foreachEnum = foreachGetEnumerator(foreachCollection); \
          foreachEnum; \
          foreachEnum = nil ) \
        for ( IMP foreachNext = [foreachEnum methodForSelector:@selector(nextObject)]; \
              foreachNext; \
              foreachNext = NULL ) \
            for ( type object = foreachNext(foreachEnum, @selector(nextObject)); \
                  object; \
                  object = foreachNext(foreachEnum, @selector(nextObject)) )

#define foreach(object, collection) foreacht(id, object, (collection))