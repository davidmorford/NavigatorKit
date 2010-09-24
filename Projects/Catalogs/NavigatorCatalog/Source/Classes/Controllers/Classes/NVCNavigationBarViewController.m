
#import "NVCNavigationBarViewController.h"
#import "NVCBackgroundView.h"

@interface NVCNavigationBarViewController () {
}
@end

#pragma mark -

@implementation NVCNavigationBarViewController

#pragma mark Initializer

-(id) init {
	self = [super initWithNibName:nil bundle:nil];
	if (!self) {
		return nil;
	}
	self.hidesBottomBarWhenPushed = TRUE;
	return self;
}

#pragma mark UIViewController


-(void) loadView {
	[super loadView];
	self.title = @"Navigation Bar";
	self.view.backgroundColor = [UIColor lightGrayColor];
	if (NKUIDeviceUserIntefaceIdiom() == UIUserInterfaceIdiomPad) {
		self.navigationController.navigationBarHidden = TRUE;
		self.navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44.0)];
		self.navigationBar.autoresizingMask	= (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin);
		[self.view addSubview:self.navigationBar];
		[self.navigationBar pushNavigationItem:[[[UINavigationItem alloc] initWithTitle:@"Navigation Bar"] autorelease] 
									  animated:TRUE];
	}
}

-(void) viewDidLoad {
	[super viewDidLoad];
	if (NKUIDeviceUserIntefaceIdiom() == UIUserInterfaceIdiomPad) {
		NSArray *optionItems = [NSArray arrayWithObjects:[UIImage imageNamed:@"Fullscreen.png"], [UIImage imageNamed:@"MasterArrow-Bottom.png"], [UIImage imageNamed:@"DividerShow.png"], [UIImage imageNamed:@"MasterArrow-Right.png"], nil];
		self.optionsSegmentedControl = [[UISegmentedControl alloc] initWithItems:optionItems];
		self.optionsSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
		self.optionsSegmentedControl.momentary = TRUE;
		[self.optionsSegmentedControl addTarget:self action:@selector(didSelectOption:) forControlEvents:UIControlEventValueChanged];
		self.optionsItem = [[UIBarButtonItem alloc] initWithCustomView:self.optionsSegmentedControl];
		[self.navigationBar.topItem setRightBarButtonItem:self.optionsItem animated:TRUE];

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


#pragma mark Actions

-(void) didSelectOption:(id)sender {
	if (self.optionsSegmentedControl.selectedSegmentIndex == 0) {
		[self toggleMasterView:self];
	}
	else if (self.optionsSegmentedControl.selectedSegmentIndex == 1) {
		[self toggleVertical:self];
	}
	else if (self.optionsSegmentedControl.selectedSegmentIndex == 2) {
		[self toggleDividerStyle:self];
	}
	else if (self.optionsSegmentedControl.selectedSegmentIndex == 3) {
		[self toggleMasterBeforeDetail:self];
	}
}

-(void) toggleMasterView:(id)sender {
	[[NKSplitViewNavigator splitViewNavigator].splitViewController toggleMasterView:sender];
}

-(void) toggleVertical:(id)sender {
	[[NKSplitViewNavigator splitViewNavigator].splitViewController toggleSplitOrientation:self];
}

-(void) toggleDividerStyle:(id)sender {
	NKSplitViewController *splitController = [NKSplitViewNavigator splitViewNavigator].splitViewController;
	NKSplitViewDividerStyle newStyle = ((splitController.dividerStyle == NKSplitViewDividerStyleThin) ? NKSplitViewDividerStylePaneSplitter : NKSplitViewDividerStyleThin);
	[splitController setDividerStyle:newStyle animated:YES];
}

-(void) toggleMasterBeforeDetail:(id)sender {
	[[NKSplitViewNavigator splitViewNavigator].splitViewController toggleMasterBeforeDetail:sender];
}


#pragma mark Gozer

-(void) didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

-(void) viewDidUnload {
	self.optionsItem = nil;
	self.optionsSegmentedControl = nil;
	self.navigationBar = nil;
	[super viewDidUnload];
}

-(void) dealloc {
	self.optionsItem = nil;
	self.optionsSegmentedControl = nil;
	self.navigationBar = nil;
	[super dealloc];
}

@end
