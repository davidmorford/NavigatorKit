
#import <NavigatorKit/NKNavigator.h>
#import <NavigatorKit/NKNavigatorAction.h>
#import <NavigatorKit/NKNavigationController.h>
#import <NavigatorKit/NKNavigatorMap.h>
#import <NavigatorKit/NKNavigatorPattern.h>

#import <NavigatorKit/NKPopupViewController.h>
#import <NavigatorKit/NKUIViewController.h>
#import <NavigatorKit/NKSplitViewController.h>
#import <NavigatorKit/NKSplitViewNavigator.h>
#import <NavigatorKit/NKUIDevice.h>

@interface NKNavigator () {
@protected
	UIWindow *window;
	UIViewController *rootViewController;
	NKNavigatorMap *navigationMap;
	NSMutableArray *delayedControllers;
	BOOL delayCount;
	BOOL opensExternalURLs;
	BOOL wantsNavigationControllerForRoot;
}

-(id) initWithWindowClass:(Class)windowCls navigationControllerClass:(Class)navControllerCls;

#pragma mark -

@property (nonatomic, retain, readwrite) NKNavigatorMap *navigationMap;	
@property (nonatomic, retain, readwrite) UIViewController *rootViewController;

-(void) setRootNavigationController:(UINavigationController *)aController;
+(UIViewController *) frontViewControllerForController:(UIViewController *)controller;
-(UINavigationController *) frontNavigationController;
-(UIViewController *) frontViewController;
-(UIViewController *) visibleChildControllerForController:(UIViewController *)controller;

#pragma mark -

@property (nonatomic, assign, readwrite) NKNavigator *parentNavigator;
-(void) navigator:(NKNavigator *)navigator didDisplayController:(UIViewController *)controller;

#pragma mark -

/*!
@result NO if the controller already has a super controller and is simply made visible.
		YES if the controller is the new root or if it did not have a super controller.
*/
-(BOOL) presentController:(UIViewController *)controller parentController:(UIViewController *)parentController mode:(NKNavigatorMode)mode animated:(BOOL)animated transition:(NSInteger)transition presentationStyle:(UIModalPresentationStyle)aStyle sender:(id)aSender;
-(BOOL) presentController:(UIViewController *)controller parentURLPath:(NSString *)parentURLPath withPattern:(NKNavigatorPattern *)pattern animated:(BOOL)animated transition:(NSInteger)transition presentationStyle:(UIModalPresentationStyle)aStyle sender:(id)aSender;

/*!
@abstract Present a view controller that strictly depends on the existence of the parent controller.
*/
-(void) presentDependentController:(UIViewController *)controller parentController:(UIViewController *)parentController mode:(NKNavigatorMode)mode animated:(BOOL)animated transition:(NSInteger)transition presentationStyle:(UIModalPresentationStyle)aStyle sender:(id)aSender;

/*!
@abstract A modal controller is a view controller that is presented over another controller and hides
the original controller completely. Classic examples include the Safari login controller when
authenticating on a network, creating a new contact in Contacts, and the Camera controller.
@discussion If the controller that is being presented is not a UINavigationController, then a
UINavigationController is created and the controller is pushed onto the navigation controller.
The navigation controller is then displayed instead.
*/
-(void) presentModalController:(UIViewController *)controller parentController:(UIViewController *)parentController animated:(BOOL)animated transition:(NSInteger)transition presentationStyle:(UIModalPresentationStyle)presentation sender:(id)aSender;

/*!
@abstract A popover controller is a view controller added in iPad that is presented over another controller and hides
the original controller only partially.
@discussion If the controller that is being presented is not a UINavigationController, then a
UINavigationController is created and the controller is pushed onto the navigation controller.
The navigation controller is then displayed instead.
*/
-(void) presentPopoverController:(UIViewController *)controller parentController:(UIViewController *)parentController animated:(BOOL)animated transition:(NSInteger)transition sender:(id)sender;

@end

#pragma mark -

static NKNavigator *gSharedNavigator = nil;

#pragma mark -

@implementation NKNavigator

