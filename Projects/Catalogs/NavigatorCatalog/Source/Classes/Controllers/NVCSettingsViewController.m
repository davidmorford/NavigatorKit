
#import "NVCSettingsViewController.h"

@implementation NVCSettingsViewController

#pragma mark Initializers

-(id) init {
	self = [super initWithStyle:UITableViewStyleGrouped];
	if (!self) {
		return nil;
	}
	self.title = @"Settings";
	if (NKUIDeviceUserIntefaceIdiom() == UIUserInterfaceIdiomPad) {
		self.modalPresentationStyle = UIModalPresentationFormSheet;
	}
	return self;
}

#pragma mark UIViewController

-(void) loadView {
	[super loadView];
	if (self.isModal) {
		self.navigationItem.leftBarButtonItem	= [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissModalViewController)] autorelease];
		self.navigationItem.rightBarButtonItem	= [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissModalViewController)] autorelease];
	}
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
		rowCount = 1;
	}
	return rowCount;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	NSString *textLabelString = nil;
	if (indexPath.section == 0) {
		textLabelString = @"Option A";
	}
	else if (indexPath.section == 1) {
		textLabelString = @"Option B";
	}
	cell.textLabel.text = textLabelString;
	return cell;
}

#pragma mark <UITableViewDelegate>

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.tableView deselectRowAtIndexPath:indexPath animated:TRUE];
}


#pragma mark Memory

-(void) viewDidUnload {
	[super viewDidUnload];
}

-(void) didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

-(void) dealloc {
	[super dealloc];
}

@end
