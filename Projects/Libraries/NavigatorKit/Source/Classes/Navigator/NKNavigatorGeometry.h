
/*!
@project    NavigatorKit
@header     NKNavigatorGeometry.h
@copyright  (c) 2009 - 2010, Semantap
*/

#import <UIKit/UIKit.h>

/*!
@abstract The standard height of a toolbar in portrait orientation, 44 pixels
*/
extern const CGFloat NKUIDefaultPortraitToolbarHeight;

/*!
@abstract The standard height of a toolbar in landscape orientation. 33 pixels
*/
extern const CGFloat NKUIDefaultLandscapeToolbarHeight;

#pragma mark Frames

/*!
@abstract Bounds of the screen with device orientation factored in.
*/
CGRect
NKUIMainScreenBounds();

/*!
@result The application frame rect with no offset.
@abstract Frame of application screen area in points (i.e. entire screen minus status bar if visible)
*/
CGRect 
NKUIApplicationFrame();

/*!
@abstract application frame rect below the navigation bar.
*/
CGRect
NKUINavigationFrame();


#pragma mark Bars

/*!
@abstract the height of the area containing the status bar and possibly the in-call status bar.
*/
CGFloat
NKUIStatusHeight();

/*!
@abstract the height of the area containing the status bar and navigation bar.
*/
CGFloat
NKUIBarsHeight();

/*!
@abstract the height of a toolbar considering the current orientation.
*/
CGFloat
NKUIToolbarHeight();

/*!
@result The toolbar height for a given orientation.
The toolbar is slightly shorter in landscape.
*/
CGFloat 
NKUIToolbarHeightForOrientation(UIInterfaceOrientation orientation);

/*!
@abstract frame rect below the navigation bar and above a toolbar.
*/
CGRect
NKUIToolbarNavigationFrame();


#pragma mark Orientation

/*!
@abstract The current orientation of the visible view controller.
*/
UIInterfaceOrientation
NKUIInterfaceOrientation();

/*!
@abstract the current device orientation.
*/
UIDeviceOrientation 
NKUIDeviceOrientation();

/*!
@abstract On the iPhone/iPod touch device: 
Checks if the orientation is portrait, landscape left, or landscape right. This helps to ignore upside down and flat orientations.
On the iPad:Always returns YES.
*/
BOOL 
NKUIIsSupportedOrientation(UIInterfaceOrientation orientation);

/*!
@result The rotation transform for a given orientation.
*/
CGAffineTransform 
NKUIRotateTransformForOrientation(UIInterfaceOrientation orientation);
