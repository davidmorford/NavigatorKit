
#import <UIKit/UIKit.h>
#import <NavigatorKit/NKNavigator.h>
#import <NavigatorKit/NKNavigatorMap.h>
#import <NavigatorKit/NKNavigatorPattern.h>

@interface NKNavigator ()

-(id) initWithWindowClass:(Class)windowCls navigationControllerClass:(Class)navControllerCls;

@property (nonatomic, retain, readwrite) NKNavigatorMap *navigationMap;	
@property (nonatomic, retain, readwrite) UIViewController *rootViewController;
@property (nonatomic, retain) NSMutableArray *delayedControllers;
@property (nonatomic, assign) BOOL delayCount;
	
+(UIViewController *) frontViewControllerForController:(UIViewController *)controller;

#pragma mark -

-(void) setRootNavigationController:(UINavigationController *)aController;
-(UINavigationController *) frontNavigationController;
-(UIViewController *) frontViewController;
-(UIViewController *) visibleChildControllerForController:(UIViewController *)controller;

#pragma mark Parent Navigator

@property (nonatomic, assign, readwrite) NKNavigator *parentNavigator;
-(void) navigator:(NKNavigator *)navigator didDisplayController:(UIViewController *)controller;

#pragma mark -

/*!
@result NO if the controller already has a super controller and is simply made visible.
		YES if the controller is the new root or if it did not have a super controller.
*/
-(BOOL) presentController:(UIViewController *)aController parentController:(UIViewController *)aParentController mode:(NKNavigatorMode)aMode animated:(BOOL)animated transition:(NSInteger)aTransition presentationStyle:(UIModalPresentationStyle)aStyle sender:(id)aSender;
-(BOOL) presentController:(UIViewController *)aController parentURLPath:(NSString *)aParentURLPath withPattern:(NKNavigatorPattern *)aPattern animated:(BOOL)animated transition:(NSInteger)aTransition presentationStyle:(UIModalPresentationStyle)aStyle sender:(id)aSender;

/*!
@abstract Present a view controller that strictly depends on the existence of the parent controller.
*/
-(void) presentDependentController:(UIViewController *)aController parentController:(UIViewController *)aParentController mode:(NKNavigatorMode)aMode animated:(BOOL)animated transition:(NSInteger)aTransition presentationStyle:(UIModalPresentationStyle)aStyle sender:(id)aSender;

/*!
@abstract A modal controller is a view controller that is presented over another controller and hides
the original controller completely. Classic examples include the Safari login controller when
authenticating on a network, creating a new contact in Contacts, and the Camera controller.
@discussion If the controller that is being presented is not a UINavigationController, then a
UINavigationController is created and the controller is pushed onto the navigation controller.
The navigation controller is then displayed instead.
*/
-(void) presentModalController:(UIViewController *)aController parentController:(UIViewController *)aParentController animated:(BOOL)animated transition:(NSInteger)aTransition presentationStyle:(UIModalPresentationStyle)aPresentationStyle sender:(id)aSender;

/*!
@abstract A popover controller is a view controller added in iPad that is presented over another controller and hides
the original controller only partially.
@discussion If the controller that is being presented is not a UINavigationController, then a
UINavigationController is created and the controller is pushed onto the navigation controller.
The navigation controller is then displayed instead.
*/
-(void) presentPopoverController:(UIViewController *)aController parentController:(UIViewController *)aParentController animated:(BOOL)animated transition:(NSInteger)aTransition sender:(id)sender;

@end
