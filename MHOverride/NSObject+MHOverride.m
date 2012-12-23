
#import <objc/runtime.h>
#import "NSObject+MHOverride.h"

#if ALSO_OVERRIDE_CLASS_METHOD
static Class OverrideClass(id self, SEL _cmd)
{
	NSString *className = [NSString stringWithUTF8String:object_getClassName(self)];
	NSString *prefix = [NSString stringWithFormat:@"MHOverride_%p_", self];

	if ([className hasPrefix:prefix])
	{
		className = [className substringFromIndex:[prefix length]];
	}

	return objc_getClass([className UTF8String]);
}
#endif

@implementation NSObject (MHOverride)

- (BOOL)mh_overrideSelector:(SEL)selector withBlock:(void *)block
{
	Class selfClass = [self class];
	Class subclass = nil;

	NSString *prefix = [NSString stringWithFormat:@"MHOverride_%p_", self];

#if ALSO_OVERRIDE_CLASS_METHOD
	NSString *className = [NSString stringWithUTF8String:object_getClassName(self)];
#else
	NSString *className = NSStringFromClass(selfClass);
#endif

	if (![className hasPrefix:prefix])
	{
		NSString *name = [prefix stringByAppendingString:className];

		subclass = objc_allocateClassPair(selfClass, [name UTF8String], 0);
		if (subclass == NULL)
		{
			NSLog(@"Could not create subclass");
			return NO;
		}

#if ALSO_OVERRIDE_CLASS_METHOD
		if (!class_addMethod(subclass, @selector(class), (IMP)OverrideClass, "#@:"))
		{
			NSLog(@"Could not add 'class' method to class %@", NSStringFromClass(subclass));
			return NO;
		}
#endif

		objc_registerClassPair(subclass);
		object_setClass(self, subclass);
	}
	else  // object already has an override subclass
	{
#if ALSO_OVERRIDE_CLASS_METHOD
		subclass = objc_getClass([className UTF8String]);
#else
		subclass = selfClass;
#endif
	}

    Method m = class_getInstanceMethod(selfClass, selector);
	if (m == NULL)
	{
		NSLog(@"Could not find method %@ in class %@", NSStringFromSelector(selector), NSStringFromClass(selfClass));
		return NO;
	}

	// See also: http://www.friday.com/bbum/2011/03/17/ios-4-3-imp_implementationwithblock/
	IMP imp = imp_implementationWithBlock((__bridge id)(block));

	if (!class_addMethod(subclass, selector, imp, method_getTypeEncoding(m)))
	{
		NSLog(@"Could not add method %@ to class %@", NSStringFromSelector(selector), NSStringFromClass(subclass));
		return NO;
	}

	return YES;
}

- (void *)mh_superForSelector:(SEL)selector
{
#if ALSO_OVERRIDE_CLASS_METHOD
	return [[self class] instanceMethodForSelector:selector];
#else
	NSString *prefix = [NSString stringWithFormat:@"MHOverride_%p_", self];

	Class theClass = [self class];
	while (theClass != nil)
	{
		NSString *className = NSStringFromClass(theClass);
		theClass = [theClass superclass];

		if ([className hasPrefix:prefix])
			return (void *)[theClass instanceMethodForSelector:selector];
	}

	NSLog(@"Could not find superclass for %@", NSStringFromSelector(selector));
	return NULL;
#endif
}

@end
