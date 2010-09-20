
#import <NavigatorKit/NKNavigationController.h>
#import <NavigatorKit/NKUIViewController.h>
#import <NavigatorKit/NKNavigator.h>
#import <NavigatorKit/NKNavigatorMap.h>

@implementation NKNavigationController

#pragma mark NKUIViewController

-(UIView *) rotatingHeaderView {
	UIViewController *popup = [self popupViewController];
	if (popup) {
		return [popup rotatingHeaderView];
	}
	return [super rotatingHeaderView];
}

-(BOOL) canContainControllers {
	return TRUE;
}

-(UIViewController *) topSubcontroller {
	return self.topViewController;
}

-(void) addSubcontroller:(UIViewController *)controller animated:(BOOL)animated transition:(UIViewAnimationTransition)transition {
	if (animated && transition) {
		[self pushViewController:controller animatedWithTransition:transition];
	}
	else {
		[self pushViewController:controller animated:animated];
	}
}

-(void) bringControllerToFront:(UIViewController *)controller animated:(BOOL)animated {
	if (([self.viewControllers indexOfObject:controller] != NSNotFound) && (controller != self.topViewController)) {
		[self popToViewController:controller animated:animated];
	}
}

-(NSString *) keyForSubcontroller:(UIViewController *)controller {
	NSInteger index = [self.viewControllers indexOfObject:controller];
	if (index != NSNotFound) {
		return [NSNumber numberWithInt:index].stringValue;
	}
	return nil;
}

-(UIViewController *) subcontrollerForKey:(NSString *)key {
	NSInteger index = key.intValue;
	if (index < self.viewControllers.count) {
		return [self.viewControllers objectAtIndex:index];
	}
	return nil;
}


#pragma mark SPI

-(UIViewAnimationTransition) invertTransition:(UIViewAnimationTransition)transition {
	switch (transition) {
		case UIViewAnimationTransitionCurlUp:
			return UIViewAnimationTransitionCurlDown;
		case UIViewAnimationTransitionCurlDown:
			return UIViewAnimationTransitionCurlUp;
		case UIViewAnimationTransitionFlipFromLeft:
			return UIViewAnimationTransitionFlipFromRight;
		case UIViewAnimationTransitionFlipFromRight:
			return UIViewAnimationTransitionFlipFromLeft;
		default:
			return UIViewAnimationTransitionNone;
	}
}

-(UIViewController *) popViewControllerAnimated:(BOOL)animated {
	if (animated) {
		NSString *URL = self.topViewController.originalNavigatorURL;
		UIViewAnimationTransition transition = URL ? [self.responsibleNavigator.navigationMap transitionForURL:URL] : UIViewAnimationTransitionNone;
		if (transition) {
			UIViewAnimationTransition inverseTransition = [self invertTransition:transition];
			return [self popViewControllerAnimatedWithTransition:inverseTransition];
		}
	}
	return [super popViewControllerAnimated:animated];
}

-(void) pushAnimationDidStop {

}


#pragma mark API

-(void) pushViewController:(UIViewController *)controller animatedWithTransition:(UIViewAnimationTransition)transition {
	[self pushViewController:controller animated:FALSE];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.7];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(pushAnimationDidStop)];
	[UIView setAnimationTransition:transition forView:self.view cache:TRUE];
	[UIView commitAnimations];
}

-(UIViewController *) popViewControllerAnimatedWithTransition:(UIViewAnimationTransition)transition {
	UIViewController *poppedController = [self popViewControllerAnimated:FALSE];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.7];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(pushAnimationDidStop)];
	[UIView setAnimationTransition:transition forView:self.view cache:FALSE];
	[UIView commitAnimations];
	return poppedController;
}


#pragma mark -

-(void) resetWithRootController:(UIViewController *)aViewController {
	self.viewControllers = [NSArray arrayWithObject:aViewController];
}

@end
