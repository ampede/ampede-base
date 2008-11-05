//
//  NSFileHandle+DSExtensions.m
//  Ampede
//
//  Created by Erich Ocean.
//  Copyright 2006 Erich Atlas Ocean. All rights reserved.
//

#import "NSFileHandle+DSExtensions.h"
#import <bsd/libc.h>

@implementation NSFileHandle ( DSExtensions )

//
// Adds non-blocking I/O API to NSFileHandle.
//

// Returns an NSData object containing all of the currently available data. Does not block if there is no data; returns nil instead.
- (NSData *) availableDataNonBlocking
{
    return [self readDataOfLengthNonBlocking: UINT_MAX];
}

// Returns an NSData object containing all of the currently available data. Does not block if there is no data; returns nil instead.
// Cover for -availableDataNonBlocking
- (NSData *) readDataToEndOfFileNonBlocking
{
    return [self readDataOfLengthNonBlocking: UINT_MAX];
}

- (unsigned int) _availableByteCountNonBlocking
{
    int numBytes;
    int fd = [self fileDescriptor];

    if ( ioctl (fd, FIONREAD, (char *) &numBytes ) == -1 )
    {
        [NSException raise: NSFileHandleOperationException
        format: @"ioctl() Err # %d", errno];
    }

    return numBytes;
}

// Reads up to length bytes of data from the file handle. If no data is available, returns nil. Does not block.
- (NSData *) readDataOfLengthNonBlocking: (unsigned int) length
{
    unsigned int readLength;

    readLength = [self _availableByteCountNonBlocking];
    readLength = ( readLength < length ) ? readLength : length;

    return ( readLength == 0 ) ? nil : [self readDataOfLength: readLength];
}

@end
