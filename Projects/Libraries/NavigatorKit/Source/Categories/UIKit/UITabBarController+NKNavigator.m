
#import <NavigatorKit/UITabBarController+NKNavigator.h>
#import <NavigatorKit/UIViewController+NKNavigator.h>
#import <NavigatorKit/UIDevice+NKVersion.h>
#import <NavigatorKit/NKNavigationController.h>
#import <NavigatorKit/NKNavigator.h>
#import <NavigatorKit/NKSplitViewNavigator.h>

@implementation UITabBarController (NKNavigator)

#pragma mark Private

-(UIViewController *) rootControllerForController:(UIViewController *)aController {
	if ([aController canContainControllers]) {
		return aController;
	}
	else {
		NKNavigationController *navController = [[[NKNavigationController alloc] init] autorelease];
		[navController pushViewController:aController animated:NO];
		return navController;
	}
}

#pragma mark Public

-(void) setTabViewControllerURLs:(NSArray *)navigatorURLs {
	NSMutableArray *controllers = [NSMutableArray array];
	for (NSString *URL in navigatorURLs) {
		UIViewController *controller = nil;
		if (NKUIDeviceUserIntefaceIdiom() == UIUserInterfaceIdiomPad) {
			controller = [[[NKSplitViewNavigator splitViewNavigator] navigatorForURLPath:URL] viewControllerForURL:URL];
		}
		else {
			controller = [[NKNavigator navigator] viewControllerForURL:URL];
		}
		if (controller) {
			UIViewController *tabController = [self rootControllerForController:controller];
			[controllers addObject:tabController];
		}
	}
	self.viewControllers = controllers;
}

#pragma mark UIViewController

-(BOOL) canContainControllers {
	return TRUE;
}

-(UIViewController *) topSubcontroller {
	return self.selectedViewController;
}

-(void) addSubcontroller:(UIViewController *)aController animated:(BOOL)animated transition:(UIViewAnimationTransition)aTransition {
	self.selectedViewController = aController;
}

-(void) bringControllerToFront:(UIViewController *)controller animated:(BOOL)animated {
	self.selectedViewController = controller;
}

-(NSString *) keyForSubcontroller:(UIViewController *)aController {
	return nil;
}

-(UIViewController *) subcontrollerForKey:(NSString *)aKey {
	return nil;
}

@end
