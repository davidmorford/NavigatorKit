
#import "NVCDocumentsFolderViewController.h"
#import "NVCDetailViewController.h"
#import "NVCApplicationDelegate.h"

#include <MobileCoreServices/MobileCoreServices.h>

@interface NVCDocumentsFolderViewController ()
	@property (nonatomic, retain) NSArray *documents;
	@property (nonatomic, copy) NSString *documentsPath;
	@property (nonatomic, retain) NSMutableArray *documentAttributes;
@end

#pragma mark -

@implementation NVCDocumentsFolderViewController

	#pragma mark -

	-(id) init {
		self = [super initWithStyle:UITableViewStylePlain];
		if (!self) {
			return nil;
		}
		//self.contentSizeForViewInPopover = CGSizeMake(320.0, 500.0);
		self.clearsSelectionOnViewWillAppear = FALSE;
		self.title = @"Documents";
		UIImage *image = [UIImage imageNamed:@"documents.png"];
		self.tabBarItem	= [[[UITabBarItem alloc] initWithTitle:self.title image:image tag:8] autorelease];
		return self;
	}

	#pragma mark UIViewController

	-(void) loadView {
		[super loadView];
		if (self.documentsPath == nil) {
			self.documentsPath = [NVCApplicationDelegate sharedApplicationDelegate].applicationDocumentsDirectoryPath;
		}
		
		NSError *error = nil;
		self.documents = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.documentsPath error:&error] copy];
		if (error) {
			return;
		}
		
		self.documentAttributes = [[NSMutableArray alloc] initWithCapacity:[self.documents count]];
		for (NSString *filename in self.documents) {
			error = nil;
			NSString *path		= [self.documentsPath stringByAppendingPathComponent:filename];
			NSDictionary *dict	= [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
			if (error) {
				[self.documentAttributes addObject:[NSNull null]];
			}
			else {
				[self.documentAttributes addObject:dict];
			}
		}
		[self.tableView reloadData];
	}

	-(void) viewWillAppear:(BOOL)animated {
		[super viewWillAppear:animated];
	}

	-(void) viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];
	}

	-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
		return YES;
	}


	#pragma mark <UITableViewDataSource>

	-(NSInteger) numberOfSectionsInTableView:(UITableView *)aTableView {
		return 1;
	}

	-(NSInteger) tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
		return [self.documents count];
	}

	-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
		static NSString *NVCDocumentsItemCellIdentifier = @"NVCDocumentsItemCellIdentifier";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NVCDocumentsItemCellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NVCDocumentsItemCellIdentifier] autorelease];
		}
		
		id obj = [self.documentAttributes objectAtIndex:indexPath.row];
		NSString *fileName = [self.documents objectAtIndex:indexPath.row];
		NSString *fileUTI = (NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (CFStringRef)[fileName pathExtension], NULL);

		UIImage *fileTypeImage = nil;
		if (obj == [NSNull null]) {
			cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		}
		else if ([[obj fileType] compare:NSFileTypeDirectory options:NSLiteralSearch] == NSOrderedSame) {
			fileTypeImage		= [UIImage imageNamed:@"Folder.png"];
			cell.accessoryType	= UITableViewCellAccessoryDetailDisclosureButton;
		}
		else if ([[obj fileType] compare:NSFileType options:NSLiteralSearch] == NSOrderedSame ||
				 [[obj fileType] compare:NSFileTypeRegular options:NSLiteralSearch] == NSOrderedSame) {
				 
			if ([fileUTI compare:(NSString *)kUTTypePDF options:NSLiteralSearch] == NSOrderedSame) {
				fileTypeImage = [UIImage imageNamed:@"Pdf.png"];
			}
			else if ([fileUTI compare:(NSString *)kUTTypePNG options:NSLiteralSearch] == NSOrderedSame) {
				fileTypeImage = [UIImage imageNamed:@"Image.png"];
			}
			else if ([fileUTI compare:(NSString *)kUTTypePlainText options:NSLiteralSearch] == NSOrderedSame) {
				fileTypeImage = [UIImage imageNamed:@"Text.png"];
			}
			else {
				fileTypeImage = [UIImage imageNamed:@"File.png"];
			}
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		cell.imageView.image	= fileTypeImage;
		cell.textLabel.text		= [self.documents objectAtIndex:indexPath.row];
		return cell;
	}

	#pragma mark UITableViewDelegate

	-(void) tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
		if (NKUIDeviceUserIntefaceIdiom() == UIUserInterfaceIdiomPad) {
			NKNavigatorAction *action = [NKNavigatorAction actionWithNavigatorURLPath:@"navigatorcatalog://toolbar"];
			action.animated = TRUE;
			self.detailViewController = (NVCDetailViewController *)[[NKSplitViewNavigator splitViewNavigator].detailNavigator openNavigatorAction:action];
			self.detailViewController.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:[self.documentsPath stringByAppendingPathComponent:[self.documents objectAtIndex:indexPath.row]]]];
			self.detailViewController.documentItem	= [self.documentAttributes objectAtIndex:indexPath.row];
		}
		else {
			NKNavigatorAction *action = [NKNavigatorAction actionWithNavigatorURLPath:@"navigatorcatalog://toolbar"];
			action.animated = TRUE;
			self.detailViewController = (NVCDetailViewController *)[[NKNavigator navigator] openNavigatorAction:action];
			self.detailViewController.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:[self.documentsPath stringByAppendingPathComponent:[self.documents objectAtIndex:indexPath.row]]]];
			self.detailViewController.documentItem	= [self.documentAttributes objectAtIndex:indexPath.row];
		}
	}

	-(void) tableView:(UITableView *)aTableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
		NVCDocumentsFolderViewController *nextDirectoryController = [[NVCDocumentsFolderViewController alloc] initWithStyle:UITableViewStylePlain];
		nextDirectoryController.documentsPath = [self.documentsPath stringByAppendingPathComponent:[self.documents objectAtIndex:indexPath.row]];
		nextDirectoryController.detailViewController = self.detailViewController;
		[self.navigationController pushViewController:nextDirectoryController animated:YES];
		[nextDirectoryController release];
	}

	#pragma mark Memory

	-(void) viewDidUnload {
		[self.documents release]; self.documents = nil;
		[self.documentAttributes release]; self.documentAttributes = nil;
	}

	-(void) dealloc {
		self.detailViewController = nil;
		self.documentsPath = nil;
		self.documents = nil;
		self.documentAttributes = nil;
		[super dealloc];
	}

@end

