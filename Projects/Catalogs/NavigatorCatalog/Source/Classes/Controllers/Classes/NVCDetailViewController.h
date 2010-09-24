
/*!
@project	NavigatorCatalog
@header     NVCDetailViewController.h
*/

#import <UIKit/UIKit.h>
#import <NavigatorKit/NavigatorKit.h>

/*!
@class NVCDetailViewController
@superclass UIViewController <NKSplitViewPopoverButtonDelegate>
@abstract
@discussion
*/
@interface NVCDetailViewController : UIViewController <NKSplitViewPopoverButtonDelegate, UIDocumentInteractionControllerDelegate>

	@property (nonatomic, retain) UIToolbar *toolbar;
	@property (nonatomic, copy) NSDictionary *documentItem;
	@property (nonatomic, retain) UIDocumentInteractionController *documentInteractionController;
	@property (nonatomic, retain) UIBarButtonItem *optionsItem;
	@property (nonatomic, retain) UISegmentedControl *optionsSegmentedControl;

	#pragma mark -

	-(void) toggleMasterView:(id)sender;
	-(void) toggleVertical:(id)sender;
	-(void) toggleDividerStyle:(id)sender;
	-(void) toggleMasterBeforeDetail:(id)sender;

@end