@synthesize delegate;
@synthesize navigationMap;
@synthesize rootViewController;
@synthesize opensExternalURLs;
@synthesize wantsNavigationControllerForRoot;
@synthesize uniquePrefix;
@synthesize defaultURLScheme;
@synthesize parentNavigator;

#pragma mark Constructor

+(NKNavigator *) navigator {
	if (!gSharedNavigator) {
		gSharedNavigator = [[[self class] alloc] init];
	}
	return gSharedNavigator;
}

UIKIT_EXTERN NSString *const UIApplicationDidEnterBackgroundNotification __attribute__((weak_import));
UIKIT_EXTERN NSString *const UIApplicationWillEnterForegroundNotification __attribute__((weak_import));

#pragma mark Initializer

-(id) init {
	self = [self initWithWindowClass:[UIWindow class] navigationControllerClass:[NKNavigationController class]];
	if (!self) {
		return nil;
	}
	return self;
}

-(id) initWithWindowClass:(Class)windowCls navigationControllerClass:(Class)navControllerCls {
	self = [super init];
	if (!self) {
		return nil;
	}
	self.delegate = nil;
	navigationMap = [[NKNavigatorMap alloc] init];

	self.windowClass = windowCls;
	wantsNavigationControllerForRoot = TRUE;
	self.navigationControllerClass	= navControllerCls;

	self.window = nil;
	rootViewController = nil;
	delayedControllers = nil;
	delayCount = 0;
	opensExternalURLs = FALSE;
	
	// Works when compiling with LLVM/clang 1.5
	BOOL backgroundOK = (&UIApplicationDidEnterBackgroundNotification != NULL);
	BOOL foregroundOK = (&UIApplicationWillEnterForegroundNotification != NULL);
	BOOL deviceCanBackground = FALSE;
	
	if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) {
		// Poor 3G owners... :(
		if ([[UIDevice currentDevice] isMultitaskingSupported]) {
			deviceCanBackground = TRUE;
		}
	}
	
	if (backgroundOK && foregroundOK && deviceCanBackground) {
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(applicationDidEnterBackgroundNotification:) 
													 name:UIApplicationDidEnterBackgroundNotification 
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(applicationWillEnterForegroundNotification:) 
													 name:UIApplicationWillEnterForegroundNotification 
												   object:nil];
	}
	return self;
}


#pragma mark Notifications

-(void) applicationDidEnterBackgroundNotification:(NSNotification *)aNote {
	if (self.delegate && [self.delegate respondsToSelector:@selector(navigatorDidEnterBackground:)]) {
		[self.delegate navigatorDidEnterBackground:self];
	}
}

-(void) applicationWillEnterForegroundNotification:(NSNotification *)aNote {
	if (self.delegate && [self.delegate respondsToSelector:@selector(navigatorWillEnterForeground:)]) {
		[self.delegate navigatorWillEnterForeground:self];
	}	
}


#pragma mark API

-(UIWindow *) window {
	if (window == nil) {
		UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
		if (keyWindow != nil) {
			window = [keyWindow retain];
		}
		else {
			window = [[[self windowClass] alloc] initWithFrame:[UIScreen mainScreen].bounds];
			window.userInteractionEnabled = TRUE;
			window.backgroundColor = [UIColor blackColor];
			window.contentMode = UIViewContentModeScaleToFill;
			window.autoresizesSubviews = TRUE;
			[window makeKeyAndVisible];
		}
	}
	return window;
}

-(UIViewController *) visibleViewController {
	UIViewController *controller = rootViewController;
	while (nil != controller) {
		UIViewController *child = controller.modalViewController;
		if (nil == child) {
			child = [self visibleChildControllerForController:controller];
		}
		if (nil != child) {
			controller = child;
		}
		else {
			return controller;
		}
	}
	return nil;
}

-(UIViewController *) topViewController {
	UIViewController *controller = self.rootViewController;
	while (controller) {
		UIViewController *child = controller.popupViewController;
		if (!child || ![child canBeTopViewController]) {
			child = controller.modalViewController;
		}
		if (!child) {
			child = controller.topSubcontroller;
		}
		if (child) {
			if (child == self.rootViewController) {
				return child;
			}
			else {
				controller = child;
			}
		}
		else {
			return controller;
		}
	}
	return nil;
}

