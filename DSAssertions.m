//
//  DSAssertions.m
//  Ampede
//
//  Created by Erich Ocean.
//  Copyright 2006 Erich Atlas Ocean. All rights reserved.
//

#import "DSAssertions.h"

#ifdef DS_ASSERTIONS_ON
    #warning (Assertions enabled.  To disable, undefine DS_ASSERTIONS_ON.)
#else
    #warning (Assertions disabled.  To enable, define DS_ASSERTIONS_ON.)
#endif

static void DSLogAssertionFailure(const char *type, const char *expression, const char *file, unsigned int lineNumber)
{
    NSLog( @"assertion failure" );
    fprintf(stderr, "%s failed: requires '%s', file %s, line %d\n", type, expression, file, lineNumber);
}

// Some machines (NT, at least) lose the last stack frame when you call abort(), which makes it difficult to debug assertion failures.
// We'll call DSAbort() instead of abort() so that you can set a breakpoint on DSAbort() and not lose the stack frame.

//#ifdef DEBUG

static void DSAbort(const char *type, const char *expression, const char *file, unsigned int lineNumber)
{
    DSLogAssertionFailure(type, expression, file, lineNumber);

    fprintf(stderr, "Aborting (presumably due to assertion failure).\n");
    fflush(stderr);
    abort();
}

//#endif

//
// The default assertion handler
//

#define DSDefaultAssertionHandler DSLogAssertionFailure

#ifdef DS_ASSERTIONS_ON
static NSString *DSShouldAbortOnAssertFailureEnabled = @"DSShouldAbortOnAssertFailureEnabled";
#endif
static DSAssertionFailureHandler currentAssertionHandler = DSDefaultAssertionHandler;

void DSSetAssertionFailureHandler(DSAssertionFailureHandler handler)
{
    if (handler)
        currentAssertionHandler = handler;
    else
        currentAssertionHandler = DSDefaultAssertionHandler;
}

void DSAssertFailed(const char *type, const char *expression, const char *file, unsigned int lineNumber)
{
    currentAssertionHandler(type, expression, file, lineNumber);
}

// Unless DS_PRODUCTION_BUILD is specified, log a message about whether assertions are enabled or not.
#ifndef DS_PRODUCTION_BUILD

#if defined(DS_ASSERTIONS_ON) || defined(DEBUG)
@interface _DSAssertionWarning : NSObject
@end

@implementation _DSAssertionWarning
+ (void)load;
{
#ifdef DS_ASSERTIONS_ON
    NSUserDefaults *userDefaults;
    
    fprintf( stderr, "*** Assertions are ON ***\n" );
    userDefaults = [NSUserDefaults standardUserDefaults];
    if ( [userDefaults boolForKey: DSShouldAbortOnAssertFailureEnabled] )
    {
        DSSetAssertionFailureHandler( DSAbort );
    }
    else if ( NSClassFromString( @"SenTestCase" ) )
    {
        // If we are running unit tests, abort on assertion failure.  We could make assertions throw exceptions, but note that this wouldn't
        // catch cases where you are using 'shouldRaise' and hit an assertion.
        DSSetAssertionFailureHandler(DSAbort);
    }
#elif DEBUG
    fprintf(stderr, "*** Assertions are OFF ***\n");
#endif
}
@end
#endif

#endif // DS_PRODUCTION_BUILD

