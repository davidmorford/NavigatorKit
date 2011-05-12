
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
@property (nonatomic, retain) UIBarButtonItem *optionsItem;
@property (nonatomic, retain) UISegmentedControl *optionsSegmentedControl;

#pragma mark -

-(void) toggleMasterView:(id)sender;
-(void) toggleVertical:(id)sender;
-(void) toggleDividerStyle:(id)sender;
-(void) toggleMasterBeforeDetail:(id)sender;

@end
