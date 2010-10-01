
#import "NVCApplicationDelegate.h"
#import "NVCUserDefaults.h"
#import "NVCDocumentsFolderViewController.h"
#import "NVCDetailViewController.h"
#import "NVCNavigationBarViewController.h"
#import "NVCContentTableViewController.h"
#import "NVCMappingTableViewController.h"
#import "NVCHistoryViewController.h"
#import "NVCSettingsViewController.h"

@interface NVCApplicationDelegate ()
	// weak refs retained by Navigators
	@property (nonatomic, assign) UISplitViewController *splitViewController;
	@property (nonatomic, assign) UITabBarController *tabBarController;
	@property (nonatomic, retain, readwrite) NSDictionary *launchOptions;
	@property (nonatomic, retain, readwrite) NSURL *launchURL;
	-(UIViewController *) openExternalURLActionSheet;
	-(UIViewController *) helloDaveAlert;
	-(UIViewController *) alertViewControllerWithTitle:(NSString *)aTitle message:(NSString *)aMessage 
										   okButtonURL:(NSString *)okURL 
									   hasCancelButton:(BOOL)cancelFlag 
									   cancelButtonURL:(NSString *)cancelURL;
@end

#pragma mark -

@implementation NVCApplicationDelegate

#pragma mark -

+(void) initialize {
	NSDictionary *defaults = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UserDefaults" ofType:@"plist"]];
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

#pragma mark Shared Delegate

+(NVCApplicationDelegate *) sharedApplicationDelegate {
	return (NVCApplicationDelegate *)[UIApplication sharedApplication].delegate;
}


#pragma mark <UIApplicationDelegate>

-(BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)options {
	if (options) {
		self.launchOptions = [[NSDictionary alloc] initWithDictionary:options copyItems:TRUE];
		NSLog(@"%@", self.launchOptions);
	}
	
	BOOL reset = [[NSUserDefaults standardUserDefaults] boolForKey:NVCApplicationResetKey];
	if (reset) {
		[[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
		[[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:NVCApplicationResetKey];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	

	if (NKUIDeviceUserIntefaceIdiom() == UIUserInterfaceIdiomPad) {
		//
		// Split View Navigator
		//
		NKSplitViewNavigator *sharedNavigator	 = [NKSplitViewNavigator splitViewNavigator];
		sharedNavigator.delegate				 = self;
		sharedNavigator.defaultURLScheme		 = @"navigatorcatalog";
		sharedNavigator.masterPopoverButtonTitle = @"Master";

		NKNavigatorMap *sharedNavigationMap = sharedNavigator.navigationMap;
		[sharedNavigationMap from:@"navigatorcatalog://splitView"	toObject:sharedNavigator.rootViewController];
		[sharedNavigationMap from:@"navigatorcatalog://settings"	toModalViewController:[NVCSettingsViewController class] presentationStyle:UIModalPresentationFormSheet];
		[sharedNavigationMap from:@"navigatorcatalog:///hello/dave"	toObject:self selector:@selector(helloDaveAlert)];		

		//
		// Master Navigator
		//
		NKNavigatorMap *masterNavigationMap = sharedNavigator.masterNavigator.navigationMap;
		sharedNavigator.masterNavigator.delegate = self;
		sharedNavigator.masterNavigator.wantsNavigationControllerForRoot = FALSE;
		
		[masterNavigationMap from:@"navigatorcatalog://tabbar"			toSharedViewController:[UITabBarController class]];
		[masterNavigationMap from:@"navigatorcatalog://content/(initWithTitle:)" toViewController:[NVCContentTableViewController class]];
		[masterNavigationMap from:@"navigatorcatalog://documents"		toViewController:[NVCDocumentsFolderViewController class]];
		[masterNavigationMap from:@"navigatorcatalog://mappings"		toViewController:[NVCMappingTableViewController class]];
		[masterNavigationMap from:@"navigatorcatalog://history"			toViewController:[NVCHistoryViewController class]];
		[masterNavigationMap from:@"navigatorcatalog://confirm/openURL"	toObject:self selector:@selector(openExternalURLActionSheet)];
		
		//
		// Detail Navigator
		//
		sharedNavigator.detailNavigator.delegate = self;
		NKNavigatorMap *detailNavigationMap = sharedNavigator.detailNavigator.navigationMap;
		
		[detailNavigationMap from:@"navigatorcatalog://toolbar" toEmptyHistoryViewController:[NVCDetailViewController class]];
		[detailNavigationMap from:@"navigatorcatalog://navigationbar" toEmptyHistoryViewController:[NVCNavigationBarViewController class]];
		
		self.tabBarController = (UITabBarController *)[sharedNavigator.masterNavigator viewControllerForURL:@"navigatorcatalog://tabbar"];
		self.tabBarController.delegate = self;
		self.tabBarController.contentSizeForViewInPopover = CGSizeMake(320, 500);
		[self.tabBarController setTabViewControllerURLs:[NSArray arrayWithObjects:@"navigatorcatalog://content/navigation", 
																				  @"navigatorcatalog://documents",
																				  @"navigatorcatalog://content/modal", 
																				  @"navigatorcatalog://content/popup", 
																				  @"navigatorcatalog://content/actions", 
																				  @"navigatorcatalog://content/external", 
																				  @"navigatorcatalog://mappings", 
																				  nil]];
		[sharedNavigator setViewControllersWithNavigationURLs:[NSArray arrayWithObjects:@"navigatorcatalog://tabbar", @"navigatorcatalog://toolbar", nil]];
	}
	else {
		NKNavigator *sharedNavigator		= [NKNavigator navigator];
		sharedNavigator.defaultURLScheme	= @"navigatorcatalog";
		sharedNavigator.delegate			= self;
		sharedNavigator.wantsNavigationControllerForRoot = FALSE;
		NKNavigatorMap *navigationMap		= sharedNavigator.navigationMap;

		[navigationMap from:@"navigatorcatalog://tabbar"		toSharedViewController:[UITabBarController class]];
		[navigationMap from:@"navigatorcatalog://content/(initWithTitle:)" toViewController:[NVCContentTableViewController class]];
		[navigationMap from:@"navigatorcatalog://mappings"		toViewController:[NVCMappingTableViewController class]];
		[navigationMap from:@"navigatorcatalog://history"		toViewController:[NVCHistoryViewController class]];
		[navigationMap from:@"navigatorcatalog://documents"		toViewController:[NVCDocumentsFolderViewController class]];
		[navigationMap from:@"navigatorcatalog://toolbar"		toViewController:[NVCDetailViewController class]];
		[navigationMap from:@"navigatorcatalog://navigationbar" toViewController:[NVCNavigationBarViewController class]];
		[navigationMap from:@"navigatorcatalog://settings"		toModalViewController:[NVCSettingsViewController class]];
		
		self.tabBarController = (UITabBarController *)[sharedNavigator viewControllerForURL:@"navigatorcatalog://tabbar"];
		self.tabBarController.delegate = self;
		[self.tabBarController setTabViewControllerURLs:[NSArray arrayWithObjects:@"navigatorcatalog://content/navigation", 
																				  @"navigatorcatalog://documents",
																				  @"navigatorcatalog://content/modal", 
																				  @"navigatorcatalog://content/popup", 
																				  @"navigatorcatalog://content/actions", 
																				  @"navigatorcatalog://content/external", 
																				  @"navigatorcatalog://mappings", 
																				  nil]];
		[sharedNavigator openNavigatorAction:[NKNavigatorAction actionWithNavigatorURLPath:@"navigatorcatalog://tabbar"]];
	}
	return TRUE;
}

-(BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)aURL {
	NSLog(@"%@", [aURL absoluteString]);
	//self.launchURL = aURL;
	NKNavigatorAction *action = [[NKNavigatorAction alloc] initWithNavigatorURLPath:[aURL absoluteString]];
	if (NKUIDeviceUserIntefaceIdiom() == UIUserInterfaceIdiomPad) {
		NKNavigator *nv = [[NKSplitViewNavigator splitViewNavigator] navigatorForURLPath:[aURL absoluteString]];
		if (nv == [NKSplitViewNavigator splitViewNavigator].detailNavigator) {
			[NKSplitViewNavigator splitViewNavigator].splitViewController.detailViewController = [nv openNavigatorAction:action].navigationController;
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
	return TRUE;
}

-(void) applicationDidEnterBackground:(UIApplication *)application {
	[[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"NVCLastActiveInForegroundDateKey"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) applicationWillEnterForeground:(UIApplication *)application {
	
}

-(void) applicationWillResignActive:(UIApplication *)application {
	
}

-(void) applicationDidBecomeActive:(UIApplication *)application {
	
}

-(void) applicationWillTerminate:(UIApplication *)application {
	
}

-(void) applicationDidReceiveMemoryWarning:(UIApplication *)application {
	
}

-(NSString *) applicationDocumentsDirectoryPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *basePath	= ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	return basePath;
}


#pragma mark <NKNavigatorDelegate>

-(void) navigatorDidEnterBackground:(NKNavigator *)navigator {

}

-(void) navigatorWillEnterForeground:(NKNavigator *)navigator {

}

-(void) navigator:(NKNavigator *)navigator didLoadController:(UIViewController *)controller {

}

-(void) navigator:(NKNavigator *)navigator didUnloadViewController:(UIViewController *)controller {

}

-(void) navigator:(NKNavigator *)navigator willOpenURL:(NSURL *)aURL inViewController:(UIViewController *)controller {

}

-(BOOL) navigator:(NKNavigator *)navigator shouldOpenURL:(NSURL *)aURL {
	return TRUE;
}

-(BOOL) navigator:(NKNavigator *)navigator shouldOpenURL:(NSURL *)URL withQuery:(NSDictionary *)query {
	return TRUE;
}

-(NSURL *) navigator:(NKNavigator *)navigator URLToOpen:(NSURL *)aURL  {
	return aURL;
}

/*
-(BOOL) navigator:(NKNavigator *)navigator canHandleUTI:(UIPasteboard *)pboard data:(NSString *)userData {
}*/



#pragma mark <UITabBarControllerDelegate>

-(BOOL) tabBarController:(UITabBarController *)tbc shouldSelectViewController:(UIViewController *)viewController {
	return TRUE;
}

-(void) tabBarController:(UITabBarController *)tbc didSelectViewController:(UIViewController *)viewController {

}

-(void) tabBarController:(UITabBarController *)tbc willBeginCustomizingViewControllers:(NSArray *)viewControllers {

}

-(void) tabBarController:(UITabBarController *)tbc willEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {

}

-(void) tabBarController:(UITabBarController *)tbc didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {

}


#pragma mark <NKActionSheetControllerDelegate>

-(BOOL) actionSheetController:(NKActionSheetController *)asc didDismissWithButtonIndex:(NSInteger)anIndex URL:(NSString *)aURLString {
	if (anIndex == 0) {
		//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:aURLString]];
	}
	else if (anIndex == 1) {
	}
	return TRUE;
}

#pragma mark <NKAlertViewControllerDelegate>

-(BOOL) alertViewController:(NKAlertViewController *)aController didDismissWithButtonIndex:(NSInteger)aButtonIndex URL:(NSString *)aURLString {
	if (aButtonIndex == 0) {
	}
	else if (aButtonIndex == 1) {
	}
	return TRUE;
}

#pragma mark -

-(UIViewController *) openExternalURLActionSheet {
	NKActionSheetController *actionSheet = [[[NKActionSheetController alloc] initWithTitle:@"Visit apple.com?" delegate:self] autorelease];
	[actionSheet addButtonWithTitle:@"Sure"			URL:@"http://www.apple.com"];
	[actionSheet addCancelButtonWithTitle:@"No Way" URL:nil];
	[actionSheet showInView:self.tabBarController.tabBar animated:TRUE];
	return actionSheet;
}

-(UIViewController *) helloDaveAlert {
	return [self alertViewControllerWithTitle:@"A Title" message:@"Hello Dave. Your looking well today." okButtonURL:nil hasCancelButton:FALSE cancelButtonURL:nil];
}

-(UIViewController *) alertViewControllerWithTitle:(NSString *)aTitle message:(NSString *)aMessage 
									   okButtonURL:(NSString *)okURL 
								   hasCancelButton:(BOOL)cancelFlag 
								   cancelButtonURL:(NSString *)cancelURL {
	NKAlertViewController *alert;
	alert = [[[NKAlertViewController alloc] initWithTitle:aTitle message:aMessage delegate:self] autorelease];
	[alert addButtonWithTitle:@"OK" URL:okURL];
	if (cancelFlag) {
		[alert addCancelButtonWithTitle:@"Cancel" URL:cancelURL];
	}
	return alert;
}


#pragma mark -

-(void) dealloc {
	self.tabBarController = nil;
	[super dealloc];
}

@end
