
#import "___PROJECTNAMEASIDENTIFIER___MasterViewController.h"
#import "___PROJECTNAMEASIDENTIFIER___SettingsViewController.h"

@interface ___PROJECTNAMEASIDENTIFIER___MasterViewController ()
	-(void) valueDidChangeForSegmentedControl:(id)sender;
@end

#pragma mark -

@implementation ___PROJECTNAMEASIDENTIFIER___MasterViewController

#pragma mark Initializer

-(id) init {
	self = [super initWithStyle:UITableViewStyleGrouped];
	if (!self) {
		return nil;
	}
	return self;
}


#pragma mark UIViewController

-(void) loadView {
	[super loadView];
	self.clearsSelectionOnViewWillAppear = TRUE;
	self.title = @"___PROJECTNAMEASIDENTIFIER___";
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:nil action:nil];
	
	UISegmentedControl *stuffControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Things", @"Stuff", @"Other", nil]];
	stuffControl.segmentedControlStyle = UISegmentedControlStyleBar;
	[stuffControl addTarget:self action:@selector(valueDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged];
	UIBarButtonItem *stuffItem = [[[UIBarButtonItem alloc] initWithCustomView:stuffControl] autorelease];
	[stuffControl release];
	
	UIBarButtonItem *flexibleSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
	self.toolbarItems = [NSArray arrayWithObjects:flexibleSpace, stuffItem, flexibleSpace, nil];
	[self.navigationController setToolbarHidden:FALSE animated:FALSE];
}

-(void) viewDidLoad {
	[super viewDidLoad];
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

-(CGSize) contentSizeForViewInPopover {
	return CGSizeMake(320.0, (self.tableView.rowHeight * ([self.tableView numberOfRowsInSection:1] * [self.tableView numberOfSections])));
}

#pragma mark -

-(void) valueDidChangeForSegmentedControl:(id)sender {
	
}


#pragma mark <UITableViewDataSource>

-(NSInteger) numberOfSectionsInTableView:(UITableView *)aTableView {
	return 2;
}

-(NSInteger) tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
	NSInteger rowCount = 0;
	if (section == 0) {
		rowCount = 1;
	}
	else if (section == 1) {
		rowCount = 2;
	}
	return rowCount;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	NSString *textLabelString = nil;
	if (indexPath.section == 0) {
		textLabelString = @"Modal View";
	}
	else if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			textLabelString = @"Toolbar Detail View";
		}
		else if (indexPath.row == 1) {
			textLabelString = @"NavigationBar Detail View";
		}
	}
	cell.textLabel.text = textLabelString;
	return cell;
}

#pragma mark <UITableViewDelegate>

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.tableView deselectRowAtIndexPath:indexPath animated:TRUE];
	NSString *targetURL = nil;
	if (indexPath.section == 0) {
		targetURL = @"___PROJECTNAMEASIDENTIFIER___://settings";
	}
	else if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			targetURL = @"___PROJECTNAMEASIDENTIFIER___://toolbar";
		}
		else if (indexPath.row == 1) {
			targetURL = @"___PROJECTNAMEASIDENTIFIER___://navigationbar";
		}
	}

	NKNavigatorAction *action = [[NKNavigatorAction alloc] initWithNavigatorURLPath:targetURL];
	if (NKUIDeviceUserIntefaceIdiom() == UIUserInterfaceIdiomPad) {
		NKNavigator *nv = [[NKSplitViewNavigator splitViewNavigator] navigatorForURLPath:targetURL];
		if (nv == [NKSplitViewNavigator splitViewNavigator].detailNavigator) {
			[nv openNavigatorAction:action];
		}
		else {
			[nv openNavigatorAction:action];
		}
	}
	else {
		action.animated = TRUE;
		[[NKNavigator navigator] openNavigatorAction:action];
	}
	[action release];
}


#pragma mark Gozer

-(void) didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

-(void) viewDidUnload {
	[super viewDidUnload];
}

-(void) dealloc {
	[super dealloc];
}

@end
