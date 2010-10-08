
/*!
@project    NavigatorKit
@header     NKActionSheetController.h
@copyright  (c) 2009-2010, Three20
@changes    (c) 2009-2010, Dave Morford
*/

#import <NavigatorKit/NKPopupViewController.h>

@protocol NKActionSheetControllerDelegate;

/*!
@class NKActionSheetController
@superclass NKPopupViewController
@abstract A view controller that displays an action sheet.
@discussion ￼This class exists in order to allow action sheets to be displayed 
by NKNavigator, and gain all the benefits of persistence and URL dispatch. 
By default this controller is not persisted in the navigation history.
*/
@interface NKActionSheetController : NKPopupViewController <UIActionSheetDelegate>

@property (nonatomic, assign) id <NKActionSheetControllerDelegate> delegate;
@property (nonatomic, readonly) UIActionSheet *actionSheet;
@property (nonatomic, retain) id userInfo;

#pragma mark Initialziers

/*!
@abstract Create an action sheet controller without a delegate.
@param title The title of the action sheet.
*/
-(id) initWithTitle:(NSString *)aTitle;

/*!
@abstract The designated initializer.
@param title     The title of the action sheet.
@param delegate  A delegate that implements the NKActionSheetControllerDelegate protocol.
*/
-(id)initWithTitle:(NSString *)aTitle delegate:(id <NKActionSheetControllerDelegate>)aDelegate;

/*!
@abstract Append a button with the given title and NKNavigator URL.
@param title The title of the new button.
@param URL   The NKNavigator url.
@result The index of the new button. Button indices start at 0 and increase in the order they are added.
*/
-(NSInteger) addButtonWithTitle:(NSString *)aTitle URL:(NSString *)aURL;

/*!
@abstract Create a cancel button with the given title and NKNavigator URL. 
There can be only one cancel button.
@param title The title of the cancel button.
@param URL   The NKNavigator url.
@result The index of the cancel button. Button indices start at 0 and increase in the order they are added.
*/
-(NSInteger) addCancelButtonWithTitle:(NSString *)aTitle URL:(NSString *)aURL;

/*!
@abstract Create a destructive button with the given title and NKNavigator URL. 
There can be only one destructive button.
@param title The title of the cancel button.
@param URL   The NKNavigator url.
@result The index of the destructive button. Button indices start at 0 and increase in the order they are added.
*/
-(NSInteger) addDestructiveButtonWithTitle:(NSString *)aTitle URL:(NSString *)aURL;

/*!
@abstract Retrieve the button URL at the given index.
@param index The index of the button in question
@result nil if index is out of range. Otherwise returns the button's URL at index.
*/
-(NSString *) buttonURLAtIndex:(NSInteger)anIndex;

@end

#pragma mark -

/*!
@protocol NKActionSheetControllerDelegate <UIActionSheetDelegate>
@abstract Inherits the UIActionSheetDelegate protocol and adds NKNavigator support.
*/
@protocol NKActionSheetControllerDelegate <UIActionSheetDelegate>

/*!
@abstract Sent to the delegate after an action sheet is dismissed from the screen.
@discussion This method is invoked after the animation ends and the view is hidden.
If this method is not implemented, the default action is to open the given URL.
If this method is implemented and returns NO, then the caller will not navigate to 
the given URL.
@param controller  The controller that was dismissed.
@param buttonIndex The index of the button that was clicked. The button indices start at 0. If
					this is the cancel button index, the action sheet is canceling. If -1, the
					cancel button index is not set.
@param URL         The URL of the selected button.
@result	YES to open the given URL with NKNavigatorOpenURL.
*/
-(BOOL) actionSheetController:(NKActionSheetController *)aController didDismissWithButtonIndex:(NSInteger)aButtonIndex URL:(NSString *)aURLString;

@end
