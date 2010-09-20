
#import "___PROJECTNAMEASIDENTIFIER___ApplicationDelegate.h"
#import "___PROJECTNAMEASIDENTIFIER___MasterViewController.h"
#import "___PROJECTNAMEASIDENTIFIER___DetailViewController.h"
#import "___PROJECTNAMEASIDENTIFIER___UserDefaults.h"

@interface ___PROJECTNAMEASIDENTIFIER___ApplicationDelegate ()
@end

#pragma mark -

@implementation ___PROJECTNAMEASIDENTIFIER___ApplicationDelegate

@synthesize window;
@synthesize splitViewController;
@synthesize applicationDocumentsDirectoryPath;

#pragma mark Shared Delegate

+(___PROJECTNAMEASIDENTIFIER___ApplicationDelegate *) sharedApplicationDelegate {
	return (___PROJECTNAMEASIDENTIFIER___ApplicationDelegate *)[UIApplication sharedApplication].delegate;
}

#pragma mark <UIApplicationDelegate>

-(BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	
	window.userInteractionEnabled = TRUE;
	window.backgroundColor = [UIColor blackColor];
	window.contentMode = UIViewContentModeScaleToFill;
	window.autoresizesSubviews = TRUE;
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		self.splitViewController = [[UISplitViewController alloc] init];
		splitViewController.delegate = self;

		___PROJECTNAMEASIDENTIFIER___MasterViewController *masterViewController = [[___PROJECTNAMEASIDENTIFIER___MasterViewController alloc] init];
		UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:masterViewController] autorelease];
		[masterViewController release];
		___PROJECTNAMEASIDENTIFIER___DetailViewController *detailViewController = [[[___PROJECTNAMEASIDENTIFIER___DetailViewController alloc] init] autorelease];
		
		self.splitViewController.viewControllers = [NSArray arrayWithObjects:navigationController, detailViewController, nil];
		
		[window addSubview:splitViewController.view];
	}
	else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		___PROJECTNAMEASIDENTIFIER___MasterViewController *masterViewController = [[___PROJECTNAMEASIDENTIFIER___MasterViewController alloc] init];
		UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:masterViewController] autorelease];
		[masterViewController release];
		window.rootViewController = navigationController;
	}
	[window makeKeyAndVisible];
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

-(BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)aURL {
	return TRUE;
}

#pragma mark -

-(void) splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc {
	
}

-(void) splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
	
}

-(void) splitViewController:(UISplitViewController *)svc popoverController:(UIPopoverController *)pc willPresentViewController:(UIViewController *)aViewController {
	
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
