
#import "___PROJECTNAMEASIDENTIFIER___NavigationBarViewController.h"

@interface ___PROJECTNAMEASIDENTIFIER___NavigationBarViewController () {
}
@end

#pragma mark -

@implementation ___PROJECTNAMEASIDENTIFIER___NavigationBarViewController

#pragma mark Initializer

-(id) init {
	self = [super initWithNibName:nil bundle:nil];
	if (!self) {
		return nil;
	}
	return self;
}

#pragma mark UIViewController

-(void) loadView {
	[super loadView];
	self.title = @"Navigation Bar Detail";
	self.view.backgroundColor = [UIColor grayColor];
	if (NKUIDeviceUserIntefaceIdiom() == UIUserInterfaceIdiomPad) {
		self.navigationController.navigationBarHidden = TRUE;
		self.navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44.0)];
		self.navigationBar.autoresizingMask	= (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin);
		[self.view addSubview:self.navigationBar];
		[self.navigationBar pushNavigationItem:[[[UINavigationItem alloc] initWithTitle:@"Navigation Bar Detail"] autorelease] 
									  animated:TRUE];
	}
}

-(void) viewDidLoad {
	[super viewDidLoad];
	if (NKUIDeviceUserIntefaceIdiom() == UIUserInterfaceIdiomPad) {
		UIBarButtonItem *masterButtonItem = [NKSplitViewNavigator splitViewNavigator].masterPopoverButtonItem;
		if (masterButtonItem != nil) {
			[self showMasterPopoverButtonItem:masterButtonItem];
		}
	}
}

-(void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

-(void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

-(void) viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return TRUE;
}

#pragma mark <NKSplitViewPopoverButtonDelegate>

-(void) showMasterPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
	if (NKUIDeviceUserIntefaceIdiom() == UIUserInterfaceIdiomPad) {
		[self.navigationBar.topItem setLeftBarButtonItem:barButtonItem animated:TRUE];
	}
}

-(void) invalidateMasterPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
	if (NKUIDeviceUserIntefaceIdiom() == UIUserInterfaceIdiomPad) {
		[self.navigationBar.topItem setLeftBarButtonItem:nil animated:TRUE];
	}
}


#pragma mark Gozer

-(void) didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

-(void) viewDidUnload {
	[super viewDidUnload];
	self.navigationBar = nil;
}

-(void) dealloc {
	self.navigationBar = nil;
	[super dealloc];
}

@end
