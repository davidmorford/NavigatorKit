
/*!
@project	NavigatorKit
@header		NKUIViewController.h
@copyright	(c) 2009-2010, Three20
@changes	(c) 2009-2010, Dave Morford
*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class NKNavigator;

/*!
@category UIViewController (NKUIViewController)
@abstract
*/
@interface UIViewController (NKViewController)

/*!
@abstract The view controller that contains this view controller.
@discussion This is just like parentViewController, except that it is not readonly.  
This property offers custom UIViewController subclasses the chance to tell NKNavigator 
how to follow the hierarchy of view controllers.
*/
@property (nonatomic, retain) UIViewController *superController;

/*!
@abstract A popup view controller that is presented on top of this view controller.
*/
@property (nonatomic, retain) UIViewController *popupViewController;

/*!
A popover controller that is presented on top of this view controller.
*/
@property (nonatomic, retain) UIPopoverController *popoverController;

#pragma mark -

/*!
@abstract Determines whether a controller is primarily a container of other controllers.
*/
@property (nonatomic, readonly) BOOL canContainControllers;

/*!
@abstract Whether or not this controller should ever be counted as the "top" 
view controller. That is used for the purposes of determining which controllers 
should have modal controllers presented within them. Defaults to YES; subclasses 
may override to NO if they so desire.
*/
@property (nonatomic, readonly) BOOL canBeTopViewController;


#pragma mark -

/*!
@abstract The child of this view controller which is most visible.
@discussion This would be the selected view controller of a tab bar controller, or the top
view controller of a navigation controller.  This property offers custom UIViewController
subclasses the chance to tell NKNavigator how to follow the hierarchy of view controllers.
*/
-(UIViewController *) topSubcontroller;

/*!
@abstract The view controller that comes before this one in a navigation controller's history.
@discussion If Apple uses antecedent as a disambiguating adjective in any API, public or private,
shoot me.
*/
-(UIViewController *) antecedentViewController;

/*!
@abstract The view controller that comes after this one in a navigation controller's history.
*/
-(UIViewController *) nextViewController;

#pragma mark -

/*!
@abstract Displays a controller inside this controller.
@discussion NKNavigatorMap uses this to display newly created controllers.  The default does nothing --
UIViewController categories and subclasses should implement to display the controller
in a manner specific to them.
*/
-(void) addSubcontroller:(UIViewController *)aController animated:(BOOL)animated transition:(UIViewAnimationTransition)transition;

/*!
@abstract Dismisses a view controller using the opposite transition it was presented with.
*/
-(void) removeFromSupercontroller;

/*!
@method removeFromSupercontrollerAnimated:
@param animated 
*/
-(void) removeFromSupercontrollerAnimated:(BOOL)animated;

/*!
@abstract Brings a controller that is a child of this controller to the front.
@discussion NKNavigatorMap uses this to display controllers that exist already, but may not be visible.
The default does nothing -- UIViewController categories and subclasses should implement
to display the controller in a manner specific to them.
*/
-(void) bringControllerToFront:(UIViewController *)aController animated:(BOOL)animated;

/*!
@abstract Gets a key that can be used to identify a subcontroller in subcontrollerForKey.
*/
-(NSString *) keyForSubcontroller:(UIViewController *)aController;

/*!
@abstract Gets a subcontroller with the key that was returned from keyForSubcontroller.
*/
-(UIViewController *) subcontrollerForKey:(NSString *)aKey;


#pragma mark -
/*!
@abstract Finishes initializing the controller after a NKNavigator-coordinated delay.
@discussion If the controller was created in between calls to NKNavigator beginDelay 
and endDelay, then this will be called after endDelay.
*/
-(void) delayDidEnd;


#pragma mark -

/*!
@abstract Shows or hides the navigation and status bars.
*/
-(void) showBars:(BOOL)show animated:(BOOL)animated;

@end

#pragma mark -

/*!
@category UIViewController (NKNavigator)
@abstract
*/
@interface UIViewController (NKNavigator)

/*!
@abstract The current URL that this view controller represents.
*/
@property (nonatomic, readonly) NSString *navigatorURL;

/*!
@abstract The URL that was used to load this controller through NKNavigator.
@discussion Do not ever change the value of this property.  NKNavigator will assign this
when creating your view controller, and it expects it to remain constant throughout
the view controller's life.  You can override navigatorURL if you want to specify
a different URL for your view controller to use when persisting and restoring it.
*/
@property (nonatomic, copy) NSString *originalNavigatorURL;

@property (nonatomic, retain) NKNavigator *responsibleNavigator;


#pragma mark -

/*!
@abstract The default initializer sent to view controllers opened through NKNavigator.
*/
-(id) initWithNavigatorURL:(NSURL *)aURL query:(NSDictionary *)aQuery;

@end

#pragma mark -

/*!
@category UIViewController (NKModal)
@abstract
*/
@interface UIViewController (NKModalController)

@property (nonatomic, assign, readonly) BOOL isModal;

/*!
@abstract Shortcut for its animated-optional cousin.
*/
-(void) dismissModalViewController;
-(void) dismissAnimated:(BOOL)inAnimated;

@end

#pragma mark -

/*!
@category UIViewController (NKNavigatorActionMap)
@abstract A view controller can provide a local navigation map of actionName - selectorName pairs
where actionName will be used as a local URL path: <originalNavigationPath></actionName>
*/
@interface UIViewController (NKNavigatorActionMap)
@property (nonatomic, readonly) NSDictionary *navigationActions;
-(void) addNavigationActions;
-(void) removeNavigationActions;
@end
