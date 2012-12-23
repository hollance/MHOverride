
#import <objc/runtime.h>
#import "AppDelegate.h"
#import "NSObject+MHOverride.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Override FirstViewController's viewDidLoad method:

	[self.window.rootViewController mh_overrideSelector:@selector(viewDidLoad) withBlock:(__bridge void *) ^(id _self)
	{
		// Call super the hard way:
		Class superclass = NSClassFromString(@"FirstViewController");
		void (*superIMP)(id, SEL) = (void *)[superclass instanceMethodForSelector:@selector(viewDidLoad)];
		superIMP(_self, @selector(viewDidLoad));

		NSLog(@"FirstViewController *Override* viewDidLoad, _self = %@", _self);
	}];

	// Override FirstViewController's viewDidAppear: method:

	[self.window.rootViewController mh_overrideSelector:@selector(viewDidAppear:) withBlock:(__bridge void *) ^(id _self, BOOL animated)
	{
		// Call super the slightly-easier way:
		SEL sel = @selector(viewDidAppear:);
		void (*superIMP)(id, SEL, BOOL) = [_self mh_superForSelector:sel];
		superIMP(_self, sel, animated);

		// Or in one line:
		//((void (*)(id, SEL, BOOL))[_self mh_superForSelector:@selector(viewDidAppear:)])(_self, @selector(viewDidAppear:), animated);

		NSLog(@"FirstViewController *Override* viewDidAppear, _self = %@, animated = %d", _self, animated);
	}];

	// Print out what the -class method and objc_getClassName report as the
	// name of the root view controller's class. The output of these depend
	// on the value of the ALSO_OVERRIDE_CLASS_METHOD define.

	NSLog(@"rootViewController -class: %@", NSStringFromClass([self.window.rootViewController class]));
	NSLog(@"rootViewController objc_getClassName: %s", object_getClassName(self.window.rootViewController));

	return YES;
}

@end