-(NSString *) currentURL {
	return self.topViewController.navigatorURL;

}

-(void) setCurrentURL:(NSString *)aURLPath {
	NKNavigatorAction *action = [NKNavigatorAction actionWithNavigatorURLPath:aURLPath];
	action.animated = TRUE;
	[self openNavigatorAction:action];
}


#pragma mark -

-(UIViewController *) openNavigatorAction:(NKNavigatorAction *)anAction {
	if (!anAction || !anAction.URLPath) {
		return nil;
	}
	
	// We may need to modify the URLPath, create a local copy.
	NSString *actionURLPathString = anAction.URLPath;
	
	NSURL *actionURL = [NSURL URLWithString:actionURLPathString];
	if ([self.navigationMap isAppURL:actionURL]) {
		[[UIApplication sharedApplication] openURL:actionURL];
		return nil;
	}
	
	if (!actionURL.scheme) {
		if (nil != actionURL.fragment) {
			actionURLPathString = [self.currentURL stringByAppendingString:actionURLPathString];
		}
		else {
			actionURLPathString = [@"http://" stringByAppendingString:actionURLPathString];
		}
		actionURL = [NSURL URLWithString:actionURLPathString];
	}
	
	// Allows the delegate to prevent opening this URL
	if ([delegate respondsToSelector:@selector(navigator:shouldOpenURL:)]) {
		if (![delegate navigator:self shouldOpenURL:actionURL]) {
			return nil;
		}
	}
	
	// Allows the delegate to modify the URL to be opened, as well as reject it. This delegate
	// method is intended to supersede -navigator:shouldOpenURL:.
	if ([delegate respondsToSelector:@selector(navigator:URLToOpen:)]) {
		NSURL *newURL = [delegate navigator:self URLToOpen:actionURL];
		if (!newURL) {
			return nil;
		}
		else {
			actionURL = newURL;
			actionURLPathString = newURL.absoluteString;
		}
	}
	
	if (anAction.withDelay) {
		[self beginDelay];
	}
	
	NKNavigatorPattern *pattern = nil;
	UIViewController *controller = [self viewControllerForURL:actionURLPathString query:anAction.query pattern:&pattern];
	
	if (controller) {
		/*if (anAction.state) {
		}*/
		
		if ([delegate respondsToSelector:@selector(navigator:willOpenURL:inViewController:)]) {
			[delegate navigator:self willOpenURL:actionURL inViewController:controller];
		}
		
		BOOL wasNew = [self presentController:controller
								parentURLPath:anAction.parentURLPath
								  withPattern:pattern
									 animated:anAction.animated
								   transition:(anAction.transition ? anAction.transition : pattern.transition)
							presentationStyle:(anAction.modalPresentationStyle ? anAction.modalPresentationStyle : pattern.modalPresentationStyle)
									   sender:anAction.sender];
		
		if (anAction.withDelay && !wasNew) {
			[self cancelDelay];
		}
	}
	else if (opensExternalURLs) {
		if ([delegate respondsToSelector:@selector(navigator:willOpenURL:inViewController:)]) {
			[delegate navigator:self willOpenURL:actionURL inViewController:nil];
		}
		[[UIApplication sharedApplication] openURL:actionURL];
	}
	return controller;
}

-(UIViewController *) openURLs:(NSString *)aURLString, ... {
	UIViewController *controller = nil;
	va_list ap;
	va_start(ap, aURLString);
	while (aURLString) {
		controller = [self openNavigatorAction:[NKNavigatorAction actionWithNavigatorURLPath:aURLString]];
		aURLString = va_arg(ap, id);
	}
	va_end(ap);
	return controller;
}


#pragma mark -

-(UIViewController *) viewControllerForURL:(NSString *)aURL {
	return [self viewControllerForURL:aURL query:nil pattern:nil];
}

-(UIViewController *) viewControllerForURL:(NSString *)aURL query:(NSDictionary *)query {
	return [self viewControllerForURL:aURL query:query pattern:nil];
}

