
#import <NavigatorKit/NKAlertViewController.h>
#import <NavigatorKit/NKNavigator.h>

@interface NKAlertView : UIAlertView {
	UIViewController *popupViewController;
}

@property (nonatomic, retain) UIViewController *popupViewController;

@end

@implementation NKAlertView

@synthesize popupViewController;

-(id) initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		popupViewController = nil;
	}
	return self;
}

#pragma mark -

-(void) didMoveToSuperview {
	if (!self.superview) {
		[popupViewController autorelease];
		popupViewController = nil;
	}
}

#pragma mark -

-(void) dealloc {
	[popupViewController release]; popupViewController = nil;
	[super dealloc];
}

@end

#pragma mark -

@interface NKAlertViewController () {
	id <NKAlertViewControllerDelegate> delegate;
	id userInfo;
	NSMutableArray *URLs;
}
@end

#pragma mark -

@implementation NKAlertViewController

@synthesize delegate;
@synthesize userInfo;

#pragma mark Initializers

-(id) init {
	return [self initWithTitle:nil message:nil delegate:nil];
}

-(id) initWithTitle:(NSString *)aTitle message:(NSString *)aMessage delegate:(id)aDelegate {
	if (self = [super init]) {
		delegate				= aDelegate;
		userInfo				= nil;
		URLs					= [[NSMutableArray alloc] init];
		if (aTitle) {
			self.alertView.title	= aTitle;
		}
		if (aMessage) {
			self.alertView.message	= aMessage;
		}
	}
	return self;
}

-(id) initWithTitle:(NSString *)aTitle message:(NSString *)aMessage {
	return [self initWithTitle:aTitle message:aMessage delegate:nil];
}


#pragma mark UIViewController

-(void) loadView {
	NKAlertView *alertView = [[[NKAlertView alloc] initWithTitle:nil 
															 message:nil 
															delegate:self
												   cancelButtonTitle:nil
												   otherButtonTitles:nil] autorelease];
	alertView.popupViewController = self;
	self.view = alertView;
}


#pragma mark NKPopupViewController

-(void) showInView:(UIView *)aView animated:(BOOL)animated {
	[self viewWillAppear:animated];
	[self.alertView show];
	[self viewDidAppear:animated];
}

-(void) dismissPopupViewControllerAnimated:(BOOL)animated {
	[self viewWillDisappear:animated];
	[self.alertView dismissWithClickedButtonIndex:self.alertView.cancelButtonIndex animated:animated];
	[self viewDidDisappear:animated];
}


#pragma mark <UIAlertViewDelegate>

-(void) alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)aButtonIndex {
	if ([delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
		[delegate alertView:anAlertView clickedButtonAtIndex:aButtonIndex];
	}
}

-(void) alertViewCancel:(UIAlertView *)anAlertView {
	if ([delegate respondsToSelector:@selector(alertViewCancel:)]) {
		[delegate alertViewCancel:anAlertView];
	}
}

-(void) willPresentAlertView:(UIAlertView *)anAlertView {
	if ([delegate respondsToSelector:@selector(willPresentAlertView:)]) {
		[delegate willPresentAlertView:anAlertView];
	}
}

-(void) didPresentAlertView:(UIAlertView *)anAlertView {
	if ([delegate respondsToSelector:@selector(didPresentAlertView:)]) {
		[delegate didPresentAlertView:anAlertView];
	}
}

-(void) alertView:(UIAlertView *)anAlertView willDismissWithButtonIndex:(NSInteger)aButtonIndex {
	if ([delegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)]) {
		[delegate alertView:anAlertView willDismissWithButtonIndex:aButtonIndex];
	}
}

-(void) alertView:(UIAlertView *)anAlertView didDismissWithButtonIndex:(NSInteger)aButtonIndex {
	NSString *buttonURL	= [self buttonURLAtIndex:aButtonIndex];
	BOOL canOpenURL		= TRUE;
	if ([delegate respondsToSelector:@selector(alertViewController:didDismissWithButtonIndex:URL:)]) {
		canOpenURL	= [delegate alertViewController:self didDismissWithButtonIndex:aButtonIndex URL:buttonURL];
	}
	if (buttonURL && canOpenURL) {
		NKNavigatorOpenURL(buttonURL);
	}
	if ([delegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)]) {
		[delegate alertView:anAlertView didDismissWithButtonIndex:aButtonIndex];
	}
}


#pragma mark API

-(UIAlertView *) alertView {
	return (UIAlertView *)self.view;
}

-(NSInteger) addButtonWithTitle:(NSString *)aTitle URL:(NSString *)aURL {
	if (aURL) {
		[URLs addObject:aURL];
	}
	else {
		[URLs addObject:[NSNull null]];
	}
	return [self.alertView addButtonWithTitle:aTitle];
}

-(NSInteger) addCancelButtonWithTitle:(NSString *)aTitle URL:(NSString *)aURL {
	self.alertView.cancelButtonIndex = [self addButtonWithTitle:aTitle URL:aURL];
	return self.alertView.cancelButtonIndex;
}

-(NSString *) buttonURLAtIndex:(NSInteger)anIndex {
	id URL = [URLs objectAtIndex:anIndex];
	return URL != [NSNull null] ? URL : nil;
}


#pragma mark Memory

-(void) dealloc {
	[(UIAlertView *)self.view setDelegate:nil];
	[URLs release]; URLs = nil;
	[userInfo release]; userInfo = nil;
	[super dealloc];
}

@end
