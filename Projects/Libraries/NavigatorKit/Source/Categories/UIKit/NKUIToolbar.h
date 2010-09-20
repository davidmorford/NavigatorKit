
/*!
@project	NavigatorKit
@header     NKUIToolbar.h
@changes	(c) 2009-2010, Dave Morford
*/

#import <UIKit/UIKit.h>

/*!
@category UIToolbar (NKToolbar)
@abstract
@discussion
*/
@interface UIToolbar (NKToolbar)

-(UIBarButtonItem *) itemWithTag:(NSInteger)aTag;

-(void) replaceItemWithTag:(NSInteger)tag withItem:(UIBarButtonItem *)anItem;

-(void) replaceItem:(UIBarButtonItem *)oldItem withItem:(UIBarButtonItem *)newItem;

@end
