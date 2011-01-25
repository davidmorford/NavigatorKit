
/*!
@project	NavigatorKit
@header     UIToolbar+NKItems.h
@changes	(c) 2009 - 2011, Dave Morford
*/

#import <UIKit/UIKit.h>

/*!
@category UIToolbar (NKItems)
@abstract
@discussion
*/
@interface UIToolbar (NKItems)

-(UIBarButtonItem *) itemWithTag:(NSInteger)aTag;

-(void) replaceItemWithTag:(NSInteger)aTag withItem:(UIBarButtonItem *)anItem;

-(void) replaceItem:(UIBarButtonItem *)anItem withItem:(UIBarButtonItem *)aNewItem;

@end
