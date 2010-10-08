
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

}
	@property (nonatomic, copy) NSString *message;
	@property (nonatomic, retain) NSMutableArray *URLs;
@end

#pragma mark -

@implementation NKAlertViewController

#pragma mark Initializers

-(id) init {
	return [self initWithTitle:nil message:nil delegate:nil];
}

-(id) initWithTitle:(NSString *)aTitle message:(NSString *)aMessage {
	return [self initWithTitle:aTitle message:aMessage delegate:nil];
}

-(id) initWithTitle:(NSString *)aTitle message:(NSString *)aMessage delegate:(id <NKAlertViewControllerDelegate>)aDelegate {
	self = [super init];
	if (!self) {
		return nil;
	}
	self.delegate = aDelegate;
	self.userInfo = nil;
	self.URLs = [[NSMutableArray alloc] init];
	self.title	= aTitle;
	self.message = aMessage;
	return self;
}


#pragma mark UIViewController

-(void) loadView {
	[super loadView];
	NKAlertView *av = [[[NKAlertView alloc] initWithTitle:self.title 
												  message:self.message  
												 delegate:self.delegate 
										cancelButtonTitle:nil
										otherButtonTitles:nil] autorelease];
	av.popupViewController = self;
	self.view = av;
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
	if (self.delegate && [self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
		[self.delegate alertView:anAlertView clickedButtonAtIndex:aButtonIndex];
	}
}

-(void) alertViewCancel:(UIAlertView *)anAlertView {
	if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewCancel:)]) {
		[self.delegate alertViewCancel:anAlertView];
	}
}

-(void) willPresentAlertView:(UIAlertView *)anAlertView {
	if (self.delegate && [self.delegate respondsToSelector:@selector(willPresentAlertView:)]) {
		[self.delegate willPresentAlertView:anAlertView];
	}
}

-(void) didPresentAlertView:(UIAlertView *)anAlertView {
	if (self.delegate && [self.delegate respondsToSelector:@selector(didPresentAlertView:)]) {
		[self.delegate didPresentAlertView:anAlertView];
	}
}

-(void) alertView:(UIAlertView *)anAlertView willDismissWithButtonIndex:(NSInteger)aButtonIndex {
	if (self.delegate && [self.delegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)]) {
		[self.delegate alertView:anAlertView willDismissWithButtonIndex:aButtonIndex];
	}
}

-(void) alertView:(UIAlertView *)anAlertView didDismissWithButtonIndex:(NSInteger)aButtonIndex {
	NSString *buttonURL	= [self buttonURLAtIndex:aButtonIndex];
	BOOL canOpenURL		= TRUE;
	if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewController:didDismissWithButtonIndex:URL:)]) {
		canOpenURL	= [self.delegate alertViewController:self didDismissWithButtonIndex:aButtonIndex URL:buttonURL];
	}
	if (buttonURL && canOpenURL) {
		NKNavigatorOpenURL(buttonURL);
	}
	if (self.delegate && [self.delegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)]) {
		[self.delegate alertView:anAlertView didDismissWithButtonIndex:aButtonIndex];
	}
}


#pragma mark API

-(UIAlertView *) alertView {
	return (UIAlertView *)self.view;
}

-(NSInteger) addButtonWithTitle:(NSString *)aTitle URL:(NSString *)aURL {
	if (aURL) {
		[self.URLs addObject:aURL];
	}
	else {
		[self.URLs addObject:[NSNull null]];
	}
	return [self.alertView addButtonWithTitle:aTitle];
}

-(NSInteger) addCancelButtonWithTitle:(NSString *)aTitle URL:(NSString *)aURL {
	self.alertView.cancelButtonIndex = [self addButtonWithTitle:aTitle URL:aURL];
	return self.alertView.cancelButtonIndex;
}

-(NSString *) buttonURLAtIndex:(NSInteger)anIndex {
	id URL = [self.URLs objectAtIndex:anIndex];
	return URL != [NSNull null] ? URL : nil;
}


#pragma mark Memory

-(void) dealloc {
	[(UIAlertView *)self.view setDelegate:nil];
	self.URLs = nil;
	self.userInfo = nil;
	[super dealloc];
}

@end
