
/*!
@project    NavigatorKit
@header     NKViewControllerProxy.h
@copyright  (c) 2010 - 2011, Dave Morford
*/

#import <UIKit/UIKit.h>

/*!
@class NKViewControllerProxy
@abstract
@discussion
*/
@interface NKViewControllerProxy : NSProxy

-(id) initWithViewController:(UIViewController *)aCcontroller;

@end
