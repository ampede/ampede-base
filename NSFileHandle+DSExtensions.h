//
//  NSFileHandle+DSExtensions.h
//  Ampede
//
//  Originally from NSFileHandle_NonBlockingIO.h
//  see http://www.stone.com/GIFfun/GIFfunSource/Bbum_Non_Blocking_IO.html
//
//  Created by Erich Ocean.
//  Copyright 2006 Erich Atlas Ocean. All rights reserved.
//

@interface NSFileHandle ( DSExtensions )

- (NSData *) availableDataNonBlocking;

- (NSData *) readDataToEndOfFileNonBlocking;
- (NSData *) readDataOfLengthNonBlocking: (unsigned int) length;

@end
