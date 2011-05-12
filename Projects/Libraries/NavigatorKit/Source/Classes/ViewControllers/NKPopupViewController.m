
#import <NavigatorKit/NKPopupViewController.h>
#import <NavigatorKit/UIViewController+NKNavigator.h>

@implementation NKPopupViewController

#pragma mark Initializer

-(id) init {
    self = [super init];
	if (!self) {
		return nil;
	}
    self.statusBarStyle = [UIApplication sharedApplication].statusBarStyle;
	return self;
}


#pragma mark API

-(void) showInView:(UIView *)view animated:(BOOL)animated {

}

-(void) dismissPopupViewControllerAnimated:(BOOL)animated {

}

-(BOOL) canBeTopViewController {
	return FALSE;
}


#pragma mark Memoery

-(void) dealloc {
	[self.superController setPopupViewController:nil];
	[super dealloc];
}

@end

#pragma mark -

@implementation NKPopupView

@synthesize popupViewController;

#pragma mark Initializer

-(id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	if (!self) {
        return nil;
	}
    popupViewController = nil;
	return self;
}


#pragma mark API

-(void) didAddSubview:(UIView *)subview {
}

-(void) willRemoveSubview:(UIView *)subview {
	[self removeFromSuperview];
}


#pragma mark Memory

-(void) dealloc {
	self.popupViewController = nil;
	[super dealloc];
}

@end
