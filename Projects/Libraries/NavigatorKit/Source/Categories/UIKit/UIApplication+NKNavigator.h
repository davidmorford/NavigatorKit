
/*!
@project    NavigatorKit
@header     UIApplication+NKNavigator.h
@copyright  (c) 2010 - 2011, Dave Morford
*/

#import <Foundation/Foundation.h>
#import <NavigatorKit/NKNavigator.h>
#import <NavigatorKit/NKSplitViewNavigator.h>
#import <NavigatorKit/NKUISplitViewNavigator.h>

/*!
@class UIApplication (NKNavigator)
@abstract
@discussion
*/
@interface UIApplication (NKNavigator)

@property (nonatomic, retain) NKNavigator *applicationNavigator;

@end
