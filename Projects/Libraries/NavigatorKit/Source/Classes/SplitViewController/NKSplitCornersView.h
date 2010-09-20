
/*!
@project    NKSplitView
@header     NKSplitCornersView.h
@copyright	(c) 2010, Matt Gemmell
*/

#import <UIKit/UIKit.h>

typedef NSUInteger NKCornersPosition;

/*!
@enum 
@constant NKCornersPositionLeadingVertical		Top of screen for a left/right split.
@constant NKCornersPositionTrailingVertical		Bottom of screen for a left/right split.
@constant NKCornersPositionLeadingHorizontal	Left of screen for a top/bottom split.
@constant NKCornersPositionTrailingHorizontal	Right of screen for a top/bottom split.
*/
enum {
	NKCornersPositionLeadingVertical	= 0,
	NKCornersPositionTrailingVertical	= 1,
	NKCornersPositionLeadingHorizontal	= 2,
	NKCornersPositionTrailingHorizontal	= 3
};

@class NKSplitViewController;

/*!
@class NKSplitCornersView
@superclass UIView
@abstract
@discussion
*/
@interface NKSplitCornersView : UIView

@property (nonatomic, assign) float cornerRadius;
@property (nonatomic, assign) NKSplitViewController *splitViewController;

// don't change this manually; let the splitViewController manage it.
@property (nonatomic, assign) NKCornersPosition cornersPosition;
@property (nonatomic, retain) UIColor *cornerBackgroundColor;

@end

