
#import <NavigatorKit/NKUISplitViewController.h>
#import <NavigatorKit/NKNavigator.h>
#import <NavigatorKit/NKNavigationController.h>
#import <NavigatorKit/NKUIViewController.h>

@implementation UISplitViewController (NKNavigator)

	@dynamic masterViewController;
	@dynamic detailViewController;

	#pragma mark -

	-(BOOL) canContainControllers {
		return TRUE;
	}

	#pragma mark -

	-(id) masterViewController {
		if ([self.viewControllers count] == 0) {
			return nil;
		}
		return [self.viewControllers objectAtIndex:0];
	}

	-(id) detailViewController {
		if ([self.viewControllers count] == 0) {
			return nil;
		}
		return [self.viewControllers lastObject];
	}


	#pragma mark Public
	
	-(void) setViewControllersWithNavigationURLs:(NSArray *)navigationURLs {
		if (navigationURLs && [navigationURLs count] == 2) {
			UIViewController *master = nil;
			NSString *masterURL = nil;
			UIViewController *detail  = nil;
			NSString *detailURL = nil;
			if ([[navigationURLs objectAtIndex:0] isKindOfClass:[NSString class]]) {
				masterURL = [navigationURLs objectAtIndex:0];
				if (masterURL) {
					master = [[NKNavigator navigator] viewControllerForURL:masterURL];
				}
			}
			if ([[navigationURLs lastObject] isKindOfClass:[NSString class]]) {
				detailURL = [navigationURLs objectAtIndex:0];
				if (detailURL) {
					detail = [[NKNavigator navigator] viewControllerForURL:detailURL];
				}
			}
			if (master != nil && detail != nil) {
				self.viewControllers = [NSArray arrayWithObjects:master, detail, nil];
			}
		}
	}

@end