-(UIViewController *) viewControllerForURL:(NSString *)aURL query:(NSDictionary *)query pattern:(NKNavigatorPattern * *)pattern {
	NSRange fragmentRange = [aURL rangeOfString:@"#" options:NSBackwardsSearch];
	if (fragmentRange.location != NSNotFound) {
		NSString *baseURL = [aURL substringToIndex:fragmentRange.location];
		if ([self.currentURL isEqualToString:baseURL]) {
			UIViewController *controller	= self.visibleViewController;
			id result						= [navigationMap dispatchURL:aURL toTarget:controller query:query];
			if ([result isKindOfClass:[UIViewController class]]) {
				return result;
			}
			else {
				return controller;
			}
		}
		else {
			id object = [navigationMap objectForURL:baseURL query:nil pattern:pattern];
			if (object) {
				id result = [navigationMap dispatchURL:aURL toTarget:object query:query];
				if ([result isKindOfClass:[UIViewController class]]) {
					return result;
				}
				else {
					return object;
				}
			}
			else {
				return nil;
			}
		}
	}
	
	id object = [navigationMap objectForURL:aURL query:query pattern:pattern];
	if (object) {
		UIViewController *controller	= object;
		controller.originalNavigatorURL = aURL;
		controller.responsibleNavigator = self;
		
		if (delayCount) {
			if (!delayedControllers) {
				delayedControllers = [[NSMutableArray alloc] initWithObjects:controller, nil];
			}
			else {
				[delayedControllers addObject:controller];
			}
		}
		return controller;
	}
	else {
		return nil;
	}
}

-(NKNavigator *) navigatorForURLPath:(NSString *)aURLPath {
	return self;
}


#pragma mark -

-(BOOL) isDelayed {
	return delayCount > 0;
}

-(void) beginDelay {
	++delayCount;
}

-(void) endDelay {
	if (delayCount && !--delayCount) {
		for (UIViewController *controller in delayedControllers) {
			[controller delayDidEnd];
		}
		[delayedControllers release]; delayedControllers = nil;
	}
}

-(void) cancelDelay {
	if (delayCount && !--delayCount) {
		[delayedControllers release]; delayedControllers = nil;
	}
}


#pragma mark -

-(void) removeAllViewControllers {
	[self.rootViewController.view removeFromSuperview];
	[rootViewController release]; rootViewController = nil;
	[self.navigationMap removeAllObjects];
}

-(NSString *) pathForObject:(id)object {
	if ([object isKindOfClass:[UIViewController class]]) {
		NSMutableArray *paths = [NSMutableArray array];
		for (UIViewController *controller		= object; controller; ) {
			UIViewController *superController	= controller.superController;
			NSString *key						= [superController keyForSubcontroller:controller];
			if (key) {
				[paths addObject:key];
			}
			controller = superController;
		}
		return [paths componentsJoinedByString:@"/"];
	}
	else {
		return nil;
	}
}

-(id) objectForPath:(NSString *)aPath {
	NSArray *keys					= [aPath componentsSeparatedByString:@"/"];
	UIViewController *controller	= self.rootViewController;
	for (NSString *key in [keys reverseObjectEnumerator]) {
		controller = [controller subcontrollerForKey:key];
	}
	return controller;
}


#pragma mark SPI

/*!
The goal of this method is to return the currently visible view controller, referred to here as
the "front" view controller. Tab bar controllers and navigation controllers are special-cased,
and when a controller has a modal controller, the method recurses as necessary.
*/
+(UIViewController *) frontViewControllerForController:(UIViewController *)controller {
	if ([controller isKindOfClass:[UITabBarController class]]) {
		UITabBarController *tabBarController = (UITabBarController *)controller;
		if (tabBarController.selectedViewController) {
			controller = tabBarController.selectedViewController;
		}
		else {
			controller = [tabBarController.viewControllers objectAtIndex:0];
		}
	}
	else if ([controller isKindOfClass:[UINavigationController class]]) {
		UINavigationController *navController = (UINavigationController *)controller;
		controller = navController.topViewController;
	}
	
	if (controller.modalViewController) {
		return [NKNavigator frontViewControllerForController:controller.modalViewController];
	}
	else {
		return controller;
	}
}

