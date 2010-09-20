
/*!
@project    NavigatorKit
@header     NKViewControllerProxy.h
@copyright  (c) 2010, Dave Morford
*/

#import <UIKit/UIKit.h>

/*!
@class NKViewControllerProxy
@abstract
@discussion
*/
@interface NKViewControllerProxy : NSProxy {
	UIViewController *viewController;
}

-(id) initWithViewController:(UIViewController *)controller;

@end
