
#import "NVCContentTableViewController.h"

@implementation NVCContentTableViewController

#pragma mark -

-(id) initWithTitle:(NSString *)aName {
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
		NSString *imageName = nil;
		NSString *tabTitle = nil;
		NSInteger tag = 1;
		if ([aName compare:@"navigation" options:NSLiteralSearch] == NSOrderedSame) {
			imageName = @"routes.png";
			tabTitle = @"Navigation";
		}
		else if ([aName compare:@"modal" options:NSLiteralSearch] == NSOrderedSame) {
			imageName = @"modal.png";
			tabTitle = @"Modal";
			tag++;
		}
		else if ([aName compare:@"popup" options:NSLiteralSearch] == NSOrderedSame) {
			imageName = @"popup.png";
			tabTitle = @"Popup";
			tag++;
		}
		else if ([aName compare:@"actions" options:NSLiteralSearch] == NSOrderedSame) {
			imageName = @"action.png";
			tabTitle = @"Actions";
			tag++;
		}
		else if ([aName compare:@"external" options:NSLiteralSearch] == NSOrderedSame) {
			imageName = @"at.png";
			tabTitle = @"External";
			tag++;
		}
		self.title = tabTitle;
		UIImage *image = [UIImage imageNamed:imageName];
		self.tabBarItem	= [[[UITabBarItem alloc] initWithTitle:self.title image:image tag:tag] autorelease];
	}
	return self;
}


#pragma mark -

-(void) loadView {
	[super loadView];
	self.tableView.rowHeight = 72;
}

-(void) viewDidLoad {
	[super viewDidLoad];
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return TRUE;
}


#pragma mark <UITableViewDataSource>

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	NSInteger sectionCount = 1;
	/*if ([self.title compare:@"Navigation" options:NSLiteralSearch] == NSOrderedSame) {
		sectionCount = 1;
	}
	else if ([self.title compare:@"Modal" options:NSLiteralSearch] == NSOrderedSame) {
		sectionCount = 1;
	}
	else if ([self.title compare:@"Popup" options:NSLiteralSearch] == NSOrderedSame) {
		sectionCount = 1;
	}
	else if ([self.title compare:@"Actions" options:NSLiteralSearch] == NSOrderedSame) {
		sectionCount = 1;
	}
	else if ([self.title compare:@"External" options:NSLiteralSearch] == NSOrderedSame) {
		sectionCount = 1;
	}*/
	return sectionCount;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger rowCount = 0;
	if ([self.title compare:@"Navigation" options:NSLiteralSearch] == NSOrderedSame) {
		rowCount = 2;
	}
	else if ([self.title compare:@"Modal" options:NSLiteralSearch] == NSOrderedSame) {
		rowCount = 1;
	}
	else if ([self.title compare:@"Popup" options:NSLiteralSearch] == NSOrderedSame) {
		rowCount = 2;
	}
	else if ([self.title compare:@"Actions" options:NSLiteralSearch] == NSOrderedSame) {
		rowCount = 0;
	}
	else if ([self.title compare:@"External" options:NSLiteralSearch] == NSOrderedSame) {
		rowCount = 1;
	}
	return rowCount;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	NSString *textLabelString = nil;
	NSString *detailTextLabelString = nil;

	if ([self.title compare:@"Navigation" options:NSLiteralSearch] == NSOrderedSame) {
		if (indexPath.row == 0) {
			textLabelString = @"Toolbar Detail View";
			detailTextLabelString = @"UIToolbar used with the split view controller on iPad.";
		}
		else if (indexPath.row == 1) {
			textLabelString = @"NavigationBar Detail View";
			detailTextLabelString = @"UINavigationBar used with split view controller on iPad.";
		}
	}
	else if ([self.title compare:@"Modal" options:NSLiteralSearch] == NSOrderedSame) {
		if (indexPath.row == 0) {
			textLabelString = @"Modal View Controller";
			detailTextLabelString = @"Uses fullscreen presentation styl in iPhone and FormSheet style on iPad.";
		}
	}
	else if ([self.title compare:@"Popup" options:NSLiteralSearch] == NSOrderedSame) {
		if (indexPath.row == 0) {
			textLabelString = @"Alert View";
			detailTextLabelString = @"Display a simple alert view hello mesage.";
		}
		else if (indexPath.row == 1) {
			textLabelString = @"Action Sheet";
			detailTextLabelString = @"Display an Action Sheet that opens a URL in Safari.";
		}
	}
	else if ([self.title compare:@"Actions" options:NSLiteralSearch] == NSOrderedSame) {
		if (indexPath.row == 0) {
		}
		else if (indexPath.row == 1) {
		}
	}
	else if ([self.title compare:@"External" options:NSLiteralSearch] == NSOrderedSame) {
		if (indexPath.row == 0) {
			textLabelString = @"Open URL in Safari";
			detailTextLabelString = @"...";
		}
	}
	cell.textLabel.text = textLabelString;
	cell.detailTextLabel.text = detailTextLabelString;
	cell.detailTextLabel.numberOfLines = 2;
	return cell;
}


#pragma mark <UITableViewDelegate>

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.tableView deselectRowAtIndexPath:indexPath animated:TRUE];
	NSString *targetURL = nil;

	if ([self.title compare:@"Navigation" options:NSLiteralSearch] == NSOrderedSame) {
		if (indexPath.row == 0) {
			targetURL = @"navigatorcatalog://toolbar";
		}
		else if (indexPath.row == 1) {
			targetURL = @"navigatorcatalog://navigationbar";
		}
	}
	else if ([self.title compare:@"Modal" options:NSLiteralSearch] == NSOrderedSame) {
		if (indexPath.row == 0) {
			targetURL = @"navigatorcatalog://settings";
		}
	}
	else if ([self.title compare:@"Popup" options:NSLiteralSearch] == NSOrderedSame) {
		if (indexPath.row == 0) {
			targetURL = @"navigatorcatalog:///hello/dave";
		}
		else if (indexPath.row == 1) {
			targetURL = @"navigatorcatalog://confirm/openURL";
		}
	}
	else if ([self.title compare:@"Actions" options:NSLiteralSearch] == NSOrderedSame) {

	}
	else if ([self.title compare:@"External" options:NSLiteralSearch] == NSOrderedSame) {

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

#pragma mark Memory management

-(void) didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

-(void) viewDidUnload {
}

-(void) dealloc {
	[super dealloc];
}

@end
