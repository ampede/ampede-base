//
//  DSAssertions.h
//  Ampede
//
//  Taken from OmniBase/assertions.h
//
//  Created by Erich Ocean.
//  Copyright 2006 Erich Atlas Ocean. All rights reserved.
//

#ifndef _DSAssertions_h_
#define _DSAssertions_h_

#import "DSAppDefines.h"
#import <objc/objc.h>

#if defined(DEBUG) || defined(DS_FORCE_ASSERTIONS)
#define DS_ASSERTIONS_ON
#endif

// This allows you to turn off assertions when debugging
#if defined(DS_FORCE_ASSERTIONS_OFF)
#undef DS_ASSERTIONS_ON
#warning Forcing assertions off!
#endif


// Make sure that we don't accidentally use the ASSERT macro instead of DSASSERT
#ifdef ASSERT
#undef ASSERT
#endif

typedef void (*DSAssertionFailureHandler)(const char *type, const char *expression, const char *file, unsigned int lineNumber);

#if defined(DS_ASSERTIONS_ON)

    DS_EXTERN void DSSetAssertionFailureHandler(DSAssertionFailureHandler handler);

    DS_EXTERN void DSAssertFailed(const char *type, const char *expression, const char *file, unsigned int lineNumber);


    #define DSPRECONDITION(expression)                                            \
    do {                                                                        \
        if (!(expression))                                                      \
            DSAssertFailed("PRECONDITION", #expression, __FILE__, __LINE__);    \
    } while (NO)

    #define DSPOSTCONDITION(expression)                                           \
    do {                                                                        \
        if (!(expression))                                                      \
            DSAssertFailed("POSTCONDITION", #expression, __FILE__, __LINE__);   \
    } while (NO)

    #define DSINVARIANT(expression)                                               \
    do {                                                                        \
        if (!(expression))                                                      \
            DSAssertFailed("INVARIANT", #expression, __FILE__, __LINE__);       \
    } while (NO)

    #define DSASSERT(expression)                                                  \
    do {                                                                        \
        if (!(expression))                                                      \
            DSAssertFailed("ASSERT", #expression, __FILE__, __LINE__);          \
    } while (NO)

    #define DSASSERT_NOT_REACHED(reason)                                        \
    do {                                                                        \
        DSAssertFailed("NOTREACHED", reason, __FILE__, __LINE__);              \
    } while (NO)


#else	// else insert blank lines into the code
#warning Assertions are not really being used.
    #define DSPRECONDITION(expression)
    #define DSPOSTCONDITION(expression)
    #define DSINVARIANT(expression)
    #define DSASSERT(expression)
    #define DSASSERT_NOT_REACHED(reason)

#endif


#endif // _DSAssertions_h_
