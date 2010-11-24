
#import <NavigatorKit/NKViewControllerProxy.h>
#import <NavigatorKit/NKNavigator.h>
#import <NavigatorKit/NKNavigatorMap.h>
#import <NavigatorKit/NKUIViewController.h>

@implementation NKViewControllerProxy

#pragma mark -

-(id) initWithViewController:(UIViewController *)aController {
	self.viewController = aController;
	return self;
}

#pragma mark NSObject

-(void) forwardInvocation:(NSInvocation *)anInvocation {
	[anInvocation setTarget:self.viewController];
	[anInvocation invoke];
	return;
}

-(NSMethodSignature *) methodSignatureForSelector:(SEL)aSelector {
	return [self.viewController methodSignatureForSelector:aSelector];
}

#pragma mark -

-(void) dealloc {
	NSString *URL = [self.viewController originalNavigatorURL];
	if (URL) {
		[[NKNavigator navigator].navigationMap removeObjectForURL:URL];
	}
	[self.viewController setSuperController:nil];
	[self.viewController setPopupViewController:nil];
	self.viewController = nil;
	[super dealloc];
}

@end
