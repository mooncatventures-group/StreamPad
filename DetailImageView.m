#import "DetaiImageView.h"




@implementation DetailImageView


- (id)initWithFrame:(CGRect)frame andText:(NSString *)txt {
	if (self = [super initWithFrame:frame]) {
		self.opaque = NO;
	}
	text = [txt copy];
	return self;
}


- (void)drawRect:(CGRect)rect {
	self.alpha = .75;
	
		
	
	
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGFloat radius = 15;
	CGFloat minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect);
	CGFloat miny = CGRectGetMinY(rect), midy = floor(CGRectGetMidY(rect)), maxy = CGRectGetMaxY(rect);
	
	CGMutablePathRef clipPath = CGPathCreateMutable();
	// start at mid left
	CGPathMoveToPoint(clipPath, NULL, minx, midy);
	// add upper left arc
	CGPathAddArcToPoint(clipPath, NULL, minx, miny, midx, miny, radius);
	// add upper right arc
	CGPathAddArcToPoint(clipPath, NULL, maxx, miny, maxx, midy, radius);
	// add lower right arc
	CGPathAddArcToPoint(clipPath, NULL, maxx, maxy, midx, maxy, radius);
	// add lower left arc
	CGPathAddArcToPoint(clipPath, NULL, minx, maxy, minx, midy, radius);
	// close path
	CGPathCloseSubpath(clipPath);
	// add path to context
	CGContextAddPath(context, clipPath);
	
	CGContextSaveGState(context);
	CGContextClip(context);
	CGPathRelease(clipPath);
	
	CGContextSetRGBFillColor(context, 0, 0, 0, 1);
	UIRectFill(CGRectMake(minx, miny, rect.size.width, rect.size.height));
	
	CGContextRestoreGState(context);
	//	[aiv release];
	
}


-(void)quitClicked {
}


-(void)rwClicked {
	
  	
}

-(void)ffClicked {
	
	  	
}



- (void)playPauseToggled:(UIButton*)button {
	
	
	 	
}



- (void)dealloc {
	[super dealloc];
}


@end
