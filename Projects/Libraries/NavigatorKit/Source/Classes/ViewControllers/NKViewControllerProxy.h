
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
@interface NKViewControllerProxy : NSProxy

@property (nonatomic, retain) UIViewController *viewController;

-(id) initWithViewController:(UIViewController *)controller;

@end
