
/*!
@project    NavigatorKit
@header     UISplitViewController+NKNavigator.h
@copyright	(c) 2010 - 2011, Dave Morford
*/

#import <UIKit/UIKit.h>

/*!
@category UISplitViewController (NKNavigator)
@abstract
@discussion
*/
@interface UISplitViewController (NKNavigator)

@property (nonatomic, readonly) id masterViewController;
@property (nonatomic, readonly) id detailViewController;

-(void) setViewControllersWithNavigationURLs:(NSArray *)navigationURLs;

@end
