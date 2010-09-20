
/*!
@project    NavigatorKit
@header     NKAlertViewController.h
@copyright  (c) 2009-2010, Three20
@changes    (c) 2009-2010, Dave Morford
*/

#import <NavigatorKit/NKPopupViewController.h>

@protocol NKAlertViewControllerDelegate;

/*!
@class NKAlertViewController
@superclass NKPopupViewController
@abstract A view controller that displays an alert view.
@discussion This class exists in order to allow alert views to be displayed 
by NKNavigator, and gain all the benefits of persistence and URL dispatch.
*/
@interface NKAlertViewController : NKPopupViewController <UIAlertViewDelegate>

@property (nonatomic, assign) id <NKAlertViewControllerDelegate> delegate;
@property (nonatomic, readonly) UIAlertView *alertView;
@property (nonatomic, retain) id userInfo;

#pragma mark Initializer

-(id) initWithTitle:(NSString *)aTitle message:(NSString *)aMessage;
-(id) initWithTitle:(NSString *)aTitle message:(NSString *)aMessage delegate:(id)aDelegate;

-(NSInteger) addButtonWithTitle:(NSString *)aTitle URL:(NSString *)aURL;
-(NSInteger) addCancelButtonWithTitle:(NSString *)aTitle URL:(NSString *)aURL;

-(NSString * ) buttonURLAtIndex:(NSInteger)anIndex;

@end

#pragma mark -

/*!
@protocol NKAlertViewControllerDelegate <UIAlertViewDelegate>
@abstract
*/
@protocol NKAlertViewControllerDelegate <UIAlertViewDelegate>
-(BOOL) alertViewController:(NKAlertViewController *)aController didDismissWithButtonIndex:(NSInteger)aButtonIndex  URL:(NSString *)aURLString;
@end
