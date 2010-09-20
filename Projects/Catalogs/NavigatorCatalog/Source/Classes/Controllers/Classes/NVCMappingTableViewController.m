
#import "NVCMappingTableViewController.h"

@implementation NVCMappingTableViewController

#pragma mark Initializer

-(id) init {
	self = [super initWithStyle:UITableViewStyleGrouped];
	if (!self) {
		return nil;
	}
	self.title = @"Mappings";
	UIImage *image = [UIImage imageNamed:@"map.png"];
	self.tabBarItem	= [[[UITabBarItem alloc] initWithTitle:self.title image:image tag:6] autorelease];
	return self;
}


#pragma mark UIViewController

-(void) loadView {
	[super loadView];
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

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tv {
    return 1;
}

-(NSInteger) tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    return 0;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MappingCellID = @"MappingCellID";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MappingCellID];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MappingCellID] autorelease];
	}
	return cell;
}


#pragma mark <UITableViewDelegate>

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


#pragma mark Memory

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
