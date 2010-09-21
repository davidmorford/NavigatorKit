
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
	@property (nonatomic, retain) UIBarItem *titleBarItem;
	@property (nonatomic, copy) NSDictionary *documentItem;
	@property (nonatomic, retain) UIDocumentInteractionController *documentInteractionController;

@end
