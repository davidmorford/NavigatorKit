
/*!
@project    NavigatorKit
@header     NKUISplitViewNavigator.h
@changes    (c) 2010, Dave Morford
*/

#import <UIKit/UIKit.h>
#import <NavigatorKit/NKNavigator.h>
#import <NavigatorKit/NKSplitViewNavigator.h>

/*!
@class NKUISplitViewNavigator
@superclass NKNavigator <NKUISplitViewControllerDelegate, UIPopoverControllerDelegate>
@abstract
@discussion
*/
@interface NKUISplitViewNavigator : NKNavigator <UISplitViewControllerDelegate, UIPopoverControllerDelegate>

+(NKUISplitViewNavigator *) UISplitViewNavigator;

#pragma mark SplitView

@property (nonatomic, readonly) UISplitViewController *splitViewController;

-(void) setViewControllersWithNavigationURLs:(NSArray *)aURLArray;

#pragma mark Popover

@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) UIBarButtonItem *masterPopoverButtonItem;
@property (nonatomic, retain) NSString *masterPopoverButtonTitle;

#pragma mark Navigators

@property (nonatomic, retain) NSArray *navigators;

@property (nonatomic, readonly) NKNavigator *masterNavigator;
@property (nonatomic, readonly) NKNavigator *detailNavigator;

-(NKNavigator *) navigatorAtIndex:(NKSplitNavigatorPosition)index;
	
@end
