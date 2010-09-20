
/*!
@project    NavigatorKit
@header     NKSplitViewPopoverButtonDelegate.h
@abstract	Based on Malcolm Crawford's devforums.apple.com posts.
*/

#import <UIKit/UIKit.h>

/*!
@protocol NKSplitViewPopoverButtonDelegate <NSObject>
@abstract A protocol detail view controllers implement to hide and show the bar button 
item controlling the popover.
@discussion Allows detail controller implemention use the bar button item a
view controllers UIToolbar or UINavigationBar or the UINavigationItem for the 
view controller if within a navigation controllers.
*/
@protocol NKSplitViewPopoverButtonDelegate <NSObject>
-(void) showMasterPopoverButtonItem:(UIBarButtonItem *)barButtonItem;
-(void) invalidateMasterPopoverButtonItem:(UIBarButtonItem *)barButtonItem;
@end
