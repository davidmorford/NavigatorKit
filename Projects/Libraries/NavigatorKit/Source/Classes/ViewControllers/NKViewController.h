
/*!
@project    NavigatorKit
@header     NKViewController.h
@copyright  (c) 2009-2010, Three20
@changes    (c) 2009-2010, Dave Morford
*/

#import <UIKit/UIKit.h>

/*!
@class NKViewController
@superclass UIViewController
@abstract A view controller with some useful additions.
@discussion 
*/
@interface NKViewController : UIViewController

/*!
@abstract The style of the navigation bar when this view 
controller is pushed onto a navigation controller.
*/
@property (nonatomic, assign) UIBarStyle navigationBarStyle;

/*!
@abstract The color of the navigation bar when this view 
controller is pushed onto a navigation controller.
*/
@property (nonatomic, retain) UIColor *navigationBarTintColor;

/*!
@abstract The style of the status bar when this view controller is appearing.
*/
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;	

/*!
@abstract The view has appeared at least once.
*/
@property (nonatomic, readonly) BOOL hasViewAppeared;

/*!
@abstract The view is currently visible.
*/
@property (nonatomic, readonly) BOOL isViewAppearing;

/*!
@abstract Determines if the view will be resized automatically to fit the keyboard.
*/
@property (nonatomic, assign) BOOL autoresizesForKeyboard;


#pragma mark -

/*!
@abstract Sent to the controller before the keyboard slides in.
*/
-(void) keyboardWillAppear:(BOOL)animated withBounds:(CGRect)bounds;
-(void) keyboardWillAppear:(BOOL)animated withBounds:(CGRect)bounds animationDuration:(NSTimeInterval)aDuration;

/*!
@abstract Sent to the controller before the keyboard slides out.
*/
-(void) keyboardWillDisappear:(BOOL)animated withBounds:(CGRect)bounds;
-(void) keyboardWillDisappear:(BOOL)animated withBounds:(CGRect)bounds animationDuration:(NSTimeInterval)aDuration;

/*!
@abstract Sent to the controller after the keyboard has slid in.
*/
-(void) keyboardDidAppear:(BOOL)animated withBounds:(CGRect)bounds;

/*!
@abstract Sent to the controller after the keyboard has slid out.
*/
-(void) keyboardDidDisappear:(BOOL)animated withBounds:(CGRect)bounds;

@end
