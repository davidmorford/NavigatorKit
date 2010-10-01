
/*!
@project    NavigatorKit
@header     NKNavigatorAction.h
@copyright  (c) 2010, Three20
@copyright  (c) 2010, Dave Morford
*/

#import <UIKit/UIKit.h>

/*!
@class NKNavigatorAction
@abstract Used strictly in NKNavigator, this object bundles up a set of parameters and ships them off
to NKNavigator's openURLAction method. This object is designed with the chaining principle in
mind. Once you've created a NKNavigatorAction object, you can apply any other property to the object
via the apply* methods. Each of these methods returns self, allowing you to chain them.
@discussion For the default values, see the apply method documentation below.
@example Create an autoreleased URL action object with the path @"appscheme://some/path" that is animated.
[[NKNavigatorAction actionWithURLPath:@"appscheme://some/path"] applyAnimated:YES];
*/
@interface NKNavigatorAction : NSObject <NSCopying>
	
@property (nonatomic, copy) NSString *URLPath;
@property (nonatomic, copy) NSString *parentURLPath;
@property (nonatomic, retain) NSDictionary *query;

@property (nonatomic, retain) id sender;
@property (nonatomic, assign) BOOL animated;
@property (nonatomic, assign) BOOL withDelay;
@property (nonatomic, assign) UIViewAnimationTransition transition;
@property (nonatomic, assign) UIModalPresentationStyle modalPresentationStyle;

#pragma mark -

/*!
@abstract Create an autoreleased NKNavigatorAction object with a URL path. The path is required.
*/
+(id) actionWithNavigatorURLPath:(NSString *)aURLPath;

#pragma mark Initializers

/*!
@abstract Initialize a NKNavigatorAction object with a URL path. The path is required.
*/
-(id) initWithNavigatorURLPath:(NSString *)aURLPath;
-(id) initWithNavigatorURLPath:(NSString *)aURLPath query:(NSDictionary *)aQuery;
-(id) initWithNavigatorURLPath:(NSString *)aURLPath animated:(BOOL)animatedFlag;
-(id) initWithNavigatorURLPath:(NSString *)aURLPath parentURLPath:(NSString *)aParentPath;
-(id) initWithNavigatorURLPath:(NSString *)aURLPath parentURLPath:(NSString *)aParentPath query:(NSDictionary *)aQuery;

@end
