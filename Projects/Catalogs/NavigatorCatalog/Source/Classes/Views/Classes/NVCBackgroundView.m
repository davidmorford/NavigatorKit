
#import "NVCBackgroundView.h"
#import <CoreGraphics/CoreGraphics.h>

@interface UIImage (NVCImageDrawing)
	-(void) drawInRect:(CGRect)rect asAlphaMaskForColor:(CGFloat[])color;
	-(void) drawInRect:(CGRect)rect asAlphaMaskForGradient:(CGFloat[])colors;
@end

#pragma mark -

@implementation NVCBackgroundView
	
	#pragma mark Initializers

	-(id) initWithFrame:(CGRect)frame {
		self = [super initWithFrame:frame];
		if (!self) {
			return nil;
		}
		
		self.backgroundColor	= [UIColor whiteColor];
		
		self.title				= [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 10, 0)];
		self.title.font			= [UIFont boldSystemFontOfSize:18];
		self.title.adjustsFontSizeToFitWidth = YES;
		self.title.textColor = [UIColor grayColor];
		self.title.textAlignment = UITextAlignmentCenter;
		[self addSubview:self.title];
		
		CGRect titleFrame			= self.title.frame;
		titleFrame.size.height		= 22;
		titleFrame.origin.y			= self.frame.size.height / 2 + 90;
		self.title.frame	= titleFrame;
		
		return self;
	}

	#pragma mark -

	-(void) drawRect:(CGRect)rect {
		CGFloat color[] = {
			139 / 255.0, 152 / 255.0, 173 / 255.0, 1.0 
		};
		[self.imageMask drawInRect:CGRectMake((NSUInteger)self.bounds.size.width / 2 - self.imageMask.size.width / 2, (NSUInteger)self.bounds.size.height / 4, self.imageMask.size.width, self.imageMask.size.height) 
			   asAlphaMaskForColor:color];
		
		CGFloat colors[] = {
			171 / 255.0, 180 / 255.0, 196 / 255.0, 1.00,
			213 / 255.0, 217 / 255.0, 225 / 255.0, 1.00
		};
		[self.imageMask drawInRect:CGRectMake((NSUInteger)self.bounds.size.width / 2 - self.imageMask.size.width / 2, ((NSUInteger)self.bounds.size.height / 4), self.imageMask.size.width, self.imageMask.size.height) 
			asAlphaMaskForGradient:colors];
	}


	#pragma mark -

	-(void) dealloc {
		self.imageMask = nil;
		self.title = nil;
		[super dealloc];
	}

@end

#pragma mark -

@implementation UIImage (NVCImageDrawing)

	-(void) drawLinearGradientInRect:(CGRect)rect colors:(CGFloat[])colors {
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		CGContextSaveGState(context);
		CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
		CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, 2);
		CGColorSpaceRelease(rgb);
		CGPoint start, end;
		
		start = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height * 0.25);
		end = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height * 0.75);
		
		CGContextClipToRect(context, rect);
		CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
		
		CGGradientRelease(gradient);
		CGContextRestoreGState(context);	
	}

	-(void) drawInRect:(CGRect)rect asAlphaMaskForColor:(CGFloat[])color {
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		CGContextSaveGState(context);
		
		CGContextTranslateCTM(context, 0.0, rect.size.height);
		CGContextScaleCTM(context, 1.0, -1.0);
		
		rect.origin.y = rect.origin.y * -1;
		
		CGContextClipToMask(context, rect, self.CGImage);
		CGContextSetRGBFillColor(context, color[0], color[1], color[2], color[3]);
		CGContextFillRect(context, rect);

		CGContextRestoreGState(context);
	}

	-(void) drawInRect:(CGRect)rect asAlphaMaskForGradient:(CGFloat[])colors {
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		CGContextSaveGState(context);
		
		CGContextTranslateCTM(context, 0.0, rect.size.height);
		CGContextScaleCTM(context, 1.0, -1.0);
		
		rect.origin.y = rect.origin.y * -1;
		
		CGContextClipToMask(context, rect, self.CGImage);
		[self drawLinearGradientInRect:rect colors:colors];

		CGContextRestoreGState(context);	
	}

@end
