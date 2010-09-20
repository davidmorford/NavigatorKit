
#import "___PROJECTNAMEASIDENTIFIER___MasterViewController.h"

@implementation ___PROJECTNAMEASIDENTIFIER___MasterViewController

#pragma mark -

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
	self.title = @"___PROJECTNAMEASIDENTIFIER___";
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
	return CGSizeMake(320.0, self.tableView.rowHeight * [self.tableView numberOfRowsInSection:0]);
}


#pragma mark <UITableViewDataSource>

-(NSInteger) numberOfSectionsInTableView:(UITableView *)aTableView {
	return 1;
}

-(NSInteger) tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
	return 10;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	cell.textLabel.text = [NSString stringWithFormat:@"Item %d", indexPath.row];
	return cell;
}

#pragma mark <UITableViewDelegate>

-(void) tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}


#pragma mark Gozer

-(void) didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

-(void) viewDidUnload {

}

-(void) dealloc {
	[super dealloc];
}

@end
