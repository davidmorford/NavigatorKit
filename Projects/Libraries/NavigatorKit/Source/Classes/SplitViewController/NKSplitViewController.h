
/*!
@project    NavigatorKit
@header     NKSplitViewController.h
@copyright	(c) 2010, Matt Gemmell
*/

#import <UIKit/UIKit.h>

/*!
@abstract Enumeration of the split view sides.
*/
typedef NSUInteger NKSplitViewPosition;
enum {
	NKSplitViewMasterPosition	= 0,
	NKSplitViewDetailPosition	= 1
};

/*!
@enum 
@constant NKSplitViewDividerStyleThin			Thin divider, like UISplitViewController (default).
@constant NKSplitViewDividerStylePaneSplitter	Thick divider, drawn with a grey gradient and a grab-strip.
*/
typedef NSUInteger NKSplitViewDividerStyle;
enum  {
	NKSplitViewDividerStyleThin			= 0,
	NKSplitViewDividerStylePaneSplitter	= 1
};

@class NKSplitDividerView;
@protocol NKSplitViewControllerDelegate, NKSplitViewPopoverButtonDelegate;

/*!
@class NKSplitViewController
@superclass UIViewController
@abstract
@var _barButtonItem				To be compliant with wacky UISplitViewController behaviour.
@var _hiddenPopoverController	Popover used to hold the master view if it's not always visible.
@var _dividerView				View that draws the divider between the master and detail views.
@var _cornerViews				Views to draw the inner rounded corners between master and detail views.
@var _dividerStyle				Meta-setting which configures several aspects of appearance and behaviour.
*/
@interface NKSplitViewController : UIViewController

@property (nonatomic, assign) IBOutlet id <NKSplitViewControllerDelegate> delegate;

/*!
@abstract applies to both portrait orientations (default NO)
*/
@property (nonatomic, assign) BOOL showsMasterInPortrait;

/*!
@abstract applies to both landscape orientations (default YES)
*/
@property (nonatomic, assign) BOOL showsMasterInLandscape;

/*!
@abstract if NO, split is horizontal, i.e. master above detail (default YES)
*/
@property (nonatomic, assign, getter=isVertical) BOOL vertical;

/*!
@abstract if NO, master view is below/right of detail (default YES)
*/
@property (nonatomic, assign, getter=isMasterBeforeDetail) BOOL masterBeforeDetail;

/*!
@abstract starting position of split in pixels, relative to top/left (depending 
on .isVertical setting) if masterBeforeDetail is YES, else relative to bottom/right.
*/
@property (nonatomic, assign) float splitPosition;

/*!
@abstract width of split in pixels.
*/
@property (nonatomic, assign) float splitWidth;

/*!
@abstract whether to let the user drag the divider to alter the split position (default NO).	
*/
@property (nonatomic, assign) BOOL allowsDraggingDivider;

/*!
@abstract array of UIViewControllers; master is at index 0, detail is at index 1.
*/
@property (nonatomic, copy) NSArray *viewControllers;
@property (nonatomic, retain) IBOutlet UIViewController *masterViewController;
@property (nonatomic, retain) IBOutlet UIViewController *detailViewController;

/*!
@abstract The view which draws the divider/split between master and detail.
*/
@property (nonatomic, retain) NKSplitDividerView *dividerView;

/*!
@abstract style (and behaviour) of the divider between master and detail.
*/
@property (nonatomic, assign) NKSplitViewDividerStyle dividerStyle;

/*!
@abstract returns YES if this view controller is in either of the two Landscape orientations, else NO.
*/
@property (nonatomic, readonly, getter=isLandscape) BOOL landscape;


#pragma mark -

-(void) hideMasterView;

-(void) showMasterView;


#pragma mark Actions

/*!
@abstract toggles split axis between vertical (left/right; default) and horizontal (top/bottom).	
*/
-(IBAction) toggleSplitOrientation:(id)sender;

/*!
@abstract toggles position of master view relative to detail view.
*/
-(IBAction) toggleMasterBeforeDetail:(id)sender;

