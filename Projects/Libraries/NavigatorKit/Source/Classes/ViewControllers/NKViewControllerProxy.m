
#import <NavigatorKit/NKViewControllerProxy.h>
#import <NavigatorKit/NKNavigator.h>
#import <NavigatorKit/NKNavigatorMap.h>
#import <NavigatorKit/UIViewController+NKNavigator.h>

@interface NKViewControllerProxy ()
@property (nonatomic, retain) UIViewController *viewController;
@end

#pragma mark -

@implementation NKViewControllerProxy

@synthesize viewController;

#pragma mark -

-(id) initWithViewController:(UIViewController *)aController {
	self.viewController = aController;
	return self;
}

#pragma mark NSObject

-(void) forwardInvocation:(NSInvocation *)anInvocation {
	[anInvocation setTarget:viewController];
	[anInvocation invoke];
	return;
}

-(NSMethodSignature *) methodSignatureForSelector:(SEL)aSelector {
	return [viewController methodSignatureForSelector:aSelector];
}

#pragma mark -

-(void) dealloc {
	NSString *URL = [viewController originalNavigatorURL];
	if (URL) {
		[[NKNavigator navigator].navigationMap removeObjectForURL:URL];
	}
	[viewController setSuperController:nil];
	[viewController setPopupViewController:nil];
	self.viewController = nil;
	[super dealloc];
}

@end
