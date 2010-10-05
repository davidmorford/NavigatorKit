
#import <NavigatorKit/NKSplitViewController.h>
#import <NavigatorKit/NKSplitDividerView.h>
#import <NavigatorKit/NKSplitCornersView.h>
#import <NavigatorKit/NKSplitViewNavigator.h>

/*!
@abstract default width of master view in UISplitViewController.
*/
#define NK_DEFAULT_SPLIT_POSITION		320.0

/*!
@abstract default width of split-gutter in UISplitViewController.
*/
#define NK_DEFAULT_SPLIT_WIDTH			1.0

/*!
@abstract default corner-radius of overlapping split-inner corners on the master and detail views.
*/
#define NK_DEFAULT_CORNER_RADIUS		5.0

/*!
@abstract default color of intruding inner corners (and divider background).
*/
#define NK_DEFAULT_CORNER_COLOR			[UIColor blackColor]

/*!
@abstract corner-radius of split-inner corners for NKSplitViewDividerStylePaneSplitter style.
*/
#define NK_PANESPLITTER_CORNER_RADIUS	0.0

/*!
@abstract width of split-gutter for NKSplitViewDividerStylePaneSplitter style.
*/
#define NK_PANESPLITTER_SPLIT_WIDTH		25.0

/*!
@abstract minimum width a view is allowed to become as a result of changing the splitPosition.
*/
#define NK_MIN_VIEW_WIDTH				200.0

/*!
@abstract Animation ID for internal use.
*/
static NSString* NK_ANIMATION_CHANGE_SPLIT_ORIENTATION = @"ChangeSplitOrientation";
static NSString* NK_ANIMATION_CHANGE_SUBVIEWS_ORDER	   = @"ChangeSubviewsOrder";

#pragma mark -

@interface NKSplitViewController () <UIPopoverControllerDelegate> {
	id <NKSplitViewControllerDelegate> _delegate;
	NSMutableArray *_viewControllers;
	NSArray *_cornerViews;
	float _splitPosition;
	float _splitWidth;
	BOOL _showsMasterInPortrait;
	BOOL _showsMasterInLandscape;
	BOOL _vertical;
	BOOL _masterBeforeDetail;
	BOOL _reconfigurePopup;
	NKSplitDividerView *_dividerView;
	NKSplitViewDividerStyle _dividerStyle;
    UIPopoverController *_hiddenPopoverController;
	UIBarButtonItem *_barButtonItem;
}
@property (nonatomic, assign) BOOL orientationChangeHidesPopover;

-(CGSize) splitViewSizeForOrientation:(UIInterfaceOrientation)theOrientation;
-(void) layoutSubviews;
-(void) layoutSubviewsWithAnimation:(BOOL)animate;
-(void) layoutSubviewsForInterfaceOrientation:(UIInterfaceOrientation)theOrientation withAnimation:(BOOL)animate;
-(BOOL) shouldShowMasterForInterfaceOrientation:(UIInterfaceOrientation)theOrientation;
-(BOOL) shouldShowMaster;
-(NSString *) nameOfInterfaceOrientation:(UIInterfaceOrientation)theOrientation;
-(void) reconfigureForMasterInPopover:(BOOL)inPopover;
@end

#pragma mark -

@implementation NKSplitViewController

@synthesize showsMasterInPortrait;
@synthesize showsMasterInLandscape;
@synthesize vertical;
@synthesize delegate;
@synthesize viewControllers;
@synthesize masterViewController;
@synthesize detailViewController;
@synthesize dividerView;
@synthesize splitPosition;
@synthesize splitWidth;
@synthesize allowsDraggingDivider;
@synthesize dividerStyle;


#pragma mark -

-(id) init {
	self = [super initWithNibName:nil bundle:nil];
	if (!self) {
		return nil;
	}
	// Configure default behaviour.
	_viewControllers		= [[NSMutableArray alloc] initWithObjects:[NSNull null], [NSNull null], nil];
	_splitWidth				= NK_DEFAULT_SPLIT_WIDTH;
	_showsMasterInPortrait	= NO;
	_showsMasterInLandscape = YES;
	_reconfigurePopup		= NO;
	_vertical				= YES;
	_masterBeforeDetail		= YES;
	_splitPosition			= NK_DEFAULT_SPLIT_POSITION;
	CGRect divRect			= self.view.bounds;
	if ([self isVertical]) {
		divRect.origin.y	= _splitPosition;
		divRect.size.height = _splitWidth;
	}
	else {
		divRect.origin.x	= _splitPosition;
		divRect.size.width	= _splitWidth;
	}
	_dividerView						= [[NKSplitDividerView alloc] initWithFrame:divRect];
	_dividerView.splitViewController	= self;
	_dividerView.backgroundColor		= NK_DEFAULT_CORNER_COLOR;
	_dividerStyle						= NKSplitViewDividerStyleThin;
	self.orientationChangeHidesPopover	= NO;
	return self;
}


