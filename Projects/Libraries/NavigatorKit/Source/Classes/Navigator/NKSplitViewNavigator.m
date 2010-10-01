
#import <NavigatorKit/NKSplitViewNavigator.h>
#import <NavigatorKit/NKSplitViewController.h>
#import <NavigatorKit/NKSplitViewPopoverButtonDelegate.h>
#import <NavigatorKit/NKNavigatorAction.h>
#import <NavigatorKit/NKNavigatorMap.h>
#import <NavigatorKit/NKNavigationController.h>

@interface NKNavigator () {
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

@end

#pragma mark -

static NKSplitViewNavigator *gSharedSplitViewNavigator = nil;

#pragma mark -

@implementation NKSplitViewNavigator

@synthesize navigators;
@synthesize popoverController;
@synthesize masterPopoverButtonItem;
@synthesize masterPopoverButtonTitle;

#pragma mark Shared Constructor

+(NKSplitViewNavigator *) splitViewNavigator {
	if (!gSharedSplitViewNavigator) {
		gSharedSplitViewNavigator = [[[self class] alloc] init];
	}
	return gSharedSplitViewNavigator;
}


#pragma mark Initializers

-(id) init {
	self = [super init];
	if (!self) {
		return nil;
	}
	NSMutableArray *mutableNavigators = [[NSMutableArray alloc] initWithCapacity:2];
	for (NSUInteger index = 0; index < 2; ++index) {
		NKNavigator *navigator		= [[NKNavigator alloc] init];
		navigator.parentNavigator	= self;
		navigator.window			= self.window;
		navigator.uniquePrefix		= [NSString stringWithFormat:@"NKSplitViewNavigator%d", index];
		[mutableNavigators addObject:navigator];
		[navigator release];
	}
	self.navigators = mutableNavigators;
	return self;
}


#pragma mark API

-(void) setViewControllersWithNavigationURLs:(NSArray *)aURLArray {
	NSUInteger count				= [self.navigators count];
	NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:count];
	for (NSUInteger currentIndex = 0; currentIndex < count; ++currentIndex) {
		NKNavigator *navigator = [self navigatorAtIndex:currentIndex];
		[navigator openNavigatorAction:[NKNavigatorAction actionWithNavigatorURLPath:[aURLArray objectAtIndex:currentIndex]]];
		[viewControllers addObject:navigator.rootViewController];
	}
	self.splitViewController.viewControllers = viewControllers;
	[viewControllers release]; viewControllers = nil;
}

-(NKNavigator *) masterNavigator {
	return [self navigatorAtIndex:NKSplitViewMasterNavigator];
}

-(NKNavigator *) detailNavigator {
	return [self navigatorAtIndex:NKSplitViewDetailNavigator];
}

-(NKNavigator *) navigatorAtIndex:(NKSplitNavigatorPosition)anIndex {
	NSAssert(anIndex >= 0 && anIndex <= 1, @"");
	return [navigators objectAtIndex:anIndex];
}

-(NKNavigator *) navigatorForURLPath:(NSString *)aURLPath {
	for (NKNavigator *navigator in self.navigators) {
		if ([navigator.navigationMap isURLPathSupported:aURLPath]) {
			return navigator;
		}
	}
	if ([self.navigationMap isURLPathSupported:aURLPath]) {
		return self;
	}
	return nil;
}

-(void) navigator:(NKNavigator *)navigator didDisplayController:(UIViewController *)controller {
	NSUInteger navigatorIndex = [self.navigators indexOfObject:navigator];
	if (navigatorIndex == NSNotFound) {
		return;
	}
	
	if (controller == self.splitViewController) {
		if ([self.splitViewController.viewControllers objectAtIndex:navigatorIndex] != controller) {
			NSMutableArray *viewControllers = [self.splitViewController.viewControllers mutableCopy];
			[viewControllers replaceObjectAtIndex:navigatorIndex withObject:controller];
			self.splitViewController.viewControllers = viewControllers;
		}
	}
	
	if (navigatorIndex == NKSplitViewDetailNavigator) {

	}
	
	if (navigatorIndex == NKSplitViewMasterNavigator) {
	}
}


#pragma mark <NKSplitViewControllerDelegate>

-(NKSplitViewController *) splitViewController {
	if ([super rootViewController] != nil) {
		return (NKSplitViewController *)[super rootViewController];
	}
	
	NKSplitViewController *rootSplitViewController = [[NKSplitViewController alloc] init];
	rootSplitViewController.delegate = self;
	[self setRootViewController:rootSplitViewController];
	[rootSplitViewController release];
	
	return (NKSplitViewController *)[self rootViewController];
}

