
#import "FirstViewController.h"
#import "NSObject+MHOverride.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	NSLog(@"FirstViewController viewDidLoad, self = %@", self);
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	NSLog(@"FirstViewController viewDidAppear, self = %@, animated = %d", self, animated);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"OpenSecondViewController"])
	{
		// Override some of the methods of SecondViewController:

		[segue.destinationViewController
			mh_overrideSelector:@selector(viewDidLoad)
			withBlock:(__bridge void *) ^(id _self)
			{
				NSLog(@"SecondViewController *Override* viewDidLoad, _self = %@", _self);
			}];

		[segue.destinationViewController
			mh_overrideSelector:@selector(viewDidAppear:)
			withBlock:(__bridge void *) ^(id _self, BOOL animated)
			{
				NSLog(@"SecondViewController *Override* viewDidAppear, _self = %@, animated = %d", _self, animated);
			}];

		[segue.destinationViewController
			mh_overrideSelector:@selector(shouldAutorotateToInterfaceOrientation:)
			withBlock:(__bridge void *) ^(id _self, UIInterfaceOrientation interfaceOrientation)
			{
				return UIInterfaceOrientationIsPortrait(interfaceOrientation);
			}];
	}
}

@end
