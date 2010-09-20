
#import <NavigatorKit/NKViewControllerProxy.h>
#import <NavigatorKit/NKNavigator.h>
#import <NavigatorKit/NKNavigatorMap.h>
#import <NavigatorKit/NKUIViewController.h>

@implementation NKViewControllerProxy

#pragma mark -

-(id) initWithViewController:(UIViewController *)aController {
	viewController = [aController retain];
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
	[viewController release];/* viewController = nil;*/
	[super dealloc];
}

@end
