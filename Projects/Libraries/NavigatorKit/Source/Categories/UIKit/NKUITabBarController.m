
#import <NavigatorKit/NKUITabBarController.h>
#import <NavigatorKit/NKUIViewController.h>
#import <NavigatorKit/NKNavigationController.h>
#import <NavigatorKit/NKNavigator.h>
#import <NavigatorKit/NKSplitViewNavigator.h>
#import <NavigatorKit/NKUIDevice.h>

@implementation UITabBarController (NKNavigator)

	#pragma mark Private

	-(UIViewController *) rootControllerForController:(UIViewController *)controller {
		if ([controller canContainControllers]) {
			return controller;
		}
		else {
			NKNavigationController *navController = [[[NKNavigationController alloc] init] autorelease];
			[navController pushViewController:controller animated:NO];
			return navController;
		}
	}

	#pragma mark Public

	-(void) setTabViewControllerURLs:(NSArray *)URLs {
		NSMutableArray *controllers = [NSMutableArray array];
		for (NSString *URL in URLs) {
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

	-(void) addSubcontroller:(UIViewController *)controller animated:(BOOL)animated transition:(UIViewAnimationTransition)transition {
		self.selectedViewController = controller;
	}

	-(void) bringControllerToFront:(UIViewController *)controller animated:(BOOL)animated {
		self.selectedViewController = controller;
	}

	-(NSString *) keyForSubcontroller:(UIViewController *)controller {
		return nil;
	}

	-(UIViewController *) subcontrollerForKey:(NSString *)key {
		return nil;
	}

@end
