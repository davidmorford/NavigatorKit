
/*!
@project    NavigatorKit
@header     NKNavigator.h
@copyright  (c) 2009-2010, Three20
@changes    (c) 2009-2010, Dave Morford
*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol NKNavigatorDelegate;
@class NKNavigatorMap, NKURLNavigatorPattern, NKNavigatorAction;

/*!
@class NKNavigator
@superclass NSObject
@abstract A URL-based navigation system with built-in persistence.
@discussion
*/
@interface NKNavigator : NSObject

@property (nonatomic, assign) id <NKNavigatorDelegate> delegate;

/*!
@abstract The URL map used to translate between URLs and view controllers.
*/
@property (nonatomic, retain, readonly) NKNavigatorMap *navigationMap;

/*!
@abstract The window that contains the views view controller hierarchy. 
By default retrieves the keyWindow. If there is no keyWindow, creates a 
new NKNavigationWindow.
*/
@property (nonatomic, retain) UIWindow *window;

/*!
@abstract The controller that is at the root of the view controller hierarchy.
*/
@property (nonatomic, retain, readonly) UIViewController *rootViewController;

/*!
@abstract The currently visible view controller.
*/
@property (nonatomic, readonly) UIViewController *visibleViewController;

/*!
@abstract The view controller that is currently on top of the navigation stack.
@discussion This differs from visibleViewController in that it ignores things like search
display controllers which are visible, but not part of navigation.
*/
@property (nonatomic, readonly) UIViewController *topViewController;

/*!
@abstract The URL of the currently visible view controller;
@discussion Setting this property will open a new URL.
*/
@property (nonatomic, copy) NSString *currentURL;

/*!
@abstract Allows URLs to be opened externally if they don't match any patterns.
The default value is NO.
*/
@property (nonatomic, assign) BOOL opensExternalURLs;

/*!
@abstract Indicates that we are asking controllers to delay heavy operations until a later time.
@discussion The default value is NO.
*/
@property (nonatomic, readonly) BOOL isDelayed;

@property (nonatomic, assign) BOOL wantsNavigationControllerForRoot;

/*!
@abstract A unique prefix used when storing the navigation history in the user defaults.
@default nil
*/
@property (nonatomic, copy) NSString *uniquePrefix;

/*!
@abstract A unique prefix used when storing the navigation history in the user defaults.
@default nil
*/
@property (nonatomic, copy) NSString *defaultURLScheme;


#pragma mark -

+(NKNavigator *) navigator;

#pragma mark -

/*!
@abstract Load and display the view controller with a pattern that matches the URL.
@discussion If there is not yet a rootViewController, the view controller loaded with this URL
will be assigned as the rootViewController and inserted into the keyWindow. If there is not
a keyWindow, a UIWindow will be created and displayed.
@example NKNavigatorAction initialization:
[NKNavigatorAction actionWithURLPath:@"appscheme://some/path"]
Each with* method on the NKNavigatorAction object returns self, allowing you to chain methods
when initializing the object. This allows for a flexible method that requires a shifting set
of parameters that have specific defaults. The old openURL* methods are being phased out, so
please start using openNavigatorAction instead.
*/
-(UIViewController *) openNavigatorAction:(NKNavigatorAction *)aURLAction;

/*!
@abstract Opens a sequence of URLs, with only the last one being animated.
@result The view controller of the last opened URL.
*/
-(UIViewController *) openURLs:(NSString *)aURL, ...;

/*!
@abstract Gets a view controller for the URL without opening it.
@return The view controller mapped to URL.
*/
-(UIViewController *) viewControllerForURL:(NSString *)aURL;	

/*!
@abstract Gets a view controller for the URL without opening it.
@result The view controller mapped to URL.
*/
-(UIViewController *) viewControllerForURL:(NSString *)aURL query:(NSDictionary *)query;

/*!
@abstract Gets a view controller for the URL without opening it.
@result The view controller mapped to URL.
*/
-(UIViewController *) viewControllerForURL:(NSString *)aURL query:(NSDictionary *)query pattern:(NKURLNavigatorPattern * *)pattern;

