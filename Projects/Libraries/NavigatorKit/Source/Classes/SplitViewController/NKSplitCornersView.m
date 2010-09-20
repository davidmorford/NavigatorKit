
#import <NavigatorKit/NKSplitCornersView.h>

@interface NKSplitCornersView () {
	float cornerRadius;
	NKSplitViewController *splitViewController;
	NKCornersPosition cornersPosition;
	UIColor *cornerBackgroundColor;
}

@end

#pragma mark -

@implementation NKSplitCornersView

@synthesize cornerRadius;
@synthesize splitViewController;
@synthesize cornersPosition;
@synthesize cornerBackgroundColor;

#pragma mark Initializer

-(id) initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (!self) {
		return nil;
	}
	self.contentMode		= UIViewContentModeRedraw;
	self.userInteractionEnabled = NO;
	self.opaque				= NO;
	self.backgroundColor	= [UIColor clearColor];
	cornerRadius			= 0.0; // actual value is set by the splitViewController.
	cornersPosition			= NKCornersPositionLeadingVertical;
	return self;
}


#pragma mark Geometry

double
deg2Rad(double degrees) {
	return degrees * (M_PI / 180.0);
}

#pragma mark Drawing

/*!
@abstract Draw two appropriate corners, with cornerBackgroundColor behind them.
*/
-(void) drawRect:(CGRect)rect {
	if (cornerRadius > 0) {
		if (NO) {
			[[UIColor redColor] set];
			UIRectFill(self.bounds);
		}
		
		float maxX	= CGRectGetMaxX(self.bounds);
		float maxY	= CGRectGetMaxY(self.bounds);
		UIBezierPath *path = [UIBezierPath bezierPath];
		CGPoint pt	= CGPointZero;
		
		switch (cornersPosition) {
			// top of screen for a left/right split
			case NKCornersPositionLeadingVertical:
				[path moveToPoint:pt];
				pt.y += cornerRadius;
				[path appendPath:[UIBezierPath bezierPathWithArcCenter:pt radius:cornerRadius startAngle:deg2Rad(90) endAngle:0 clockwise:YES]];
				pt.x += cornerRadius;
				pt.y -= cornerRadius;
				[path addLineToPoint:pt];
				[path addLineToPoint:CGPointZero];
				[path closePath];
				
				pt.x = maxX - cornerRadius;
				pt.y = 0;
				[path moveToPoint:pt];
				pt.y = maxY;
				[path addLineToPoint:pt];
				pt.x += cornerRadius;
				[path appendPath:[UIBezierPath bezierPathWithArcCenter:pt radius:cornerRadius startAngle:deg2Rad(180) endAngle:deg2Rad(90) clockwise:YES]];
				pt.y -= cornerRadius;
				[path addLineToPoint:pt];
				pt.x -= cornerRadius;
				[path addLineToPoint:pt];
				[path closePath];
				break;
			
			// bottom of screen for a left/right split
			case NKCornersPositionTrailingVertical:
				pt.y = maxY;
				[path moveToPoint:pt];
				pt.y -= cornerRadius;
				[path appendPath:[UIBezierPath bezierPathWithArcCenter:pt radius:cornerRadius startAngle:deg2Rad(270) endAngle:deg2Rad(360) clockwise:NO]];
				pt.x += cornerRadius;
				pt.y += cornerRadius;
				[path addLineToPoint:pt];
				pt.x -= cornerRadius;
				[path addLineToPoint:pt];
				[path closePath];
				
				pt.x = maxX - cornerRadius;
				pt.y = maxY;
				[path moveToPoint:pt];
				pt.y -= cornerRadius;
				[path addLineToPoint:pt];
				pt.x += cornerRadius;
				[path appendPath:[UIBezierPath bezierPathWithArcCenter:pt radius:cornerRadius startAngle:deg2Rad(180) endAngle:deg2Rad(270) clockwise:NO]];
				pt.y += cornerRadius;
				[path addLineToPoint:pt];
				pt.x -= cornerRadius;
				[path addLineToPoint:pt];
				[path closePath];
				
				break;
			
			// left of screen for a top/bottom split
			case NKCornersPositionLeadingHorizontal:
				pt.x = 0;
				pt.y = cornerRadius;
				[path moveToPoint:pt];
				pt.y -= cornerRadius;
				[path addLineToPoint:pt];
				pt.x += cornerRadius;
				[path appendPath:[UIBezierPath bezierPathWithArcCenter:pt radius:cornerRadius startAngle:deg2Rad(180) endAngle:deg2Rad(270) clockwise:NO]];
				pt.y += cornerRadius;
				[path addLineToPoint:pt];
				pt.x -= cornerRadius;
				[path addLineToPoint:pt];
				[path closePath];
				
				pt.x = 0;
				pt.y = maxY - cornerRadius;
				[path moveToPoint:pt];
				pt.y = maxY;
				[path addLineToPoint:pt];
				pt.x += cornerRadius;
				[path appendPath:[UIBezierPath bezierPathWithArcCenter:pt radius:cornerRadius startAngle:deg2Rad(180) endAngle:deg2Rad(90) clockwise:YES]];
				pt.y -= cornerRadius;
				[path addLineToPoint:pt];
				pt.x -= cornerRadius;
				[path addLineToPoint:pt];
				[path closePath];
				
				break;
			
			// right of screen for a top/bottom split
			case NKCornersPositionTrailingHorizontal:
				pt.y = cornerRadius;
				[path moveToPoint:pt];
				pt.y -= cornerRadius;
				[path appendPath:[UIBezierPath bezierPathWithArcCenter:pt radius:cornerRadius startAngle:deg2Rad(270) endAngle:deg2Rad(360) clockwise:NO]];
				pt.x += cornerRadius;
				pt.y += cornerRadius;
				[path addLineToPoint:pt];
				pt.x -= cornerRadius;
				[path addLineToPoint:pt];
				[path closePath];
				
				pt.y = maxY - cornerRadius;
				[path moveToPoint:pt];
				pt.y += cornerRadius;
				[path appendPath:[UIBezierPath bezierPathWithArcCenter:pt radius:cornerRadius startAngle:deg2Rad(90) endAngle:0 clockwise:YES]];
				pt.x += cornerRadius;
				pt.y -= cornerRadius;
				[path addLineToPoint:pt];
				pt.x -= cornerRadius;
				[path addLineToPoint:pt];
				[path closePath];
				
				break;
				
			default:
				break;
		}
		
		[self.cornerBackgroundColor set];
		[path fill];
	}
}


#pragma mark -

-(void) setCornerRadius:(float)newRadius {
	if (newRadius != cornerRadius) {
		cornerRadius = newRadius;
		[self setNeedsDisplay];
	}
}

-(void) setSplitViewController:(NKSplitViewController *)theController {
	if (theController != splitViewController) {
		splitViewController = theController;
		[self setNeedsDisplay];
	}
}

-(void) setCornersPosition:(NKCornersPosition)posn {
	if (cornersPosition != posn) {
		cornersPosition = posn;
		[self setNeedsDisplay];
	}
}

-(void) setCornerBackgroundColor:(UIColor *)color {
	if (color != cornerBackgroundColor) {
		[cornerBackgroundColor release];
		cornerBackgroundColor = [color retain];
		[self setNeedsDisplay];
	}
}


#pragma mark -

-(void) dealloc {
	self.cornerBackgroundColor = nil;
	[super dealloc];
}

@end
