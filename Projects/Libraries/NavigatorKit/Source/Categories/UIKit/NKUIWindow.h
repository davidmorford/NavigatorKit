
/*!
@project    NavigatorKit
@header     NKUIWindow.h
@copyright	(c) 2009-2010, Three20
@changes	(c) 2009-2010, Dave Morford
*/

#import <UIKit/UIKit.h>

/*!
@category UIWindow (NKUIWindow)
@abstract
@discussion
*/
@interface UIWindow (NKUIWindow)

	-(UIView *) findFirstResponder;

	-(UIView *) findFirstResponderInView:(UIView *)topView;

@end