/*!
Similar to frontViewControllerForController, this method attempts to return the "front"
navigation controller. This makes the assumption that a tab bar controller has navigation
controllers as children.
If the root controller isn't a tab controller or a navigation controller, then no navigation
controller will be returned.
*/
-(UINavigationController *) frontNavigationController {
	if ([self.rootViewController isKindOfClass:[UITabBarController class]]) {
		UITabBarController *tabBarController = (UITabBarController *)self.rootViewController;
		if (tabBarController.selectedViewController) {
			return (UINavigationController *)tabBarController.selectedViewController;
		}
		else {
			return (UINavigationController *)[tabBarController.viewControllers objectAtIndex:0];
		}
	}
	else if ([self.rootViewController isKindOfClass:[UINavigationController class]]) {
		return (UINavigationController *)self.rootViewController;
	}
	else {
		return nil;
	}
}

-(UIViewController *) frontViewController {
	UINavigationController *navController = self.frontNavigationController;
	if (navController) {
		return [NKNavigator frontViewControllerForController:navController];
	}
	else {
		return [NKNavigator frontViewControllerForController:self.rootViewController];
	}
}

-(UIViewController *) visibleChildControllerForController:(UIViewController *)controller {
	return controller.topSubcontroller;
}

-(void) setRootViewController:(UIViewController *)controller {
	if (controller != rootViewController) {
		[rootViewController release];
		rootViewController = [controller retain];
		if (self.parentNavigator) {
			[self.parentNavigator navigator:self didDisplayController:rootViewController];
		}
		else {
			if ([self.window respondsToSelector:@selector(setRootViewController:)]) {
				[self.window performSelector:@selector(setRootViewController:) withObject:rootViewController];
			}
			else {
				while (self.window.subviews.count) {
					UIView *child = self.window.subviews.lastObject;
					[child removeFromSuperview];
				}
				[self.window addSubview:rootViewController.view];
			}				
		}
	}
}

-(void) setRootNavigationController:(UINavigationController *)aController {
	if (aController != self.rootViewController) {
		self.rootViewController = aController;
	}
}

-(UIViewController *) parentForController:(UIViewController *)controller parentURLPath:(NSString *)parentURLPath isContainer:(BOOL)flag {
	if (controller == self.rootViewController) {
		return nil;
	}
	else {
		// If this is the first controller, and it is not a "container", forcibly put
		// a navigation controller at the root of the controller hierarchy.
		if (!self.rootViewController && !flag && self.wantsNavigationControllerForRoot) {
			self.rootViewController = [[[[self navigationControllerClass] alloc] init] autorelease];
		}
		if (parentURLPath) {
			return [self openNavigatorAction:[NKNavigatorAction actionWithNavigatorURLPath:parentURLPath]];
		}
		else {
			UIViewController *parent = self.topViewController;
			if ([parent isKindOfClass:[UINavigationController class]]) {
				if (parent.parentViewController != nil) {
					parent = parent.parentViewController;
				}
				if ([parent isKindOfClass:[UITabBarController class]]) {
					parent = [(UITabBarController *)parent moreNavigationController];
				}
			}
			
			if (parent != controller) {
				return parent;
			}
			else {
				return nil;
			}
		}
	}
}

-(void) navigator:(NKNavigator *)navigator didDisplayController:(UIViewController *)controller {

}


#pragma mark -

-(BOOL) presentController:(UIViewController *)controller parentController:(UIViewController *)parentController mode:(NKNavigatorMode)mode animated:(BOOL)animated transition:(NSInteger)transition presentationStyle:(UIModalPresentationStyle)aStyle sender:(id)aSender {
	BOOL didPresentNewController = TRUE;
	
	if (!self.rootViewController) {
		self.rootViewController = controller;
	}
	else {
		UIViewController *previousSuper = controller.superController;
		if (previousSuper) {
			if (previousSuper != parentController) {
				
				// The controller already exists, so we just need to make it visible
				for (UIViewController *superController = previousSuper; controller; ) {
					UIViewController *nextSuper = superController.superController;
					[superController bringControllerToFront:controller animated:!nextSuper];
					controller			= superController;
					superController		= nextSuper;
				}
			}
			didPresentNewController = FALSE;
		}
		else if (parentController) {
			[self presentDependentController:controller parentController:parentController mode:mode animated:animated transition:transition presentationStyle:aStyle sender:aSender];
		}
	}
	return didPresentNewController;
}

