
#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	NSLog(@"SecondViewController viewDidLoad, self = %@", self);
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	NSLog(@"SecondViewController viewDidAppear, self = %@, animated = %d", self, animated);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)closeButton:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
