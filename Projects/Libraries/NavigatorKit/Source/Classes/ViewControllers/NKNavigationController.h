
/*!
@project    NavigatorKit
@header     NKNavigationController.h
@copyright  (c) 2009, Three20
@copyright  (c) 2009 - 2011, Dave Morford
*/

#import <UIKit/UIKit.h>

/*!
@class NKNavigationController
@superclass UINavigationController
@abstract
@discussion
*/
@interface NKNavigationController : UINavigationController

/*!
@abstract Pushes a view controller with a transition other than the standard sliding animation.
*/
-(void) pushViewController:(UIViewController *)controller animatedWithTransition:(UIViewAnimationTransition)aTransition;

/*!
@abstract Pops a view controller with a transition other than the standard sliding animation.
*/
-(UIViewController *) popViewControllerAnimatedWithTransition:(UIViewAnimationTransition)aTransition;

-(void) resetWithRootController:(UIViewController *)aViewController;

-(UIViewAnimationTransition) invertTransition:(UIViewAnimationTransition)aTransition;

@end