-(void) splitViewController:(NKSplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc {
	self.popoverController = pc;
	self.popoverController.delegate = self;
	self.masterPopoverButtonItem = barButtonItem;
	UIViewController *rightDetailController = self.splitViewController.detailViewController;
	BOOL isDetailNavigationController = [rightDetailController isKindOfClass:[UINavigationController class]];
	if (isDetailNavigationController) {
		UINavigationController *detailNavigationController = (UINavigationController *)rightDetailController;
		BOOL confirmsToDetail = [[(UINavigationController *)detailNavigationController topViewController] conformsToProtocol:@protocol(NKSplitViewPopoverButtonDelegate)];			
		if (confirmsToDetail) {
			UIViewController <NKSplitViewPopoverButtonDelegate> *controller = detailNavigationController.topViewController;
			if (controller && barButtonItem) {
				if (!self.masterPopoverButtonItem.title) {
					self.masterPopoverButtonItem.title = (controller.title == nil) ? controller.title : @"Master";
				}
				if ([controller respondsToSelector:@selector(showMasterPopoverButtonItem:)]) {
					[controller showMasterPopoverButtonItem:self.masterPopoverButtonItem];
				}
			}
		}
	}
	else {
		BOOL confirmsToDetail = [rightDetailController conformsToProtocol:@protocol(NKSplitViewPopoverButtonDelegate)];			
		if (confirmsToDetail) {
			UIViewController <NKSplitViewPopoverButtonDelegate> *controller = rightDetailController;
			if (controller && barButtonItem) {
				if (!self.masterPopoverButtonItem.title) {
					self.masterPopoverButtonItem.title = (controller.title == nil) ? controller.title : @"Master";
				}
				if ([controller respondsToSelector:@selector(showMasterPopoverButtonItem:)]) {
					[controller showMasterPopoverButtonItem:self.masterPopoverButtonItem];
				}
			}
		}
	}
}

-(void) splitViewController:(NKSplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
	UIViewController *rightDetailController = self.splitViewController.detailViewController;
	BOOL isDetailNavigationController = [rightDetailController isKindOfClass:[NKNavigationController class]];
	if (isDetailNavigationController) {
		UINavigationController *detailNavigationController = (NKNavigationController *)rightDetailController;
		BOOL confirmsToDetail = [[(UINavigationController *)detailNavigationController topViewController] conformsToProtocol:@protocol(NKSplitViewPopoverButtonDelegate)];			
		if (confirmsToDetail) {
			UIViewController <NKSplitViewPopoverButtonDelegate> *controller = detailNavigationController.topViewController;
			if (controller && barButtonItem) {
				if ([controller respondsToSelector:@selector(invalidateMasterPopoverButtonItem:)]) {
					[controller invalidateMasterPopoverButtonItem:self.masterPopoverButtonItem];
				}
			}
		}
	}
	else {
		BOOL confirmsToDetail = [rightDetailController conformsToProtocol:@protocol(NKSplitViewPopoverButtonDelegate)];			
		if (confirmsToDetail) {
			UIViewController <NKSplitViewPopoverButtonDelegate> *controller = rightDetailController;
			if (controller && barButtonItem) {
				if ([controller respondsToSelector:@selector(invalidateMasterPopoverButtonItem:)]) {
					[controller invalidateMasterPopoverButtonItem:self.masterPopoverButtonItem];
				}
			}
		}
	}
	self.masterPopoverButtonItem = nil;
	self.popoverController = nil;
}

-(void) splitViewController:(NKSplitViewController *)svc popoverController:(UIPopoverController *)pc willPresentViewController:(UIViewController *)aViewController {

}

-(void) splitViewController:(NKSplitViewController *)svc willChangeSplitOrientationToVertical:(BOOL)isVertical {

}

-(void) splitViewController:(NKSplitViewController *)svc willMoveSplitToPosition:(float)position {
}

-(float) splitViewController:(NKSplitViewController *)svc constrainSplitPosition:(float)proposedPosition splitViewSize:(CGSize)viewSize {
	return proposedPosition;
}


#pragma mark <UIPopoverControllerDelegate>

-(BOOL) popoverControllerShouldDismissPopover:(UIPopoverController *)pc {
	return TRUE;
}

-(void) popoverControllerDidDismissPopover:(UIPopoverController *)pc {
}


#pragma mark -

-(void) dealloc {
	[navigators release]; navigators = nil;
	[popoverController release]; popoverController = nil;
	[masterPopoverButtonItem release]; masterPopoverButtonItem = nil;
	[masterPopoverButtonTitle release]; masterPopoverButtonTitle = nil;
	[super dealloc];
}

@end
