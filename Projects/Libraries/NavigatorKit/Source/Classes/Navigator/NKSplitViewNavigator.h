
/*!
@project    NavigatorKit
@header     NKSplitViewNavigator.h
@changes    (c) 2010, Dave Morford
*/

#import <UIKit/UIKit.h>
#import <NavigatorKit/NKNavigator.h>
#import <NavigatorKit/NKSplitViewController.h>

typedef NSUInteger NKSplitNavigatorPosition;
enum {
	NKSplitViewMasterNavigator	= 0,
	NKSplitViewDetailNavigator	= 1
};

/*!
@class NKSplitViewNavigator
@superclass NKNavigator <NKSplitViewControllerDelegate, UIPopoverControllerDelegate>
@abstract
@discussion
*/
@interface NKSplitViewNavigator : NKNavigator <NKSplitViewControllerDelegate, UIPopoverControllerDelegate>
	
+(NKSplitViewNavigator *) splitViewNavigator;	

#pragma mark SplitView

@property (nonatomic, readonly) NKSplitViewController *splitViewController;

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