#pragma mark UIViewController

-(void) loadView {
	[super loadView];
}

-(void) viewDidLoad {
	[super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if ([self isShowingMaster]) {
		[self.masterViewController viewWillAppear:animated];
	}
	[self.detailViewController viewWillAppear:animated];
	_reconfigurePopup = YES;
	[self layoutSubviews];
}

-(void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	if ([self isShowingMaster]) {
		[self.masterViewController viewDidAppear:animated];
	}
	[self.detailViewController viewDidAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	if ([self isShowingMaster]) {
		[self.masterViewController viewWillDisappear:animated];
	}
	[self.detailViewController viewWillDisappear:animated];
}

-(void) viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	if ([self isShowingMaster]) {
		[self.masterViewController viewDidDisappear:animated];
	}
	[self.detailViewController viewDidDisappear:animated];
}


#pragma mark NKUIViewController

-(BOOL) canContainControllers {
	return TRUE;
}


#pragma mark View Management

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.masterViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	[self.detailViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self.masterViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	[self.detailViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.masterViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	[self.detailViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	// Hide popover.
	if (_hiddenPopoverController && _hiddenPopoverController.popoverVisible/* && self.orientationChangeHidesPopover*/) {
		[_hiddenPopoverController dismissPopoverAnimated:NO];
	}
	
	// Re-tile views.
	_reconfigurePopup = YES;
	[self layoutSubviewsForInterfaceOrientation:toInterfaceOrientation withAnimation:YES];
}

-(void) willAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.masterViewController willAnimateFirstHalfOfRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	[self.detailViewController willAnimateFirstHalfOfRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

-(void) didAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	[self.masterViewController didAnimateFirstHalfOfRotationToInterfaceOrientation:toInterfaceOrientation];
	[self.detailViewController didAnimateFirstHalfOfRotationToInterfaceOrientation:toInterfaceOrientation];
}

-(void) willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.masterViewController willAnimateSecondHalfOfRotationFromInterfaceOrientation:fromInterfaceOrientation duration:duration];
	[self.detailViewController willAnimateSecondHalfOfRotationFromInterfaceOrientation:fromInterfaceOrientation duration:duration];
}

-(CGSize) splitViewSizeForOrientation:(UIInterfaceOrientation)theOrientation {
	UIScreen *screen		= [UIScreen mainScreen];
	CGRect fullScreenRect	= screen.bounds; // always implicitly in Portrait orientation.
	CGRect appFrame			= screen.applicationFrame;
	
	// Find status bar height by checking which dimension of the applicationFrame is narrower than screen bounds.
	// Little bit ugly looking, but it'll still work even if they change the status bar height in future.
	float statusBarHeight = MAX((fullScreenRect.size.width - appFrame.size.width), (fullScreenRect.size.height - appFrame.size.height));
	
	// Initially assume portrait orientation.
	float width		= fullScreenRect.size.width;
	float height	= fullScreenRect.size.height;
	
	// Correct for orientation.
	if (UIInterfaceOrientationIsLandscape(theOrientation)) {
		width	= height;
		height	= fullScreenRect.size.width;
	}
	
	// Account for status bar, which always subtracts from the height (since it's always at the top of the screen).
	height -= statusBarHeight;
	
	return CGSizeMake(width, height);
}


#pragma mark -

-(void) layoutSubviewsForInterfaceOrientation:(UIInterfaceOrientation)theOrientation withAnimation:(BOOL)animate {
	if (_reconfigurePopup) {
		[self reconfigureForMasterInPopover:![self shouldShowMasterForInterfaceOrientation:theOrientation]];
	}
	
	// Layout the master, detail and divider views appropriately, adding/removing subviews as needed.
	// First obtain relevant geometry.
	CGSize fullSize = [self splitViewSizeForOrientation:theOrientation];
	float width		= fullSize.width;
	float height	= fullSize.height;
	
	if (NO) {
		NSLog(@"Target orientation is %@, dimensions will be %.0f x %.0f", [self nameOfInterfaceOrientation:theOrientation], width, height);
	}
	
	// Layout the master, divider and detail views.
	CGRect newFrame = CGRectMake(0, 0, width, height);
	UIViewController *controller;
	UIView *theView;
	BOOL shouldShowMaster	= [self shouldShowMasterForInterfaceOrientation:theOrientation];
	BOOL masterFirst		= [self isMasterBeforeDetail];
	if ([self isVertical]) {
		// Master on left, detail on right (or vice versa).
		CGRect masterRect, dividerRect, detailRect;
		if (masterFirst) {
			if (!shouldShowMaster) {
				// Move off-screen.
				newFrame.origin.x -= (_splitPosition + _splitWidth);
			}
			
			newFrame.size.width = _splitPosition;
			masterRect			= newFrame;
			
			newFrame.origin.x	+= newFrame.size.width;
			newFrame.size.width = _splitWidth;
			dividerRect			= newFrame;
			
			newFrame.origin.x	+= newFrame.size.width;
			newFrame.size.width = width - newFrame.origin.x;
			detailRect			= newFrame;
		}
		else {
			if (!shouldShowMaster) {
				// Move off-screen.
				newFrame.size.width += (_splitPosition + _splitWidth);
			}
			
			newFrame.size.width -= (_splitPosition + _splitWidth);
			detailRect			= newFrame;
			
			newFrame.origin.x	+= newFrame.size.width;
			newFrame.size.width = _splitWidth;
			dividerRect			= newFrame;
			
			newFrame.origin.x	+= newFrame.size.width;
			newFrame.size.width = _splitPosition;
			masterRect			= newFrame;
		}
		
		// Position master.
		controller = self.masterViewController;
		if (controller && [controller isKindOfClass:[UIViewController class]]) {
			theView = controller.view;
			if (theView) {
				theView.frame = masterRect;
				if (!theView.superview) {
					[controller viewWillAppear:NO];
					[self.view addSubview:theView];
					[controller viewDidAppear:NO];
				}
			}
		}
		
		// Position divider.
		theView = _dividerView;
		theView.frame = dividerRect;
		if (!theView.superview) {
			[self.view addSubview:theView];
		}
		
		// Position detail.
		controller = self.detailViewController;
		if (controller && [controller isKindOfClass:[UIViewController class]]) {
			theView = controller.view;
			if (theView) {
				theView.frame = detailRect;
				if (!theView.superview) {
					[self.view insertSubview:theView aboveSubview:self.masterViewController.view];
				}
				else {
					[self.view bringSubviewToFront:theView];
				}
			}
		}
	}
	else {
		// Master above, detail below (or vice versa).
		CGRect masterRect, dividerRect, detailRect;
		if (masterFirst) {
			if (!shouldShowMaster) {
				// Move off-screen.
				newFrame.origin.y -= (_splitPosition + _splitWidth);
			}
			
			newFrame.size.height	= _splitPosition;
			masterRect				= newFrame;
			
			newFrame.origin.y		+= newFrame.size.height;
			newFrame.size.height	= _splitWidth;
			dividerRect				= newFrame;
			
			newFrame.origin.y		+= newFrame.size.height;
			newFrame.size.height	= height - newFrame.origin.y;
			detailRect				= newFrame;
		}
		else {
			if (!shouldShowMaster) {
				// Move off-screen.
				newFrame.size.height += (_splitPosition + _splitWidth);
			}
			
			newFrame.size.height	-= (_splitPosition + _splitWidth);
			detailRect				= newFrame;
			
			newFrame.origin.y		+= newFrame.size.height;
			newFrame.size.height	= _splitWidth;
			dividerRect				= newFrame;
			
			newFrame.origin.y		+= newFrame.size.height;
			newFrame.size.height	= _splitPosition;
			masterRect				= newFrame;
		}
		
		// Position master.
		controller = self.masterViewController;
		if (controller && [controller isKindOfClass:[UIViewController class]]) {
			theView = controller.view;
			if (theView) {
				theView.frame = masterRect;
				if (!theView.superview) {
					[controller viewWillAppear:NO];
					[self.view addSubview:theView];
					[controller viewDidAppear:NO];
				}
			}
		}
		
		// Position divider.
		theView			= _dividerView;
		theView.frame	= dividerRect;
		if (!theView.superview) {
			[self.view addSubview:theView];
		}
		
		// Position detail.
		controller = self.detailViewController;
		if (controller && [controller isKindOfClass:[UIViewController class]]) {
			theView = controller.view;
			if (theView) {
				theView.frame = detailRect;
				if (!theView.superview) {
					[self.view insertSubview:theView aboveSubview:self.masterViewController.view];
				}
				else {
					[self.view bringSubviewToFront:theView];
				}
			}
		}
	}
	
	// Create corner views if necessary.
	
	// top/left of screen in vertical/horizontal split.
	NKSplitCornersView *leadingCorners = nil;
	
	// bottom/right of screen in vertical/horizontal split.
	NKSplitCornersView *trailingCorners = nil;
	if (!_cornerViews) {
		// arbitrary, will be resized below.
		CGRect cornerRect						= CGRectMake(0, 0, 10, 10);
		leadingCorners							= [[NKSplitCornersView alloc] initWithFrame:cornerRect];
		leadingCorners.splitViewController		= self;
		leadingCorners.cornerBackgroundColor	= NK_DEFAULT_CORNER_COLOR;
		leadingCorners.cornerRadius				= NK_DEFAULT_CORNER_RADIUS;
		trailingCorners							= [[NKSplitCornersView alloc] initWithFrame:cornerRect];
		trailingCorners.splitViewController		= self;
		trailingCorners.cornerBackgroundColor	= NK_DEFAULT_CORNER_COLOR;
		trailingCorners.cornerRadius			= NK_DEFAULT_CORNER_RADIUS;
		_cornerViews = [[NSArray alloc] initWithObjects:leadingCorners, trailingCorners, nil];
		[leadingCorners release];
		[trailingCorners release];
	}
	else if ([_cornerViews count] == 2) {
		leadingCorners	= [_cornerViews objectAtIndex:0];
		trailingCorners = [_cornerViews objectAtIndex:1];
	}
	
	// Configure and layout the corner-views.
	leadingCorners.cornersPosition		= (_vertical) ? NKCornersPositionLeadingVertical : NKCornersPositionLeadingHorizontal;
	trailingCorners.cornersPosition		= (_vertical) ? NKCornersPositionTrailingVertical : NKCornersPositionTrailingHorizontal;
	leadingCorners.autoresizingMask		= (_vertical) ? UIViewAutoresizingFlexibleBottomMargin : UIViewAutoresizingFlexibleRightMargin;
	trailingCorners.autoresizingMask	= (_vertical) ? UIViewAutoresizingFlexibleTopMargin : UIViewAutoresizingFlexibleLeftMargin;
	
	float x, y, cornersWidth, cornersHeight;
	CGRect leadingRect, trailingRect;
	float radius = leadingCorners.cornerRadius;
	
	// left/right split
	if (_vertical) {
		cornersWidth	= (radius * 2.0) + _splitWidth;
		cornersHeight	= radius;
		x				= ((shouldShowMaster) ? ((masterFirst) ? _splitPosition : width - (_splitPosition + _splitWidth)) : (0 - _splitWidth)) - radius;
		y				= 0;
		leadingRect		= CGRectMake(x, y, cornersWidth, cornersHeight); // top corners
		trailingRect	= CGRectMake(x, (height - cornersHeight), cornersWidth, cornersHeight); // bottom corners
	}
	else {
		// top/bottom split
		x				= 0;
		y				= ((shouldShowMaster) ? ((masterFirst) ? _splitPosition : height - (_splitPosition + _splitWidth)) : (0 - _splitWidth)) - radius;
		cornersWidth	= radius;
		cornersHeight	= (radius * 2.0) + _splitWidth;
		leadingRect		= CGRectMake(x, y, cornersWidth, cornersHeight); // left corners
		trailingRect	= CGRectMake((width - cornersWidth), y, cornersWidth, cornersHeight); // right corners
	}
	
	leadingCorners.frame = leadingRect;
	trailingCorners.frame = trailingRect;
	
	// Ensure corners are visible and frontmost.
	if (!leadingCorners.superview) {
		[self.view insertSubview:leadingCorners aboveSubview:self.detailViewController.view];
		[self.view insertSubview:trailingCorners aboveSubview:self.detailViewController.view];
	}
	else {
		[self.view bringSubviewToFront:leadingCorners];
		[self.view bringSubviewToFront:trailingCorners];
	}
}

-(void) layoutSubviewsWithAnimation:(BOOL)animate {
	[self layoutSubviewsForInterfaceOrientation:self.interfaceOrientation withAnimation:animate];
}

-(void) layoutSubviews {
	[self layoutSubviewsForInterfaceOrientation:self.interfaceOrientation withAnimation:YES];
}


#pragma mark Orientation

-(NSString *) nameOfInterfaceOrientation:(UIInterfaceOrientation)theOrientation {
	NSString *orientationName = nil;
	switch (theOrientation) {
		case UIInterfaceOrientationPortrait:
			// Home button at bottom
			orientationName = @"Portrait";
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
			// Home button at top
			orientationName = @"Portrait (Upside Down)";
			break;
		case UIInterfaceOrientationLandscapeLeft:
			// Home button on left
			orientationName = @"Landscape (Left)";
			break;
		case UIInterfaceOrientationLandscapeRight:
			// Home button on right
			orientationName = @"Landscape (Right)";
			break;
		default:
			break;
	}
	return orientationName;
}

-(BOOL) isLandscape {
	return UIInterfaceOrientationIsLandscape(self.interfaceOrientation);
}

/*!
@abstract Returns YES if master view should be shown directly embedded in the splitview, instead of hidden in a popover.
*/
-(BOOL) shouldShowMasterForInterfaceOrientation:(UIInterfaceOrientation)theOrientation {
	return ((UIInterfaceOrientationIsLandscape(theOrientation)) ? _showsMasterInLandscape : _showsMasterInPortrait);
}

-(BOOL) shouldShowMaster {
	return [self shouldShowMasterForInterfaceOrientation:self.interfaceOrientation];
}

-(BOOL) isShowingMaster {
	return [self shouldShowMaster] && self.masterViewController && self.masterViewController.view && ([self.masterViewController.view superview] == self.view);
}


#pragma mark Popover

-(void) reconfigureForMasterInPopover:(BOOL)inPopover {
	_reconfigurePopup = NO;
	if ((inPopover && _hiddenPopoverController) || (!inPopover && !_hiddenPopoverController) || !self.masterViewController) {
		return;
	}
	
	if (inPopover && !_hiddenPopoverController && !_barButtonItem) {
		// Create and configure popover for our masterViewController.
		[_hiddenPopoverController release];
		_hiddenPopoverController = nil;
		[self.masterViewController viewWillDisappear:NO];
		_hiddenPopoverController = [[UIPopoverController alloc] initWithContentViewController:self.masterViewController];
		[self.masterViewController viewDidDisappear:NO];
		
		
		// Create and configure _barButtonItem.
		if (_delegate && [_delegate respondsToSelector:@selector(splitViewController:barButtonItemForViewController:)]) {
			_barButtonItem = [_delegate splitViewController:self barButtonItemForViewController:self.masterViewController];
			if (![_barButtonItem.target respondsToSelector:_barButtonItem.action]) {
				_barButtonItem.target = self;
				_barButtonItem.action = @selector(showMasterPopover:);
			}
		}
		else {
			_barButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Master", nil)
															  style:UIBarButtonItemStyleBordered
															 target:self
															 action:@selector(showMasterPopover:)];
		}

		// Inform delegate of this state of affairs.
		if (_delegate && [_delegate respondsToSelector:@selector(splitViewController:willHideViewController:withBarButtonItem:forPopoverController:)]) {
			[_delegate splitViewController:self willHideViewController:self.masterViewController withBarButtonItem:_barButtonItem forPopoverController:_hiddenPopoverController];
		}
	}
	else if (!inPopover && _hiddenPopoverController && _barButtonItem) {
		// I know this looks strange, but it fixes a bizarre issue with UIPopoverController leaving masterViewController's views in disarray.
		[_hiddenPopoverController presentPopoverFromRect:CGRectZero inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
		
		// Remove master from popover and destroy popover, if it exists.
		[_hiddenPopoverController dismissPopoverAnimated:NO];
		[_hiddenPopoverController release];
		_hiddenPopoverController = nil;
		
		// Inform delegate that the _barButtonItem will become invalid.
		if (_delegate && [_delegate respondsToSelector:@selector(splitViewController:willShowViewController:invalidatingBarButtonItem:)]) {
			[_delegate splitViewController:self willShowViewController:self.masterViewController invalidatingBarButtonItem:_barButtonItem];
		}
		
		// Destroy _barButtonItem.
		[_barButtonItem release];
		_barButtonItem = nil;
		
		// Move master view.
		UIView *masterView = self.masterViewController.view;
		if (masterView && (masterView.superview != self.view)) {
			[masterView removeFromSuperview];
		}
	}
}

-(void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
	[self reconfigureForMasterInPopover:NO];
}

-(void) notePopoverDismissed {
	[self popoverControllerDidDismissPopover:_hiddenPopoverController];
}


#pragma mark Animations

-(void) animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	if (([animationID isEqualToString:NK_ANIMATION_CHANGE_SPLIT_ORIENTATION] || [animationID isEqualToString:NK_ANIMATION_CHANGE_SUBVIEWS_ORDER]) && _cornerViews) {
		for (UIView *corner in _cornerViews) {
			corner.hidden = NO;
		}
		_dividerView.hidden = NO;
	}
}


