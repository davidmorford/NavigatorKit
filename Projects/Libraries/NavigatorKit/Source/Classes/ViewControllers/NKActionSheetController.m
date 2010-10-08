
#import <NavigatorKit/NKActionSheetController.h>
#import <NavigatorKit/NKNavigator.h>
#import <NavigatorKit/NKUIDevice.h>

@interface NKActionSheet : UIActionSheet {
	UIViewController *popupViewController;
}

@property (nonatomic, retain) UIViewController *popupViewController;

@end

#pragma mark -

@implementation NKActionSheet

@synthesize popupViewController;

-(id) initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		popupViewController = nil;
	}
	return self;
}

-(void) didMoveToSuperview {
	if (!self.superview) {
		[popupViewController autorelease];
		popupViewController = nil;
	}
}

-(void) dealloc {
	[popupViewController release]; popupViewController = nil;
	[super dealloc];
}

@end

#pragma mark -

@interface NKActionSheetController () {
}
	@property (nonatomic, retain) NSMutableArray *URLs;
@end

#pragma mark -

@implementation NKActionSheetController

#pragma mark Initializers

-(id) init {
	return [self initWithTitle:nil delegate:nil];
}

-(id) initWithTitle:(NSString *)aTitle {
	return [self initWithTitle:aTitle delegate:nil];
}

-(id) initWithTitle:(NSString *)aTitle delegate:(id <NKActionSheetControllerDelegate> )aDelegate {
	if (self = [super init]) {
		self.delegate	= aDelegate;
		self.userInfo	= nil;
		self.URLs		= [[NSMutableArray alloc] init];
		self.title		= aTitle;
		/*if (aTitle) {
			self.actionSheet.title = aTitle;
		}*/
	}
	return self;
}


#pragma mark UIViewController

-(void) loadView {
	[super loadView];
	NKActionSheet *sheet = [[[NKActionSheet alloc] initWithTitle:nil 
														delegate:self
											   cancelButtonTitle:nil
										  destructiveButtonTitle:nil
											   otherButtonTitles:nil] autorelease];
	sheet.popupViewController = self;
	self.view = sheet;
}


#pragma mark NKPopupViewController

-(void) showInView:(UIView *)aView animated:(BOOL)animated {
	[self viewWillAppear:animated];
	if (NKUIDeviceUserIntefaceIdiom() == UIUserInterfaceIdiomPad) {
	
	}
	else {
		[self.actionSheet showInView:aView.window];
	}
	[self viewDidAppear:animated];
}

-(void) showInViewController:(UIViewController *)aParentViewController animated:(BOOL)animated {
	[self viewWillAppear:animated];
	if (NKUIDeviceUserIntefaceIdiom() == UIUserInterfaceIdiomPad) {
	
	}
	else {
		[self.actionSheet showInView:aParentViewController.view];
	}
	[self viewDidAppear:animated];
}

-(void) dismissPopupViewControllerAnimated:(BOOL)animated {
	[self viewWillDisappear:animated];
	[self.actionSheet dismissWithClickedButtonIndex:self.actionSheet.cancelButtonIndex animated:animated];
	[self viewDidDisappear:animated];
}


#pragma mark <UIActionSheetDelegate>

-(void) actionSheet:(UIActionSheet *)anActionSheet clickedButtonAtIndex:(NSInteger)aButtonIndex {
	if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
		[self.delegate actionSheet:anActionSheet clickedButtonAtIndex:aButtonIndex];
	}
}

-(void) actionSheetCancel:(UIActionSheet *)anActionSheet {
	if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheetCancel:)]) {
		[self.delegate actionSheetCancel:anActionSheet];
	}
}

-(void) willPresentActionSheet:(UIActionSheet *)anActionSheet {
	if (self.delegate && [self.delegate respondsToSelector:@selector(willPresentActionSheet:)]) {
		[self.delegate willPresentActionSheet:anActionSheet];
	}
}

-(void) didPresentActionSheet:(UIActionSheet *)anActionSheet {
	if (self.delegate && [self.delegate respondsToSelector:@selector(didPresentActionSheet:)]) {
		[self.delegate didPresentActionSheet:anActionSheet];
	}
}

-(void) actionSheet:(UIActionSheet *)aActionSheet willDismissWithButtonIndex:(NSInteger)aButtonIndex {
	if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:willDismissWithButtonIndex:)]) {
		[self.delegate actionSheet:aActionSheet willDismissWithButtonIndex:aButtonIndex];
	}
}

-(void) actionSheet:(UIActionSheet *)anActionSheet didDismissWithButtonIndex:(NSInteger)aButtonIndex {
	NSString *buttonURLString = [self buttonURLAtIndex:aButtonIndex];
	BOOL canOpenURL = TRUE;
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheetController:didDismissWithButtonIndex:URL:)]) {
		canOpenURL = [self.delegate actionSheetController:self 
							didDismissWithButtonIndex:aButtonIndex 
												  URL:buttonURLString];
	}
	
	if (buttonURLString && canOpenURL) {
		NKNavigatorOpenURL(buttonURLString);
	}
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:didDismissWithButtonIndex:)]) {
		[self.delegate actionSheet:anActionSheet didDismissWithButtonIndex:aButtonIndex];
	}
}


#pragma mark API

-(UIActionSheet *) actionSheet {
	return (UIActionSheet *)self.view;
}

-(NSInteger) addButtonWithTitle:(NSString *)aTitle URL:(NSString *)aURL {
	if (aURL) {
		[self.URLs addObject:aURL];
	}
	else {
		[self.URLs addObject:[NSNull null]];
	}
	return [self.actionSheet addButtonWithTitle:aTitle];
}

-(NSInteger) addCancelButtonWithTitle:(NSString *)aTitle URL:(NSString *)aURL {
	self.actionSheet.cancelButtonIndex = [self addButtonWithTitle:aTitle URL:aURL];
	return self.actionSheet.cancelButtonIndex;
}

-(NSInteger) addDestructiveButtonWithTitle:(NSString *)aTitle URL:(NSString *)aURL {
	self.actionSheet.destructiveButtonIndex = [self addButtonWithTitle:aTitle URL:aURL];
	return self.actionSheet.destructiveButtonIndex;
}

-(NSString *) buttonURLAtIndex:(NSInteger)anIndex {
	if (anIndex < self.URLs.count) {
		id URL = [self.URLs objectAtIndex:anIndex];
		return URL != [NSNull null] ? URL : nil;
	}
	else {
		return nil;
	}
}


#pragma mark -

-(void) dealloc {
	self.URLs = nil;
	self.userInfo = nil;
	[super dealloc];
}

@end