#pragma mark -

/*!
@abstract The parent navigator
*/
@property (nonatomic, assign, readonly) NKNavigator *parentNavigator;

/*!
@abstract Retrieve the NKNavigator that has the given urlPath mapped 
in its NKNavigatorMap. May be this navigator, or one of its sub-navigators.
*/
-(NKNavigator*) navigatorForURLPath:(NSString *)aURLPath;


#pragma mark -

/*!
@abstract Tells the navigator to delay heavy operations.
@discussion Initializing controllers can be very expensive, so if you are going to 
do some animation while this might be happening, this will tell controllers created 
through the navigator that they should hold off so as not to slow down the operations.
*/
-(void) beginDelay;

/*!
@abstract Tells controllers that were created during the delay to finish what they were planning to do.
*/
-(void) endDelay;

/*!
@abstract Cancels the delay without notifying delayed controllers.
*/
-(void) cancelDelay;

/*!
@abstract Removes all view controllers from the window and releases them.
*/
-(void) removeAllViewControllers;

/*!
@abstract A navigation path which can be used to locate an object.
*/
-(NSString *) pathForObject:(id)anObject;

/*!
@abstract Finds an object using its navigation path.
*/
-(id) objectForPath:(NSString *)aPath;


#pragma mark -

/*!
@abstract Prepare the given controller's parent controller and return it. Ensures that the parent
controller exists in the navigation hierarchy. If it doesn't exist, and the given controller
isn't a container, then a UINavigationController will be made the root controller.
*/
-(UIViewController *) parentForController:(UIViewController *)controller parentURLPath:(NSString *)parentURLPath isContainer:(BOOL)flag;

#pragma mark Specialization

@property (nonatomic, assign) Class windowClass;
@property (nonatomic, assign) Class navigationControllerClass;

@end

#pragma mark -

/*!
@protocol NKNavigatorDelegate <NSObject>
@abstract
*/
@protocol NKNavigatorDelegate <NSObject>

@optional
-(void) navigatorDidEnterBackground:(NKNavigator *)navigator;
-(void) navigatorWillEnterForeground:(NKNavigator *)navigator;

#pragma mark -

/*!
@abstract Notification that a navigator has loaded abd displayed a new view controller.
 */
-(void) navigator:(NKNavigator *)navigator didLoadController:(UIViewController *)controller;

-(void) navigator:(NKNavigator *)navigator didUnloadViewController:(UIViewController *)controller;

#pragma mark -

/*!
@abstract The URL is about to be opened in a controller. If the controller 
argument is nil, the URL is going to be opened externally.
*/
-(void) navigator:(NKNavigator *)navigator willOpenURL:(NSURL *)aURL inViewController:(UIViewController *)controller;

/*!
@abstract Asks if the URL should be opened and allows the delegate to prevent it.
*/
-(BOOL) navigator:(NKNavigator *)navigator shouldOpenURL:(NSURL *)aURL;

/*!
@abstract Asks if the URL with query should be opened and allows the delegate to prevent it.
*/
-(BOOL) navigator:(NKNavigator *)navigator shouldOpenURL:(NSURL *)URL withQuery:(NSDictionary *)query;

/*!
@abstract Asks if the URL should be opened and allows the delegate to return a different URL to open
instead. A return value of nil indicates the URL should not be opened.
@discussion This is a superset of the functionality of -navigator:shouldOpenURL:. Returning YES from that
method is equivalent to returning URL from this method.
*/
-(NSURL *) navigator:(NKNavigator *)navigator URLToOpen:(NSURL *)aURL;

@end

#pragma mark -

/*!
@abstract Shortcut for calling [[NKNavigator navigator] openURL:]
*/
UIViewController * 
NKNavigatorOpenURL(NSString *URL);

UIViewController * 
NKNavigatorOpenURLWithQuery(NSString *aURL, NSDictionary *aQuery, BOOL animatedFlag);
