
/*!
@project    NavigatorKit
@header     NKNavigationController.h
@copyright  (c) 2009-2010, Three20
@copyright  (c) 2009-2010, Dave Morford
*/

#import <UIKit/UIKit.h>

/*!
@class NKNavigationController
@superclass UIViewController
@abstract
@discussion
*/
@interface NKNavigationController : UINavigationController

/*!
@abstract Pushes a view controller with a transition other than the standard sliding animation.
*/
-(void) pushViewController:(UIViewController *)controller animatedWithTransition:(UIViewAnimationTransition)transition;

/*!
@abstract Pops a view controller with a transition other than the standard sliding animation.
*/
-(UIViewController *) popViewControllerAnimatedWithTransition:(UIViewAnimationTransition)transition;

-(void) resetWithRootController:(UIViewController *)aViewController;

-(UIViewAnimationTransition) invertTransition:(UIViewAnimationTransition)aTransition;

@end