-(BOOL) presentController:(UIViewController *)controller parentURLPath:(NSString *)parentURLPath withPattern:(NKNavigatorPattern *)pattern animated:(BOOL)animated transition:(NSInteger)transition presentationStyle:(UIModalPresentationStyle)aStyle sender:(id)aSender {
	BOOL didPresentNewController = NO;
	if (controller) {
		if (controller != self.topViewController) {
			UIViewController *parentController = [self parentForController:controller 
															 parentURLPath:(parentURLPath ? parentURLPath : pattern.parentURL) 
															   isContainer:[controller canContainControllers]];
			if (parentController && (parentController != self.topViewController)) {
				[self presentController:parentController
					   parentController:nil
								   mode:NKNavigatorModeNone
							   animated:NO
							 transition:0
					  presentationStyle:aStyle
								 sender:aSender];
			}
			didPresentNewController = [self presentController:controller 
											 parentController:parentController 
														 mode:pattern.navigationMode 
													 animated:animated 
												   transition:transition 
											presentationStyle:aStyle 
													   sender:aSender];
		}
	}
	return didPresentNewController;
}

-(void) presentDependentController:(UIViewController *)controller parentController:(UIViewController *)parentController mode:(NKNavigatorMode)mode animated:(BOOL)animated transition:(NSInteger)transition presentationStyle:(UIModalPresentationStyle)aStyle sender:(id)aSender {
	//UIUserInterfaceIdiom interfaceIdiom = [UIDevice currentDevice].userInterfaceIdiom;
	
	if (mode == NKNavigatorModeModal) {
		[self presentModalController:controller parentController:parentController animated:animated transition:transition presentationStyle:aStyle sender:aSender];
	}
	else if (mode == NKNavigatorModePopover) {
		if (NKUIDeviceHasUserIntefaceIdiom() && NKUIDeviceUserIntefaceIdiom() == UIUserInterfaceIdiomPad) {
			[self presentPopoverController:controller parentController:parentController animated:animated transition:transition sender:aSender];
		}
		else /*if (interfaceIdiom == UIUserInterfaceIdiomPhone)*/ {
			[self presentModalController:controller parentController:parentController animated:animated transition:transition presentationStyle:UIModalPresentationFullScreen sender:aSender];
		}
	}
	else if (mode == NKNavigatorModeEmptyHistory && [self.rootViewController isKindOfClass:[UINavigationController class]]) {
		UINavigationController *navController	= (UINavigationController *)self.rootViewController;
		[navController setViewControllers:[NSArray arrayWithObject:controller] animated:NO];
	}
	else {
		if ([controller isKindOfClass:[NKPopupViewController class]]) {
			NKPopupViewController *popupViewController = (NKPopupViewController *)controller;
			parentController.popupViewController	= popupViewController;
			controller.superController				= parentController;
			[popupViewController showInView:parentController.view animated:animated];
		}
		else {
			[parentController addSubcontroller:controller animated:animated transition:transition];
		}
	}
}

