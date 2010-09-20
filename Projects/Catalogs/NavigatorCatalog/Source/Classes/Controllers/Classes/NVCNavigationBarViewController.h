
/*!
@project	NavigatorCatalog
@header     NVCNavigationBarViewController.h
@copyright  (c) 2010, Semantap
@created	9/19/10
*/

#import <UIKit/UIKit.h>
#import <NavigatorKit/NavigatorKit.h>

/*!
@class NVCNavigationBarViewController
@superclass UIViewController <NKSplitViewPopoverButtonDelegate>
@abstract
@discussion
*/
@interface NVCNavigationBarViewController : UIViewController <NKSplitViewPopoverButtonDelegate>

@property (nonatomic, retain) UINavigationBar *navigationBar;

@end
