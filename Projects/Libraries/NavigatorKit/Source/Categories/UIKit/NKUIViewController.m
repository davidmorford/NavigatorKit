
#import <NavigatorKit/NKUIViewController.h>
#import <NavigatorKit/NKNavigator.h>
#import <NavigatorKit/NKNavigatorMap.h>

static NSMutableDictionary *gResponsibleNavigators	= nil;
static NSMutableDictionary *gSuperControllers		= nil;
static NSMutableDictionary *gPopupViewControllers	= nil;
static NSMutableDictionary *gPopoverControllers		= nil;

#pragma mark -

static const void *
NKUIViewControllerSuperControllersRetain(CFAllocatorRef allocator, const void *value) {
	return value;
}

static void
NKUIViewControllerSuperControllersRelease(CFAllocatorRef allocator, const void *value) {

}

#pragma mark -

@implementation UIViewController (NKViewController)

	@dynamic superController;
	@dynamic popupViewController;
	@dynamic popoverController;
	@dynamic canContainControllers;
	@dynamic canBeTopViewController;

	#pragma mark -

	-(BOOL) canContainControllers {
		return FALSE;
	}

	-(BOOL) canBeTopViewController {
		return TRUE;
	}

	-(UIViewController *) superController {
		UIViewController *parent = self.parentViewController;
		if (parent) {
			return parent;
		}
		else {
			NSString *key = [NSString stringWithFormat:@"%d", self.hash];
			return [gSuperControllers objectForKey:key];
		}
	}

	-(void) setSuperController:(UIViewController *)aViewController {
		NSString *key = [NSString stringWithFormat:@"%d", self.hash];
		if (aViewController) {
			if (!gSuperControllers) {
				CFDictionaryKeyCallBacks keyCallbacks	= kCFTypeDictionaryKeyCallBacks;
				CFDictionaryValueCallBacks callbacks	= kCFTypeDictionaryValueCallBacks;
				callbacks.retain						= NKUIViewControllerSuperControllersRetain;
				callbacks.release						= NKUIViewControllerSuperControllersRelease;
				gSuperControllers = (NSMutableDictionary *)CFDictionaryCreateMutable(nil, 0, &keyCallbacks, &callbacks);
			}
			[gSuperControllers setObject:aViewController forKey:key];
		}
		else {
			[gSuperControllers removeObjectForKey:key];
		}
	}


	#pragma mark -

	-(UIViewController *) topSubcontroller {
		return nil;
	}

	-(UIViewController *) antecedentViewController {
		NSArray *viewControllers = self.navigationController.viewControllers;
		if (viewControllers.count > 1) {
			NSUInteger index = [viewControllers indexOfObject:self];
			if (index != NSNotFound && index > 0) {
				return [viewControllers objectAtIndex:index - 1];
			}
		}
		return nil;
	}

	-(UIViewController *) nextViewController {
		NSArray *viewControllers = self.navigationController.viewControllers;
		if (viewControllers.count > 1) {
			NSUInteger index = [viewControllers indexOfObject:self];
			if ((index != NSNotFound) && (index + 1 < viewControllers.count) ) {
				return [viewControllers objectAtIndex:index + 1];
			}
		}
		return nil;
	}


	#pragma mark -

	-(UIViewController *) popupViewController {
		NSString *key = [NSString stringWithFormat:@"%d", self.hash];
		return [gPopupViewControllers objectForKey:key];
	}

	-(void) setPopupViewController:(UIViewController *)viewController {
		NSString *key = [NSString stringWithFormat:@"%d", self.hash];
		if (viewController) {
			if (!gPopupViewControllers) {
				CFDictionaryKeyCallBacks keyCallbacks	= kCFTypeDictionaryKeyCallBacks;
				CFDictionaryValueCallBacks callbacks	= kCFTypeDictionaryValueCallBacks;
				callbacks.retain						= NKUIViewControllerSuperControllersRetain;
				callbacks.release						= NKUIViewControllerSuperControllersRelease;
				gPopupViewControllers = (NSMutableDictionary *)CFDictionaryCreateMutable(nil, 0, &keyCallbacks, &callbacks); 
			}
			[gPopupViewControllers setObject:viewController forKey:key];
		}
		else {
			[gPopupViewControllers removeObjectForKey:key];
		}
	}

	#pragma mark -

	-(void) addSubcontroller:(UIViewController *)controller animated:(BOOL)animated transition:(UIViewAnimationTransition)transition {
		if (self.navigationController) {
			[self.navigationController addSubcontroller:controller animated:animated transition:transition];
		}
	}

	-(void) removeFromSupercontroller {
		[self removeFromSupercontrollerAnimated:YES];
	}

	-(void) removeFromSupercontrollerAnimated:(BOOL)animated {
		if (self.navigationController) {
			[self.navigationController popViewControllerAnimated:animated];
		}
	}

	-(void) bringControllerToFront:(UIViewController *)controller animated:(BOOL)animated {
	}

	-(NSString *) keyForSubcontroller:(UIViewController *)controller {
		return nil;
	}

	-(UIViewController *) subcontrollerForKey:(NSString *)key {
		return nil;
	}

	#pragma mark -

	-(void) delayDidEnd {
	
	}

	-(void) showBars:(BOOL)show animated:(BOOL)animated {
		[[UIApplication sharedApplication] setStatusBarHidden:!show withAnimation:UIStatusBarAnimationSlide];
		if (animated) {
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.3];
		}
		self.navigationController.navigationBar.alpha = show ? 1 : 0;
		if (animated) {
			[UIView commitAnimations];
		}
	}