-(void) presentModalController:(UIViewController *)controller parentController:(UIViewController *)parentController animated:(BOOL)animated transition:(NSInteger)transition presentationStyle:(UIModalPresentationStyle)aStyle sender:(id)aSender {
	controller.modalTransitionStyle		= transition;
	controller.modalPresentationStyle	= aStyle;
	
	CGRect presentationViewFrame;
	
	if (NKUIDeviceUserIntefaceIdiom() == UIUserInterfaceIdiomPad) {
		if (aStyle == UIModalPresentationFormSheet) {
			presentationViewFrame = CGRectMake(0, 0, 540, 620);
		}
		else if (aStyle == UIModalPresentationPageSheet) {
			presentationViewFrame = CGRectMake(0, 0, 768, rootViewController.view.frame.size.height);
		}
		else if (aStyle == UIModalPresentationFullScreen) {
			presentationViewFrame = CGRectMake(0, 0, rootViewController.view.frame.size.width, rootViewController.view.frame.size.height);
		}
		else {
			presentationViewFrame = CGRectMake(0, 0, 540, 620);
		}
	}
	else {
		presentationViewFrame = CGRectZero;
	}
	
	if ([controller isKindOfClass:[UINavigationController class]]) {
		if (CGRectEqualToRect(presentationViewFrame, CGRectZero) == FALSE) {
			controller.view.frame = presentationViewFrame;
		}
		[parentController presentModalViewController:controller animated:animated];
	}
	else {
		UINavigationController *navController	= [[[[self navigationControllerClass] alloc] init] autorelease];
		navController.modalTransitionStyle		= controller.modalTransitionStyle;
		navController.modalPresentationStyle	= controller.modalPresentationStyle;
		navController.view.frame				= presentationViewFrame;
		[navController pushViewController:controller animated:NO];
		if (NKUIDeviceUserIntefaceIdiom() == UIUserInterfaceIdiomPad) {
			[self.rootViewController presentModalViewController:navController animated:animated];
		}
		else {
			[parentController presentModalViewController:navController animated:animated];
		}
	}
}

-(void) presentPopoverController:(UIViewController *)controller parentController:(UIViewController *)parentController animated:(BOOL)animated transition:(NSInteger)transition sender:(id)sender {
	if (NKUIDeviceUserIntefaceIdiom() == UIUserInterfaceIdiomPad) {
		UIPopoverController *popoverController;
		if ([controller isKindOfClass:[UIPopoverController class]]) {
			popoverController = (UIPopoverController *)controller;
		}
		else {
			UINavigationController *navController;
			if ([controller isKindOfClass:[UINavigationController class]]) {
				navController = (UINavigationController *)controller;
			}
			else {
				navController = [[[[self navigationControllerClass] alloc] init] autorelease];
				[navController pushViewController:controller animated:NO];
				navController.superController = parentController;
			}
			popoverController = [[[UIPopoverController alloc] initWithContentViewController:navController] autorelease];
		}
		
		parentController.popoverController = popoverController;
		if ([parentController conformsToProtocol:@protocol(UIPopoverControllerDelegate)]) {
			popoverController.delegate = (id <UIPopoverControllerDelegate>)parentController;
		}
		
		if ([sender isKindOfClass:[UIBarButtonItem class]]) {
			[popoverController presentPopoverFromBarButtonItem:(UIBarButtonItem *)sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:animated];
		}
		else {
			CGRect rect = [sender isKindOfClass:[UIView class]] ? [(UIView *)sender frame] : parentController.view.frame;
			[popoverController presentPopoverFromRect:rect inView:parentController.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:animated];
		}
	}
	else /*if (interfaceIdiom == UIUserInterfaceIdiomPhone)*/ {
		[self presentModalController:controller 
					parentController:parentController 
							animated:animated 
						  transition:transition 
				   presentationStyle:UIModalPresentationFullScreen 
							  sender:sender];
	}
}


#pragma mark -

-(void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	self.delegate = nil;
	[defaultURLScheme release];
	[uniquePrefix release];
	[rootViewController release];
	[delayedControllers release];
	[navigationMap release];
	[window release];
	[super dealloc];
}

@end

#pragma mark -

UIViewController * 
NKNavigatorOpenURL(NSString *aURL) {
	NKNavigatorAction *action = [NKNavigatorAction actionWithNavigatorURLPath:aURL];
	action.animated = TRUE;
	return [[NKNavigator navigator] openNavigatorAction:action];
}

UIViewController *
NKNavigatorOpenURLWithQuery(NSString *aURL, NSDictionary *aQuery, BOOL animatedFlag) {
	NKNavigatorAction *action = [NKNavigatorAction actionWithNavigatorURLPath:aURL];
	action.animated = animatedFlag;
	action.query = aQuery;
	return [[NKNavigator navigator] openNavigatorAction:action];
}
