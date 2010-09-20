
/*!
@project    NKSplitView
@header     NKSplitDividerView.h
@copyright	(c) 2010, Matt Gemmell
*/

#import <UIKit/UIKit.h>

@class NKSplitViewController;

/*!
@class NKSplitDividerView
@superclass UIView
@abstract
@discussion
*/
@interface NKSplitDividerView : UIView

@property (nonatomic, assign) NKSplitViewController *splitViewController;
@property (nonatomic, assign) BOOL allowsDragging;

-(void) drawGripThumbInRect:(CGRect)rect;

@end
