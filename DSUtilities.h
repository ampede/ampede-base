//
//  DSUtilities.h
//  Ampede
//
//  Taken from OmniBase/OBUtilities.h
//
//  Created by Erich Ocean.
//  Copyright 2006 Erich Atlas Ocean. All rights reserved.
//

#import <objc/objc.h>
#import <objc/objc-class.h>
#import <objc/objc-runtime.h>
#import "DSAppDefines.h"
#import "DSAssertions.h"

#if defined(__GNUC__)
#define NORETURN __attribute__ ((noreturn))
#else
#define NORETURN
#endif

DS_EXTERN void DSRequestConcreteImplementation(id self, SEL _cmd) NORETURN;
DS_EXTERN void DSRejectUnusedImplementation(id self, SEL _cmd) NORETURN;
DS_EXTERN void DSRejectInvalidCall(id self, SEL _cmd, NSString *format, ...) NORETURN;
DS_EXTERN NSString *DSAbstractImplementation;
DS_EXTERN NSString *DSUnusedImplementation;

#undef NORETURN

DS_EXTERN IMP DSRegisterInstanceMethodWithSelector(Class aClass, SEL oldSelector, SEL newSelector);
/*.doc.
Provides the same functionality as +[NSObject registerInstanceMethod:withMethodTypes:forSelector: but does it without provoking +initialize on the target class.  Returns the original implementation.
*/

DS_EXTERN IMP DSReplaceMethodImplementation(Class aClass, SEL oldSelector, IMP newImp);
/*.doc.
Replaces the given method implementation in place.  Returns the old implementation.
*/

DS_EXTERN IMP DSReplaceMethodImplementationWithSelector(Class aClass, SEL oldSelector, SEL newSelector);
/*.doc.
Calls the above, but determines newImp by looking up the instance method for newSelector.  Returns the old implementation.
*/

DS_EXTERN IMP DSReplaceMethodImplementationWithSelectorOnClass(Class destClass, SEL oldSelector, Class sourceClass, SEL newSelector);
/*.doc.
Calls DSReplaceMethodImplementation.  Derives newImp from newSelector on sourceClass and changes method implementation for oldSelector on destClass.
*/

DS_EXTERN NSString *GetHardwareSerialNumber( void );

// This returns YES if the given pointer is a class object
static inline BOOL DSPointerIsClass(id object)
{
    if (object)
        return CLS_GETINFO((struct objc_class *)(object->isa), CLS_META);
    return NO;
}

// This returns the class object for the given pointer.  For an instance, that means getting the class.  But for a class object, that means returning the pointer itself 

static inline Class DSClassForPointer(id object)
{
    if (!object)
	return object;

    if (DSPointerIsClass(object))
	return object;
    else
	return object->isa;
}

static inline BOOL DSClassIsSubclassOfClass(Class subClass, Class superClass)
{
    while (subClass) {
        if (subClass == superClass)
            return YES;
        else
            subClass = subClass->super_class;
    }
    return NO;
}

static inline NSRect DSRectBetweenTwoPoint(NSPoint startPoint, NSPoint curPoint)
{
	NSRect rect;
	if (startPoint.x > curPoint.x)
	{
		rect.origin.x = curPoint.x;
		rect.size.width = startPoint.x - curPoint.x;
	}
	else
	{
		rect.origin.x = startPoint.x;
		rect.size.width = curPoint.x - startPoint.x;
	}
	if (startPoint.y > curPoint.y)
	{
		rect.origin.y = curPoint.y;
		rect.size.height = startPoint.y - curPoint.y;
	}
	else
	{
		rect.origin.y = startPoint.y;
		rect.size.height = curPoint.y - startPoint.y;
	}
	return rect;
}

// This macro ensures that we call [super initialize] in our +initialize (since this behavior is necessary for some classes in Cocoa), but it keeps custom class initialization from executing more than once.
#define DSINITIALIZE \
    do { \
        static BOOL hasBeenInitialized = NO; \
        [super initialize]; \
        if (hasBeenInitialized) \
            return; \
        hasBeenInitialized = YES;\
    } while (0);

    
#define NSSTRINGIFY(name) @#name

// An easy way to define string constants.  For example, "NSSTRINGIFY(foo)" produces @"foo" and "DEFINE_NSSTRING(foo);" produces: NSString *foo = @"foo";

#define DEFINE_NSSTRING(name) \
	NSString *name = NSSTRINGIFY(name)

// Emits a warning indicating that an obsolete method has been called.

#define DS_WARN_OBSOLETE_METHOD \
    do { \
        static BOOL warned = NO; \
            if (!warned) { \
                warned = YES; \
                    NSLog(@"Warning: obsolete method %c[%@ %s] invoked", DSPointerIsClass(self)?'+':'-', DSClassForPointer(self), _cmd); \
            } \
            DSASSERT_NOT_REACHED("obsolete method called"); \
    } while(0)
