
/*!
@project	NavigatorCatalog
@header		NVCApplicationDelegate.h
@copyright	(c) 2010, Semantap
@created	9/19/2010
*/

#import <UIKit/UIKit.h>
#import <NavigatorKit/NavigatorKit.h>

@class NVCMasterViewController, NVCDetailViewController;

/*!
@class NVCApplicationDelegate
@superclass NSObject <UIApplicationDelegate, NKNavigatorDelegate>
@abstract
@discussion
*/
@interface NVCApplicationDelegate : NSObject <UIApplicationDelegate, NKNavigatorDelegate, UITabBarControllerDelegate, NKAlertViewControllerDelegate, NKActionSheetControllerDelegate>

+(NVCApplicationDelegate *) sharedApplicationDelegate;

#pragma mark -

@property (nonatomic, readonly) NSString *applicationDocumentsDirectoryPath;

@end
