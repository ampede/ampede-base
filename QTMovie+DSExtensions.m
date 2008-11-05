//
//  QTMovie+DSExtensions.m
//  Ampede
//
//  Created by Erich Ocean.
//  Copyright 2006 Erich Atlas Ocean. All rights reserved.
//

#import "QTMovie+DSExtensions.h"

@implementation QTMovie ( DSExtensions )

+ (NSArray *)
moviesWithPasteboard: (NSPasteboard *) pasteboard
{
    NSMutableArray *ary = [NSMutableArray array];
    
    NSArray *pbtypes = [pasteboard types];
    
    if ( [pbtypes containsObject: NSFilenamesPboardType] )
    {
        NSArray *movieFileNames = [pasteboard propertyListForType: NSFilenamesPboardType];
        if ( [movieFileNames count] )
        {
            int count = [movieFileNames count];
            count--;
            while ( count >= 0 )
            {
                NSError *err = nil;
                QTMovie *mov = [QTMovie movieWithFile: [movieFileNames objectAtIndex: count]
                                        error:         &err ];
                if ( !err ) [ary addObject: mov];
                else release( err );
                
                count--;
            }
        }
    }
    return ary;
}

@end