#pragma mark Actions

-(IBAction) toggleSplitOrientation:(id)sender {
	BOOL showingMaster = [self isShowingMaster];
	if (showingMaster) {
		if (_cornerViews) {
			for (UIView *corner in _cornerViews) {
				corner.hidden = YES;
			}
			_dividerView.hidden = YES;
		}
		[UIView beginAnimations:NK_ANIMATION_CHANGE_SPLIT_ORIENTATION context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	}
	self.vertical = (!self.vertical);
	if (showingMaster) {
		[UIView commitAnimations];
	}
}

-(IBAction) toggleMasterBeforeDetail:(id)sender {
	BOOL showingMaster = [self isShowingMaster];
	if (showingMaster) {
		if (_cornerViews) {
			for (UIView *corner in _cornerViews) {
				corner.hidden = YES;
			}
			_dividerView.hidden = YES;
		}
		[UIView beginAnimations:NK_ANIMATION_CHANGE_SUBVIEWS_ORDER context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	}
	self.masterBeforeDetail = (!self.masterBeforeDetail);
	if (showingMaster) {
		[UIView commitAnimations];
	}
}

-(IBAction) toggleMasterView:(id)sender {
	if (_hiddenPopoverController && _hiddenPopoverController.popoverVisible) {
		[_hiddenPopoverController dismissPopoverAnimated:NO];
	}
	
	if (![self isShowingMaster]) {
		// We're about to show the master view. Ensure it's in place off-screen to be animated in.
		_reconfigurePopup = YES;
		[self reconfigureForMasterInPopover:NO];
		[self layoutSubviews];
	}
	
	// This action functions on the current primary orientation; it is independent of the other primary orientation.
	[UIView beginAnimations:@"toggleMaster" context:nil];
	if (self.isLandscape) {
		self.showsMasterInLandscape = !_showsMasterInLandscape;
	}
	else {
		self.showsMasterInPortrait = !_showsMasterInPortrait;
	}
	[UIView commitAnimations];
}


-(IBAction) showMasterPopover:(id)sender {
	if (_hiddenPopoverController && !(_hiddenPopoverController.popoverVisible)) {
		// Inform delegate.
		if (_delegate && [_delegate respondsToSelector:@selector(splitViewController:popoverController:willPresentViewController:)]) {
			[_delegate splitViewController:self popoverController:_hiddenPopoverController willPresentViewController:self.masterViewController];
		}
		// Show popover.
		[_hiddenPopoverController presentPopoverFromBarButtonItem:_barButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
	else {
		[_hiddenPopoverController dismissPopoverAnimated:YES];
	}
}

#pragma mark -

/*!
@abstract ensure the master is either shown or hidden. Assumes no portrait split.
*/
-(void) hideMasterView {
	if (_hiddenPopoverController && _hiddenPopoverController.popoverVisible) {
		[_hiddenPopoverController dismissPopoverAnimated:YES];
	}
	
	if (![self isShowingMaster]) {
		self.showsMasterInLandscape = NO;
		return;
	}
	
	// This action functions on the current primary orientation; it is independent of the other primary orientation.
	[UIView beginAnimations:@"toggleMaster" context:nil];
	self.showsMasterInLandscape = NO;
	[UIView commitAnimations];
}

-(void) showMasterView {
	if (_hiddenPopoverController && _hiddenPopoverController.popoverVisible) {
		[_hiddenPopoverController dismissPopoverAnimated:NO];
	}
	
	if ([self isShowingMaster]) {
		return;
	}
	else {
		// We're about to show the master view. Ensure it's in place off-screen to be animated in.
		_reconfigurePopup = YES;
		[self reconfigureForMasterInPopover:NO];
		[self layoutSubviews];
	}
	
	// This action functions on the current primary orientation; it is independent of the other primary orientation.
	_showsMasterInLandscape = YES;
	
	if (![self isLandscape]) { // i.e. if this will cause a visual change.
		if (_hiddenPopoverController && _hiddenPopoverController.popoverVisible) {
			[_hiddenPopoverController dismissPopoverAnimated:NO];
		}
	}
	// Rearrange views.
	if (self.isLandscape) {
		[UIView beginAnimations:@"toggleMaster" context:nil];
	}
	
	_reconfigurePopup = YES;
	[self layoutSubviews];
	
	if (self.isLandscape) {
		[UIView commitAnimations];
	}
}

#pragma mark Accessors

-(id) delegate {
	return _delegate;
}

-(void) setDelegate:(id <NKSplitViewControllerDelegate>)newDelegate {
	if ((newDelegate != _delegate) && (!newDelegate || [(NSObject *)newDelegate conformsToProtocol:@protocol(NKSplitViewControllerDelegate)])) {
		_delegate = newDelegate;
	}
}


-(BOOL) showsMasterInPortrait {
	return _showsMasterInPortrait;
}

-(void) setShowsMasterInPortrait:(BOOL)flag {
	if (flag != _showsMasterInPortrait) {
		_showsMasterInPortrait = flag;
		
		// i.e. if this will cause a visual change.
		if (![self isLandscape]) {
			if (_hiddenPopoverController && _hiddenPopoverController.popoverVisible) {
				[_hiddenPopoverController dismissPopoverAnimated:NO];
			}
			
			// Rearrange views.
			_reconfigurePopup = YES;
			[self layoutSubviews];
		}
	}
}


-(BOOL) showsMasterInLandscape {
	return _showsMasterInLandscape;
}

-(void) setShowsMasterInLandscape:(BOOL)flag {
	if (flag != _showsMasterInLandscape) {
		_showsMasterInLandscape = flag;
		
		if ([self isLandscape]) { // i.e. if this will cause a visual change.
			if (_hiddenPopoverController && _hiddenPopoverController.popoverVisible) {
				[_hiddenPopoverController dismissPopoverAnimated:NO];
			}
			
			// Rearrange views.
			_reconfigurePopup = YES;
			[self layoutSubviews];
		}
	}
}


-(BOOL) isVertical {
	return _vertical;
}

-(void) setVertical:(BOOL)flag {
	if (flag != _vertical) {
		if (_hiddenPopoverController && _hiddenPopoverController.popoverVisible) {
			[_hiddenPopoverController dismissPopoverAnimated:NO];
		}
		
		_vertical = flag;
		
		// Inform delegate.
		if (_delegate && [_delegate respondsToSelector:@selector(splitViewController:willChangeSplitOrientationToVertical:)]) {
			[_delegate splitViewController:self willChangeSplitOrientationToVertical:_vertical];
		}
		[self layoutSubviews];
	}
}


-(BOOL) isMasterBeforeDetail {
	return _masterBeforeDetail;
}

-(void) setMasterBeforeDetail:(BOOL)flag {
	if (flag != _masterBeforeDetail) {
		if (_hiddenPopoverController && _hiddenPopoverController.popoverVisible) {
			[_hiddenPopoverController dismissPopoverAnimated:NO];
		}
		
		_masterBeforeDetail = flag;
		
		if ([self isShowingMaster]) {
			[self layoutSubviews];
		}
	}
}


-(float) splitPosition {
	return _splitPosition;
}

-(void) setSplitPosition:(float)posn {
	// Check to see if delegate wishes to constrain the position.
	float newPosn		= posn;
	BOOL constrained	= NO;
	CGSize fullSize		= [self splitViewSizeForOrientation:self.interfaceOrientation];
	if (_delegate && [_delegate respondsToSelector:@selector(splitViewController:constrainSplitPosition:splitViewSize:)]) {
		newPosn		= [_delegate splitViewController:self constrainSplitPosition:newPosn splitViewSize:fullSize];
		// implicitly trust delegate's response.
		constrained = YES;
	}
	else {
		// Apply default constraints if delegate doesn't wish to participate.
		float minPos	= NK_MIN_VIEW_WIDTH;
		float maxPos	= ((_vertical) ? fullSize.width : fullSize.height) - (NK_MIN_VIEW_WIDTH + _splitWidth);
		constrained		= (newPosn != _splitPosition && newPosn >= minPos && newPosn <= maxPos);
	}
	
	if (constrained) {
		if (_hiddenPopoverController && _hiddenPopoverController.popoverVisible) {
			[_hiddenPopoverController dismissPopoverAnimated:NO];
		}
		
		_splitPosition = newPosn;
		
		// Inform delegate.
		if (_delegate && [_delegate respondsToSelector:@selector(splitViewController:willMoveSplitToPosition:)]) {
			[_delegate splitViewController:self willMoveSplitToPosition:_splitPosition];
		}
		
		if ([self isShowingMaster]) {
			[self layoutSubviews];
		}
	}
}

-(void) setSplitPosition:(float)posn animated:(BOOL)animate {
	BOOL shouldAnimate = (animate && [self isShowingMaster]);
	if (shouldAnimate) {
		[UIView beginAnimations:@"SplitPosition" context:nil];
	}
	[self setSplitPosition:posn];
	if (shouldAnimate) {
		[UIView commitAnimations];
	}
}


-(float) splitWidth {
	return _splitWidth;
}

-(void) setSplitWidth:(float)width {
	if ((width != _splitWidth) && (width >= 0)) {
		_splitWidth = width;
		if ([self isShowingMaster]) {
			[self layoutSubviews];
		}
	}
}


-(NSArray *) viewControllers {
	return [[_viewControllers copy] autorelease];
}

-(void) setViewControllers:(NSArray *)controllers {
	if (controllers != _viewControllers) {
		for (UIViewController *controller in _viewControllers) {
			if ([controller isKindOfClass:[UIViewController class]]) {
				[controller.view removeFromSuperview];
			}
		}
		[_viewControllers release];
		_viewControllers = [[NSMutableArray alloc] initWithCapacity:2];
		if (controllers && ([controllers count] >= 2)) {
			self.masterViewController = [controllers objectAtIndex:0];
			self.detailViewController = [controllers objectAtIndex:1];
		}
		else {
			NSLog(@"Error: %@ requires 2 view-controllers. (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
		}
		[self layoutSubviews];
	}
}


-(UIViewController *) masterViewController {
	if (_viewControllers && ([_viewControllers count] > 0)) {
		NSObject *controller = [_viewControllers objectAtIndex:0];
		if ([controller isKindOfClass:[UIViewController class]]) {
			return [[controller retain] autorelease];
		}
	}
	
	return nil;
}

-(void) setMasterViewController:(UIViewController *)master {
	if (!_viewControllers) {
		_viewControllers = [[NSMutableArray alloc] initWithCapacity:2];
	}
	
	NSObject *newMaster = master;
	if (!newMaster) {
		newMaster = [NSNull null];
	}
	
	BOOL changed = YES;
	if ([_viewControllers count] > 0) {
		if ([_viewControllers objectAtIndex:0] == newMaster) {
			changed = NO;
		}
		else {
			[_viewControllers replaceObjectAtIndex:0 withObject:newMaster];
		}
	}
	else {
		[_viewControllers addObject:newMaster];
	}
	
	if (changed) {
		[self layoutSubviews];
	}
}


-(UIViewController *) detailViewController {
	if (_viewControllers && ([_viewControllers count] > 1)) {
		NSObject *controller = [_viewControllers objectAtIndex:1];
		if ([controller isKindOfClass:[UIViewController class]]) {
			return [[controller retain] autorelease];
		}
	}
	return nil;
}

-(void) setDetailViewController:(UIViewController *)detail {
	if (!_viewControllers) {
		_viewControllers = [[NSMutableArray alloc] initWithCapacity:2];
		[_viewControllers addObject:[NSNull null]];
	}
	
	BOOL changed = YES;
	if ([_viewControllers count] > 1) {
		if ([_viewControllers objectAtIndex:1] == detail) {
			changed = NO;
		}
		else {
			[_viewControllers replaceObjectAtIndex:1 withObject:detail];
		}
	}
	else {
		[_viewControllers addObject:detail];
		_reconfigurePopup = YES;
	}
	
	if (changed) {
		[self layoutSubviews];
	}
}


-(NKSplitDividerView *) dividerView {
	return [[_dividerView retain] autorelease];
}

-(void) setDividerView:(NKSplitDividerView *)divider {
	if (divider != _dividerView) {
		[_dividerView removeFromSuperview];
		[_dividerView release];
		_dividerView = [divider retain];
		_dividerView.splitViewController = self;
		_dividerView.backgroundColor = NK_DEFAULT_CORNER_COLOR;
		if ([self isShowingMaster]) {
			[self layoutSubviews];
		}
	}
}


-(BOOL) allowsDraggingDivider {
	if (_dividerView) {
		return _dividerView.allowsDragging;
	}
	return NO;
}

-(void) setAllowsDraggingDivider:(BOOL)flag {
	if ((self.allowsDraggingDivider != flag) && _dividerView) {
		_dividerView.allowsDragging = flag;
	}
}


-(NKSplitViewDividerStyle) dividerStyle {
	return _dividerStyle;
}

-(void) setDividerStyle:(NKSplitViewDividerStyle)newStyle {
	if (_hiddenPopoverController && _hiddenPopoverController.popoverVisible) {
		[_hiddenPopoverController dismissPopoverAnimated:NO];
	}
	
	// We don't check to see if newStyle equals _dividerStyle, because it's a meta-setting.
	// Aspects could have been changed since it was set.
	_dividerStyle = newStyle;
	
	// Reconfigure general appearance and behaviour.
	float cornerRadius = NK_DEFAULT_CORNER_RADIUS;
	if (_dividerStyle == NKSplitViewDividerStyleThin) {
		cornerRadius	= NK_DEFAULT_CORNER_RADIUS;
		_splitWidth		= NK_DEFAULT_SPLIT_WIDTH;
		self.allowsDraggingDivider = NO;
	}
	else if (_dividerStyle == NKSplitViewDividerStylePaneSplitter) {
		cornerRadius	= NK_PANESPLITTER_CORNER_RADIUS;
		_splitWidth		= NK_PANESPLITTER_SPLIT_WIDTH;
		self.allowsDraggingDivider = YES;
	}
	
	// Update divider and corners.
	[_dividerView setNeedsDisplay];
	if (_cornerViews) {
		for (NKSplitCornersView *corner in _cornerViews) {
			corner.cornerRadius = cornerRadius;
		}
	}
	
	// Layout all views.
	[self layoutSubviews];
}

-(void) setDividerStyle:(NKSplitViewDividerStyle)newStyle animated:(BOOL)animate {
	BOOL shouldAnimate = (animate && [self isShowingMaster]);
	if (shouldAnimate) {
		[UIView beginAnimations:@"DividerStyle" context:nil];
	}
	[self setDividerStyle:newStyle];
	if (shouldAnimate) {
		[UIView commitAnimations];
	}
}

-(NSArray *) cornerViews {
	if (_cornerViews) {
		return [[_cornerViews retain] autorelease];
	}
	return nil;
}


#pragma mark -

-(void) dealloc {
	_delegate = nil;
	[self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	[_viewControllers release];
	[_barButtonItem release];
	[_hiddenPopoverController release];
	[_dividerView release];
	[_cornerViews release];
	[super dealloc];
}

@end
