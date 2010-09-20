
#import <NavigatorKit/NKNavigatorGeometry.h>
#import <NavigatorKit/NKUIWindow.h>
#import <NavigatorKit/NKNavigator.h>
#import <NavigatorKit/NKUIDevice.h>

const CGFloat NKUIDefaultPortraitToolbarHeight	= 44;
const CGFloat NKUIDefaultLandscapeToolbarHeight	= 33;

CGRect
NKUIMainScreenBounds() {
	CGRect bounds = [UIScreen mainScreen].bounds;
	if (UIInterfaceOrientationIsLandscape(NKUIInterfaceOrientation())) {
		CGFloat width		= bounds.size.width;
		bounds.size.width	= bounds.size.height;
		bounds.size.height	= width;
	}
	return bounds;
}

CGRect 
NKUIApplicationFrame() {
	CGRect frame = [UIScreen mainScreen].applicationFrame;
	return CGRectMake(0, 0, frame.size.width, frame.size.height);
}

CGRect
NKUINavigationFrame() {
	CGRect frame = [UIScreen mainScreen].applicationFrame;
	if (UIInterfaceOrientationIsLandscape(NKUIInterfaceOrientation())) {
		CGFloat width		= frame.size.width;
		frame.size.width	= frame.size.height;
		frame.size.height	= width;
	}
	return CGRectMake(0, 0, frame.size.width, frame.size.height - NKUIToolbarHeight());
}

CGRect
NKUIToolbarNavigationFrame() {
	CGRect rect = NKUINavigationFrame();
	UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, NKUIToolbarHeight(), 0);
	return CGRectMake(rect.origin.x + insets.left, 
					  rect.origin.y + insets.top,
	                  rect.size.width  - (insets.left + insets.right),
	                  rect.size.height - (insets.top + insets.bottom));
}


#pragma mark -

CGFloat 
NKUIStatusHeight() {
	UIInterfaceOrientation orientation = NKUIInterfaceOrientation();
	if (orientation == UIInterfaceOrientationLandscapeLeft) {
		return [UIScreen mainScreen].applicationFrame.origin.x;
	}
	else if (orientation == UIInterfaceOrientationLandscapeRight) {
		return -[UIScreen mainScreen].applicationFrame.origin.x;
	}
	else {
		return [UIScreen mainScreen].applicationFrame.origin.y;
	}
}

CGFloat 
NKUIBarsHeight() {
	CGRect frame = [UIApplication sharedApplication].statusBarFrame;
	/*
	CGRect frame	= [UIApplication sharedApplication].statusBarFrame;
	CGFloat height	= frame.size.height;
	if (UIInterfaceOrientationIsLandscape(NKUIInterfaceOrientation())) {
		height = frame.size.width;
	}
	return height + NKUIToolbarHeight();	
	*/
	
	if (UIInterfaceOrientationIsPortrait(NKUIInterfaceOrientation())) {
		return frame.size.height + NKUIDefaultPortraitToolbarHeight;
	}
	else {
		return frame.size.width + NKUIDefaultLandscapeToolbarHeight;
	}
}

CGFloat 
NKUIToolbarHeight() {
	return NKUIToolbarHeightForOrientation(NKUIInterfaceOrientation());
}

CGFloat 
NKUIToolbarHeightForOrientation(UIInterfaceOrientation orientation) {
	if (UIInterfaceOrientationIsPortrait(orientation) || (NKUIDeviceHasUserIntefaceIdiom() && NKUIDeviceUserIntefaceIdiom() == UIUserInterfaceIdiomPad)) {
		return NKUIDefaultPortraitToolbarHeight;
	}
	else {
		return NKUIDefaultLandscapeToolbarHeight;
	}
}


#pragma mark -

UIInterfaceOrientation 
NKUIInterfaceOrientation() {
	UIInterfaceOrientation orient = [UIApplication sharedApplication].statusBarOrientation;
	if (UIDeviceOrientationUnknown == orient) {
		return [NKNavigator navigator].visibleViewController.interfaceOrientation;
	}
	else {
		return orient;
	}
}

UIDeviceOrientation 
NKUIDeviceOrientation() {
	UIDeviceOrientation orient = [UIDevice currentDevice].orientation;
	if (UIDeviceOrientationUnknown == orient) {
		return UIDeviceOrientationPortrait;
	}
	else {
		return orient;
	}
}

BOOL 
NKUIIsSupportedOrientation(UIInterfaceOrientation orientation) {
	if (NKUIDeviceHasUserIntefaceIdiom() && NKUIDeviceUserIntefaceIdiom() == UIUserInterfaceIdiomPad) {
		return TRUE;
	}
	switch (orientation) {
		case UIInterfaceOrientationPortrait:
		case UIInterfaceOrientationLandscapeLeft:
		case UIInterfaceOrientationLandscapeRight:
			return TRUE;
		default:
			return FALSE;
	}
}

CGAffineTransform 
NKUIRotateTransformForOrientation(UIInterfaceOrientation orientation) {
	if (orientation == UIInterfaceOrientationLandscapeLeft) {
		return CGAffineTransformMakeRotation(M_PI * 1.5);
	}
	else if (orientation == UIInterfaceOrientationLandscapeRight)  {
		return CGAffineTransformMakeRotation(M_PI / 2);
	}
	else if (orientation == UIInterfaceOrientationPortraitUpsideDown)  {
		return CGAffineTransformMakeRotation(-M_PI);
	}
	else {
		return CGAffineTransformIdentity;
	}
}
