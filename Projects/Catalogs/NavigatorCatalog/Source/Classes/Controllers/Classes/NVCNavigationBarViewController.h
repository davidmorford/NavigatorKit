
/*!
@project	NavigatorCatalog
@header     NVCNavigationBarViewController.h
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