/*!
@abstract toggles display of the master view in the current orientation.
*/
-(IBAction) toggleMasterView:(id)sender;

/*!
@abstract shows the master view in a popover spawned from the provided barButtonItem, if it's currently hidden.
*/
-(IBAction) showMasterPopover:(id)sender;

/*!
@abstract should rarely be needed, because you should not change the popover's delegate. If you must, then call this when it's dismissed.
*/
-(void) notePopoverDismissed;

#pragma mark Conveniences (for you, because I care)

-(BOOL) isShowingMaster;

/*!
@abstract Allows for animation of splitPosition changes. The property's regular setter is not animated.
@discussion splitPosition is the width (in a left/right split, or height in a top/bottom split) of the master view.
It is relative to the appropriate side of the splitView, which can be any of the four sides depending on the 
values in isMasterBeforeDetail and isVertical:
	isVertical = YES, isMasterBeforeDetail = YES: splitPosition is relative to the LEFT edge. (Default)
	isVertical = YES, isMasterBeforeDetail = NO: splitPosition is relative to the RIGHT edge.
	isVertical = NO, isMasterBeforeDetail = YES: splitPosition is relative to the TOP edge.
	isVertical = NO, isMasterBeforeDetail = NO: splitPosition is relative to the BOTTOM edge.
This implementation was chosen so you don't need to recalculate equivalent splitPositions if the user 
toggles masterBeforeDetail themselves.
*/
-(void) setSplitPosition:(float)posn animated:(BOOL)animate;

/*!
@abstract Allows for animation of dividerStyle changes. The property's regular setter is not animated.
*/
-(void) setDividerStyle:(NKSplitViewDividerStyle)newStyle animated:(BOOL)animate;

/*!
@abstract Returns an NSArray of two NKSplitCornersView objects, used to draw the inner corners.
@discussion The first view is the "leading" corners (top edge of screen for left/right split, left 
edge of screen for top/bottom split). The second view is the "trailing" corners (bottom edge of screen 
for left/right split, right edge of screen for top/bottom split).
Do NOT modify them, except to: 1. Change their .cornerBackgroundColor 2. Change their .cornerRadius
*/
-(NSArray *) cornerViews;

@end

#pragma mark -

/*!
@protocol NKSplitViewControllerDelegate <NSObject>
@abstract
*/
@protocol NKSplitViewControllerDelegate <NSObject>

@optional

/*!
@abstract Called when a button should be added to a toolbar for a hidden view controller.
*/
-(void) splitViewController:(NKSplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc;

/*!
@abstract Called when the master view is shown again in the split view, invalidating the button and popover controller.
*/
-(void) splitViewController:(NKSplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem;

/*!
@abstract Called when the master view is shown in a popover, so the delegate can take action like hiding other popovers.
*/
-(void) splitViewController:(NKSplitViewController *)svc popoverController:(UIPopoverController *)pc willPresentViewController:(UIViewController *)aViewController;

/*!
@abstract If implemented, this barButtonItem will be used for the viewController
*/
-(UIBarButtonItem *) splitViewController:(NKSplitViewController *)svc  barButtonItemForViewController:(UIViewController *)aViewController;

/*!
@abstract Called when the split orientation will change (from vertical to horizontal, or vice versa).
*/
-(void) splitViewController:(NKSplitViewController *)svc willChangeSplitOrientationToVertical:(BOOL)isVertical;

/*!
@abstract Called when split position will change to the given pixel value (relative to left if split is vertical, or to top if horizontal).
*/
-(void) splitViewController:(NKSplitViewController *)svc willMoveSplitToPosition:(float)position;

/*!
@abstract Called before split position is changed to the given pixel value (relative to left if split is vertical, or to top if horizontal).
Note that viewSize is the current size of the entire split-view; i.e. the area enclosing the master, divider and detail views.
*/
-(float) splitViewController:(NKSplitViewController *)svc constrainSplitPosition:(float)proposedPosition splitViewSize:(CGSize)viewSize;

@end
