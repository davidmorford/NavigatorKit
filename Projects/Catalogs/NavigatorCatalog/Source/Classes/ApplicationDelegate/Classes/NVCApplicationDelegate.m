
#import "NVCApplicationDelegate.h"
#import "NVCUserDefaults.h"
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

-(BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
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
		[sharedNavigationMap from:@"navigatorcatalog://settings"	toModalViewController:[NVCSettingsViewController class] 
																	    presentationStyle:UIModalPresentationFormSheet];
		
		//
		// Master Navigator
		//
		NKNavigatorMap *masterNavigationMap = sharedNavigator.masterNavigator.navigationMap;
		sharedNavigator.masterNavigator.delegate = self;
		sharedNavigator.masterNavigator.wantsNavigationControllerForRoot = FALSE;
		
		[masterNavigationMap from:@"navigatorcatalog://tabbar" toSharedViewController:[UITabBarController class]];
		[masterNavigationMap from:@"navigatorcatalog://content/(initWithTitle:)" toViewController:[NVCContentTableViewController class]];
		[masterNavigationMap from:@"navigatorcatalog://mappings" toViewController:[NVCMappingTableViewController class]];
		[masterNavigationMap from:@"navigatorcatalog://history" toViewController:[NVCHistoryViewController class]];

		//
		// Detail Navigator
		//
		sharedNavigator.detailNavigator.delegate = self;
		NKNavigatorMap *detailNavigationMap = sharedNavigator.detailNavigator.navigationMap;
		
		[detailNavigationMap from:@"navigatorcatalog://toolbar" toEmptyHistoryViewController:[NVCDetailViewController class]];
		[detailNavigationMap from:@"navigatorcatalog://navigationbar" toEmptyHistoryViewController:[NVCNavigationBarViewController class]];
		
		self.tabBarController = (UITabBarController *)[sharedNavigator.masterNavigator viewControllerForURL:@"navigatorcatalog://tabbar"];
		self.tabBarController.delegate = self;
		[self.tabBarController setTabViewControllerURLs:[NSArray arrayWithObjects:@"navigatorcatalog://content/navigation", 
																				  @"navigatorcatalog://content/modal", 
																				  @"navigatorcatalog://content/popup", 
																				  @"navigatorcatalog://content/actions", 
																				  @"navigatorcatalog://content/external", 
																				  @"navigatorcatalog://mappings", 
																				  @"navigatorcatalog://history",
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
		[navigationMap from:@"navigatorcatalog://toolbar"		toViewController:[NVCDetailViewController class]];
		[navigationMap from:@"navigatorcatalog://navigationbar" toViewController:[NVCNavigationBarViewController class]];
		[navigationMap from:@"navigatorcatalog://settings"		toModalViewController:[NVCSettingsViewController class]];
		
		self.tabBarController = (UITabBarController *)[sharedNavigator viewControllerForURL:@"navigatorcatalog://tabbar"];
		self.tabBarController.delegate = self;
		[self.tabBarController setTabViewControllerURLs:[NSArray arrayWithObjects:@"navigatorcatalog://content/navigation", 
																				  @"navigatorcatalog://content/modal", 
																				  @"navigatorcatalog://content/popup", 
																				  @"navigatorcatalog://content/actions", 
																				  @"navigatorcatalog://content/external", 
																				  @"navigatorcatalog://mappings", 
																				  @"navigatorcatalog://history",
																				  nil]];
		[sharedNavigator openURLAction:[NKNavigatorAction actionWithURLPath:@"navigatorcatalog://tabbar"]];
	}
	return TRUE;
}

-(BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)aURL {
	NKNavigatorAction *action = [[NKNavigatorAction alloc] initWithURLPath:[aURL absoluteString]];
	if (NKUIDeviceUserIntefaceIdiom() == UIUserInterfaceIdiomPad) {
		NKNavigator *nv = [[NKSplitViewNavigator splitViewNavigator] navigatorForURLPath:[aURL absoluteString]];
		if (nv == [NKSplitViewNavigator splitViewNavigator].detailNavigator) {
			[NKSplitViewNavigator splitViewNavigator].splitViewController.detailViewController = [nv openURLAction:action].navigationController;
		}
		else {
			[nv openURLAction:action];
		}
	}
	else {
		action.animated = TRUE;
		[[NKNavigator navigator] openURLAction:action];
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


#pragma mark -

-(NSString *) applicationDocumentsDirectoryPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *basePath	= ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	return basePath;
}

#pragma mark -

-(void) dealloc {
	self.tabBarController = nil;
	[super dealloc];
}

@end
