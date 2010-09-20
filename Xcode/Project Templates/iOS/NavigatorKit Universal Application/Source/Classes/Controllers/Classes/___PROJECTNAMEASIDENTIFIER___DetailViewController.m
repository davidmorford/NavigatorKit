
#import "___PROJECTNAMEASIDENTIFIER___DetailViewController.h"

@interface ___PROJECTNAMEASIDENTIFIER___DetailViewController () {
}
@end

#pragma mark -

@implementation ___PROJECTNAMEASIDENTIFIER___DetailViewController

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
	self.title = @"Detail";
	self.view.backgroundColor = [UIColor darkGrayColor];
	if (NKUIDeviceUserIntefaceIdiom() == UIUserInterfaceIdiomPad) {
		self.navigationController.navigationBarHidden = TRUE;
		self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44.0)];
		self.toolbar.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin);
		UIBarButtonItem *flexyBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		[self.toolbar setItems:[NSArray arrayWithObject:flexyBarItem]];
		[flexyBarItem release];
		[self.view addSubview:self.toolbar];
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
		NSMutableArray *itemsArray = [self.toolbar.items mutableCopy];
		NSLog(@"Toolbar Items = %@", itemsArray);
		[itemsArray insertObject:barButtonItem atIndex:0];
		[self.toolbar setItems:itemsArray animated:TRUE];
		[itemsArray release];
	}
}

-(void) invalidateMasterPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
	if (NKUIDeviceUserIntefaceIdiom() == UIUserInterfaceIdiomPad) {
		NSMutableArray *itemsArray = [self.toolbar.items mutableCopy];
		[itemsArray removeObject:barButtonItem];
		[self.toolbar setItems:itemsArray animated:TRUE];
		[itemsArray release];
	}
}


#pragma mark Gozer

-(void) didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

-(void) viewDidUnload {
	[super viewDidLoad];
	self.toolbar = nil;
}

-(void) dealloc {
	self.toolbar = nil;
	[super dealloc];
}

@end