@end

#pragma mark -

static NSMutableDictionary *gNavigatorURLs = nil;

@implementation UIViewController (NKNavigator)

	@dynamic navigatorURL;
	@dynamic originalNavigatorURL;
	@dynamic responsibleNavigator;

	#pragma mark -

	-(id) initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
		self = [self init];
		if (!self) {
			return nil;
		}
		return self;
	}


	#pragma mark -

	-(NSString *) navigatorURL {
		return self.originalNavigatorURL;
	}


	-(NSString *) originalNavigatorURL {
		NSString *key = [NSString stringWithFormat:@"%d", self.hash];
		return [gNavigatorURLs objectForKey:key];
	}

	-(void) setOriginalNavigatorURL:(NSString *)aURL {
		NSString *key = [NSString stringWithFormat:@"%d", self.hash];
		if (aURL != nil) {
			if (gNavigatorURLs == nil) {
				gNavigatorURLs = [[NSMutableDictionary alloc] init];
			}
			[gNavigatorURLs setObject:aURL forKey:key];
		}
		else {
			[gNavigatorURLs removeObjectForKey:key];
		}
	}


	-(NKNavigator *) responsibleNavigator {
		NSString *key = [NSString stringWithFormat:@"%d", self.hash];
		return [gResponsibleNavigators objectForKey:key];
	}

	-(void) setResponsibleNavigator:(NKNavigator *)navigator {
		NSString *key = [NSString stringWithFormat:@"%d", self.hash];
		if (navigator != nil) {
			if (!gResponsibleNavigators) {
				gResponsibleNavigators = [[NSMutableDictionary alloc] init];
			}
			[gResponsibleNavigators setObject:navigator forKey:key];
		}
		else {
			[gResponsibleNavigators removeObjectForKey:key];
		}
	}


	#pragma mark -

	-(void) viewControllerWillUnload {
		NSString *navigatorURLPath = self.originalNavigatorURL;
		if (navigatorURLPath != nil) {
			[[NKNavigator navigator].navigationMap removeObjectForURL:navigatorURLPath];
			self.originalNavigatorURL = nil;
		}
	}

@end

#pragma mark -

@implementation UIViewController (NKModalController)

	@dynamic isModal;

	-(BOOL) isModal {
		return (self.navigationController.parentViewController.modalViewController == self.navigationController);
	}

	-(void) dismissModalViewController {
		[self dismissModalViewControllerAnimated:YES];
	}

	-(void) dismissAnimated:(BOOL)inAnimated {
		if (self.isModal) {
			[self dismissModalViewControllerAnimated:TRUE];
		}
		else {
			[self.navigationController popViewControllerAnimated:TRUE];
		}
	}

@end
#pragma mark -

@implementation UIViewController (NKNavigatorActionMap)

	@dynamic navigationActions;

	-(void) addNavigationActions {
		NSDictionary *actionMap = [self navigationActions];
		if (actionMap) {
			for (NSString *actionNameKey in [actionMap allKeys]) {
				if (actionNameKey.length > 0) {
					NSString *actionNavigationPath	= [NSString stringWithFormat:@"%@/%@", self.originalNavigatorURL, actionNameKey];
					SEL actionSelector				= NSSelectorFromString([actionMap objectForKey:actionNameKey]);
					if ((actionNavigationPath != nil) && (actionSelector != nil) ) {
						[self.responsibleNavigator.navigationMap from:actionNavigationPath 
															 toObject:self 
															 selector:actionSelector];
					}
				}
			}
		}
	}

	-(void) removeNavigationActions {
		NSDictionary *actionMap = [self navigationActions];
		if (actionMap) {
			for (NSString *actionNameKey in [actionMap allKeys]) {
				if (actionNameKey.length > 0) {
					NSString *actionNavigationPath = [NSString stringWithFormat:@"%@/%@", self.originalNavigatorURL, actionNameKey];
					if (actionNavigationPath != nil) {
						[self.responsibleNavigator.navigationMap removeURL:actionNavigationPath];
					}
				}
			}
		}
	}

@end
