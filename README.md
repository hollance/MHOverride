# NSObject+MHOverride

Sometimes making a subclass is just too much work. :-) This category lets you override one or more methods of an existing class using blocks:

    [someViewController mh_overrideSelector:@selector(viewDidAppear:)
    	withBlock:(__bridge void *) ^(id _self, BOOL animated)
    	{
    		// ... do your stuff here ...
    		// _self refers to the object whose method you are overriding
    	}];

This is done by dynamically making a new subclass just for the object whose methods you are overriding and swapping the classes at runtime.

The only tricky bit is calling the original version of the overridden method. You need to get pointer to that function and call it:

    SEL sel = @selector(viewDidAppear:);
    void (*superIMP)(id, SEL, BOOL) = [_self mh_superForSelector:sel];
    superIMP(_self, sel, animated);

Not very pretty, but it works.

If the define `ALSO_OVERRIDE_CLASS_METHOD` is set to 1, then the `+class` method is overridden to return the *old* class name and no one will be the wiser.

See the demo project to get an idea of how to use this.
