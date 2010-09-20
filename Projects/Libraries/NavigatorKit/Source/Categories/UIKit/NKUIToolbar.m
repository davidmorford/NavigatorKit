
#import <NavigatorKit/NKUIToolbar.h>

@implementation UIToolbar (NKToolbar)

-(UIBarButtonItem *) itemWithTag:(NSInteger)aTag {
	for (UIBarButtonItem *button in self.items) {
		if (button.tag == aTag) {
			return button;
		}
	}
	return nil;
}

-(void) replaceItemWithTag:(NSInteger)aTag withItem:(UIBarButtonItem *)anItem {
	NSInteger index = 0;
	for (UIBarButtonItem *button in self.items) {
		if (button.tag == aTag) {
			NSMutableArray *newItems = [NSMutableArray arrayWithArray:self.items];
			[newItems replaceObjectAtIndex:index withObject:anItem];
			self.items = newItems;
			break;
		}
		++index;
	}	
}

-(void) replaceItem:(UIBarButtonItem *)oldItem withItem:(UIBarButtonItem *)newItem {
	NSMutableArray *newItems = [self.items mutableCopy];
	if ([newItems containsObject:oldItem] == FALSE) {
		[newItems release];
		return;
	}
	[newItems replaceObjectAtIndex:[newItems indexOfObject:oldItem] withObject:newItem];
	self.items = newItems;
}

@end
