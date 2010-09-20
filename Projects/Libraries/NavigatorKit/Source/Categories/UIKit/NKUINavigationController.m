
#import "NKUINavigationController.h"

@implementation UINavigationController (NKNavigator)

	@dynamic rootViewController;

	-(UIViewController *) rootViewController {
		if ([self.viewControllers count] == 0) {
			return nil;
		}
		return [self.viewControllers objectAtIndex:0];
	}

@end
