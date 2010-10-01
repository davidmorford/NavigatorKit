
#import "___PROJECTNAMEASIDENTIFIER___ApplicationDelegate.h"
#import "___PROJECTNAMEASIDENTIFIER___MasterViewController.h"
#import "___PROJECTNAMEASIDENTIFIER___DetailViewController.h"
#import "___PROJECTNAMEASIDENTIFIER___NavigationBarViewController.h"
#import "___PROJECTNAMEASIDENTIFIER___SettingsViewController.h"
#import "___PROJECTNAMEASIDENTIFIER___UserDefaults.h"

@interface ___PROJECTNAMEASIDENTIFIER___ApplicationDelegate ()
@end

#pragma mark -

@implementation ___PROJECTNAMEASIDENTIFIER___ApplicationDelegate

@synthesize window;
@synthesize splitViewController;
@synthesize applicationDocumentsDirectoryPath;

+(void) initialize {
	NSDictionary *defaults = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UserDefaults" ofType:@"plist"]];
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

#pragma mark Shared Delegate

+(___PROJECTNAMEASIDENTIFIER___ApplicationDelegate *) sharedApplicationDelegate {
	return (___PROJECTNAMEASIDENTIFIER___ApplicationDelegate *)[UIApplication sharedApplication].delegate;
}

#pragma mark <UIApplicationDelegate>

-(BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	if (NKUIDeviceUserIntefaceIdiom() == UIUserInterfaceIdiomPad) {
		
		//
		// Split View Navigator
		//
		NKSplitViewNavigator *sharedNavigator	 = [NKSplitViewNavigator splitViewNavigator];
		sharedNavigator.delegate				 = self;
		sharedNavigator.defaultURLScheme		 = @"___PROJECTNAMEASIDENTIFIER___";
		sharedNavigator.masterPopoverButtonTitle = @"Master";

		NKNavigatorMap *sharedNavigationMap = sharedNavigator.navigationMap;
		[sharedNavigationMap from:@"___PROJECTNAMEASIDENTIFIER___://splitView"	toObject:sharedNavigator.rootViewController];
		[sharedNavigationMap from:@"___PROJECTNAMEASIDENTIFIER___://settings"	toModalViewController:[___PROJECTNAMEASIDENTIFIER___SettingsViewController class] presentationStyle:UIModalPresentationFormSheet];
		
		//
		// Master Navigator
		//
		NKNavigatorMap *masterNavigationMap = sharedNavigator.masterNavigator.navigationMap;
		sharedNavigator.masterNavigator.delegate = self;
		[masterNavigationMap from:@"___PROJECTNAMEASIDENTIFIER___://master" toEmptyHistoryViewController:[___PROJECTNAMEASIDENTIFIER___MasterViewController class]];
		
		//
		// Detail Navigator
		//
		sharedNavigator.detailNavigator.delegate = self;
		NKNavigatorMap *detailNavigationMap = sharedNavigator.detailNavigator.navigationMap;
		
		[detailNavigationMap from:@"___PROJECTNAMEASIDENTIFIER___://toolbar" toEmptyHistoryViewController:[___PROJECTNAMEASIDENTIFIER___DetailViewController class]];
		[detailNavigationMap from:@"___PROJECTNAMEASIDENTIFIER___://navigationbar" toEmptyHistoryViewController:[___PROJECTNAMEASIDENTIFIER___NavigationBarViewController class]];
		
		[sharedNavigator setViewControllersWithNavigationURLs:[NSArray arrayWithObjects:@"___PROJECTNAMEASIDENTIFIER___://master", @"___PROJECTNAMEASIDENTIFIER___://toolbar", nil]];
	}
	else {
		NKNavigator *sharedNavigator		= [NKNavigator navigator];
		sharedNavigator.defaultURLScheme	= @"___PROJECTNAMEASIDENTIFIER___";
		sharedNavigator.delegate			= self;
		NKNavigatorMap *navigationMap		= sharedNavigator.navigationMap;

		[navigationMap from:@"___PROJECTNAMEASIDENTIFIER___://master"		toSharedViewController:[___PROJECTNAMEASIDENTIFIER___MasterViewController class]];
		[navigationMap from:@"___PROJECTNAMEASIDENTIFIER___://toolbar"		toViewController:[___PROJECTNAMEASIDENTIFIER___DetailViewController class]];
		[navigationMap from:@"___PROJECTNAMEASIDENTIFIER___://navigationbar" toViewController:[___PROJECTNAMEASIDENTIFIER___NavigationBarViewController class]];
		[navigationMap from:@"___PROJECTNAMEASIDENTIFIER___://settings"		toModalViewController:[___PROJECTNAMEASIDENTIFIER___SettingsViewController class]];
		[navigationMap from:@"___PROJECTNAMEASIDENTIFIER___://navigation"	toObject:sharedNavigator.rootViewController];
		[sharedNavigator openNavigatorAction:[NKNavigatorAction actionWithNavigatorURLPath:@"___PROJECTNAMEASIDENTIFIER___://master"]];
	}
	return TRUE;
}

-(BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)aURL {
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
	[[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"___PROJECTNAMEASIDENTIFIER___LastActiveInForegroundDateKey"];
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

#pragma mark -

-(void) navigator:(NKNavigator *)navigator didLoadController:(UIViewController *)controller {

}

-(void) navigator:(NKNavigator *)navigator didUnloadViewController:(UIViewController *)controller {

}

#pragma mark -

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


#pragma mark -

-(NSString *) applicationDocumentsDirectoryPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *basePath	= ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	return basePath;
}


#pragma mark -

-(void) dealloc {
	[splitViewController release];
	[window release];
	[super dealloc];
}

@end
