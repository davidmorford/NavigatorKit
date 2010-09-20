
/*!
@project	___PROJECTNAME___
@header		___PROJECTNAMEASIDENTIFIER___ApplicationDelegate.h
@copyright	(c) ___YEAR___, ___ORGANIZATIONNAME___
@created	___DATE___: ___FULLUSERNAME___
*/

#import <UIKit/UIKit.h>
#import <NavigatorKit/NavigatorKit.h>

@class ___PROJECTNAMEASIDENTIFIER___MasterViewController, ___PROJECTNAMEASIDENTIFIER___DetailViewController;

/*!
@class ___PROJECTNAMEASIDENTIFIER___ApplicationDelegate
@superclass NSObject <UIApplicationDelegate, NKNavigatorDelegate>
@abstract
@discussion
*/
@interface ___PROJECTNAMEASIDENTIFIER___ApplicationDelegate : NSObject <UIApplicationDelegate, NKNavigatorDelegate>

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UISplitViewController *splitViewController;

#pragma mark -

+(___PROJECTNAMEASIDENTIFIER___ApplicationDelegate *) sharedApplicationDelegate;

#pragma mark -

@property (nonatomic, readonly) NSString *applicationDocumentsDirectoryPath;

@end
