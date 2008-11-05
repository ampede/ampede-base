//
//  DSUtilities.m
//  Ampede
//
//  Created by Erich Ocean.
//  Copyright 2006 Erich Atlas Ocean. All rights reserved.
//

#import "DSUtilities.h"

static void _DSRegisterMethod(IMP methodImp, Class class, const char *methodTypes, SEL selector)
{
    struct objc_method_list *newMethodList;

    newMethodList = (struct objc_method_list *) NSZoneMalloc(NSDefaultMallocZone(), sizeof(struct objc_method_list));

    newMethodList->method_count = 1;
    newMethodList->method_list[0].method_name = selector;
    newMethodList->method_list[0].method_imp = methodImp;
    newMethodList->method_list[0].method_types = (char *)methodTypes;

    class_addMethods(class, newMethodList);
}

IMP DSRegisterInstanceMethodWithSelector(Class aClass, SEL oldSelector, SEL newSelector)
{
    struct objc_method *thisMethod;
    IMP oldImp = NULL;

    if ((thisMethod = class_getInstanceMethod(aClass, oldSelector))) {
        oldImp = thisMethod->method_imp;
        _DSRegisterMethod(thisMethod->method_imp, aClass, thisMethod->method_types, newSelector);
    }

    return oldImp;
}

IMP DSReplaceMethodImplementation(Class aClass, SEL oldSelector, IMP newImp)
{
    struct objc_method *thisMethod;
    IMP oldImp = NULL;
    extern void _objc_flush_caches(Class);

    if ((thisMethod = class_getInstanceMethod(aClass, oldSelector))) {
        oldImp = thisMethod->method_imp;

        // Replace the method in place
        thisMethod->method_imp = newImp;

        // Flush the method cache
        _objc_flush_caches(aClass);
    }

    return oldImp;
}

IMP DSReplaceMethodImplementationWithSelector(Class aClass, SEL oldSelector, SEL newSelector)
{
    struct objc_method *newMethod;

    newMethod = class_getInstanceMethod(aClass, newSelector);
    DSASSERT(newMethod);
    
    return DSReplaceMethodImplementation(aClass, oldSelector, newMethod->method_imp);
}

IMP DSReplaceMethodImplementationWithSelectorOnClass(Class destClass, SEL oldSelector, Class sourceClass, SEL newSelector)
{
    struct objc_method *newMethod;

    newMethod = class_getInstanceMethod(sourceClass, newSelector);
    DSASSERT(newMethod);

    return DSReplaceMethodImplementation(destClass, oldSelector, newMethod->method_imp);
}

void DSRequestConcreteImplementation(id self, SEL _cmd)
{
    DSASSERT_NOT_REACHED("Concrete implementation needed");
    [NSException raise:DSAbstractImplementation format:@"%@ needs a concrete implementation of %c%s", [self class], DSPointerIsClass(self) ? '+' : '-', sel_getName(_cmd)];
    exit(1);  // notreached, but needed to pacify the compiler
}

void DSRejectUnusedImplementation(id self, SEL _cmd)
{
    DSASSERT_NOT_REACHED("Subclass rejects unused implementation");
    [NSException raise:DSUnusedImplementation format:@"%c[%@ %s] should not be invoked", DSPointerIsClass(self) ? '+' : '-', DSClassForPointer(self), sel_getName(_cmd)];
    exit(1);  // notreached, but needed to pacify the compiler
}

void DSRejectInvalidCall(id self, SEL _cmd, NSString *format, ...)
{
    const char *className, *methodName;
    NSString *complaint, *reasonString;
    va_list argv;

    className = DSClassForPointer(self)->name;
    methodName = sel_getName(_cmd);
    va_start(argv, format);
    complaint = [[NSString alloc] initWithFormat:format arguments:argv];
    va_end(argv);
    reasonString = [NSString stringWithFormat:@"%c[%s %s] %@", DSPointerIsClass(self) ? '+' : '-', className, methodName, complaint];
    [complaint release];
    [[NSException exceptionWithName:NSInvalidArgumentException reason:reasonString userInfo:nil] raise];
    exit(1);  // notreached, but needed to pacify the compiler
}

DEFINE_NSSTRING(DSAbstractImplementation);
DEFINE_NSSTRING(DSUnusedImplementation);

#include <CoreFoundation/CoreFoundation.h>
#include <IOKit/IOKitLib.h>

// Returns the serial number as an NSString.
// Taken from Apple TN1103: Uniquely Identifying a Macintosh Computer
NSString *
GetHardwareSerialNumber( void )
{
    CFTypeRef serialNumberAsCFString = NULL;
    io_service_t platformExpert = IOServiceGetMatchingService( kIOMasterPortDefault
                                                             , IOServiceMatching( "IOPlatformExpertDevice" )
                                                             ) ;

    if ( platformExpert )
    {
        serialNumberAsCFString = IORegistryEntryCreateCFProperty( platformExpert
                                                                , CFSTR( kIOPlatformSerialNumberKey )
                                                                , kCFAllocatorDefault
                                                                , 0
                                                                ) ;

        IOObjectRelease( platformExpert );
    }
    return [(NSString *)serialNumberAsCFString autorelease];
}
