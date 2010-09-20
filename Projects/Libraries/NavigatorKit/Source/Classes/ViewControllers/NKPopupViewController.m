
#import <NavigatorKit/NKPopupViewController.h>
#import <NavigatorKit/NKUIViewController.h>

@implementation NKPopupViewController

#pragma mark Initializer

-(id) init {
	if (self = [super init]) {
		self.statusBarStyle = [UIApplication sharedApplication].statusBarStyle;
	}
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
	if (self = [super initWithFrame:frame]) {
		popupViewController = nil;
	}
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
	[popupViewController release]; popupViewController = nil;
	[super dealloc];
}

@end
