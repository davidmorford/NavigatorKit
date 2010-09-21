
/*!
@project    NavigatorCatalog
@header     NVCDocumentsFolderViewController.h
*/

#import <UIKit/UIKit.h>

@class NVCDetailViewController;

/*!
@class NVCDocumentsFolderViewController 
@superclass  UITableViewController
@abstract
@discussion
*/
@interface NVCDocumentsFolderViewController : UITableViewController {
}

	@property (nonatomic, retain) NVCDetailViewController *detailViewController;

@end
