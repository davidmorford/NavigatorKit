
/*!
@project    NavigatorKit
@header     NKPopupViewController.h
@copyright  (c) 2009-2010, Three20
@changes    (c) 2009-2010, Dave Morford
*/

#import <NavigatorKit/NKViewController.h>

/*!
@class NKPopupViewController
@superclass NKViewController
@abstract A view controller which, when displayed modally, inserts its view over the parent controller.
The best way to use this class is to bind. This class is meant to be subclassed, not used directly.
@discussion￼ Normally, displaying a modal view controller will completely hide the underlying view
controller, and even remove its view from the view hierarchy.  Popup view controllers allow
you to present a "modal" view which overlaps the parent view controller but does not
necessarily hide it.
*/
@interface NKPopupViewController : NKViewController

-(void) showInView:(UIView *)aView animated:(BOOL)animated;
-(void) dismissPopupViewControllerAnimated:(BOOL)animated;

@end

#pragma mark -

/*!
@class NKPopupView
@superclass UIView
@abstract
@discussion
*/
@interface NKPopupView : UIView
@property (nonatomic, retain) UIViewController *popupViewController;
@end
