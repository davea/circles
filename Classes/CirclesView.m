//
//  CirclesView.m
//  Circles
//
//  Created by Dave Arter on 25/04/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CirclesView.h"

#define CIRCLECOUNT 1
#define MAXRADIUS 1920.0
#define CIRCLEALPHA 1.0
#define DISTANCEFACTOR 2.0

// Accelerometer config
#define FPS 1.0
#define CACHESIZE 1


@implementation CirclesView
@synthesize fillColor, strokeColor;

- (id)initWithFrame:(CGRect)frame {
	NSLog(@"initWithFrame");
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
	[self loadCircles];
	[self resetColors];
	
	touchCenter = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
	
	accelerations = [[NSMutableArray alloc] initWithCapacity:CACHESIZE];
//	[UIAccelerometer sharedAccelerometer].delegate = self;
//	[UIAccelerometer sharedAccelerometer].updateInterval = 1.0/FPS;
}

- (void)loadCircles
{
	[self generateRandomCircles];
//	[self generateGridCircles];
}

- (void)generateGridCircles
{
	NSUInteger cols = 4;
	NSUInteger rows = 10;
	circleCount = rows * cols;
	centers = (CGPoint *)malloc(circleCount*sizeof(CGPoint));
	
	NSUInteger i = 0;
	for (NSUInteger row=0; row<rows; row++) {
		for (NSUInteger col=0; col<cols; col++) {
			CGFloat x = (self.bounds.size.width/cols)*col;
			CGFloat y = (self.bounds.size.height/rows)*row;
			centers[i++] = CGPointMake(x, y);
		}
	}
}

- (void)generateRandomCircles
{
	circleCount = CIRCLECOUNT;
	centers = (CGPoint *)malloc(circleCount*sizeof(CGPoint));
	for (NSInteger i = 0; i<circleCount; i++) {
		//		CGFloat x = (self.bounds.size.width / circleCount) * i;
		//		CGFloat y = (self.bounds.size.height / circleCount) * i;
		centers[i] = [self randomPointWithinRect:[self bounds]];
	}
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	while ([accelerations count] >= CACHESIZE) {
		[accelerations removeObjectAtIndex:0];
	}
	
	[accelerations addObject:acceleration];
	
	CGFloat x, y, z;
	for(UIAcceleration *a in accelerations) {
		x += a.x;
		y += a.y;
		z += a.z;
	}
	x /= CACHESIZE;
	y /= CACHESIZE;
	z /= CACHESIZE;
	
	CGFloat b = MAX(0.25, MIN(1.0, x*2.0));
	CGFloat g = MAX(0.25, MIN(1.0, y*2.0));
	CGFloat r = MAX(0.25, MIN(1.0, z*-2.0));
	self.fillColor = [UIColor colorWithRed:r green:g blue:b alpha:CIRCLEALPHA];
	[self setNeedsDisplay];
}

- (void)setR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b
{
	self.fillColor = [UIColor colorWithRed:r green:g blue:b alpha:CIRCLEALPHA];
	[self setNeedsDisplay];
}

- (void)resetColors
{
	self.fillColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
	self.strokeColor = [UIColor greenColor];
}

- (CGPoint)randomPointWithinRect:(CGRect)rect
{
	CGFloat x = (CGFloat) (arc4random() % (NSUInteger) rect.size.width);
	CGFloat y = (CGFloat) (arc4random() % (NSUInteger) rect.size.height);
	return CGPointMake(x, y);
}


- (void)drawRect:(CGRect)rect {
	CGContextRef c = UIGraphicsGetCurrentContext();
	
	[fillColor setFill];
//	[strokeColor setStroke];
	
//	CGContextSetLineWidth(c, 5.0);
	for (NSInteger i=0; i<circleCount; i++) {
		CGPoint center = centers[i];
		CGFloat radius = [self touchDistanceFrom:center];
		CGContextBeginPath(c);
		CGContextAddArc(c, center.x, center.y, radius, 0.0, 2*M_PI, 1);
		CGContextClosePath(c);
		CGContextFillPath(c);
//		CGContextStrokePath(c);
	}
}

- (CGFloat)touchDistanceFrom:(CGPoint)touch
{
	CGFloat dx = touch.x - touchCenter.x;
	CGFloat dy = touch.y - touchCenter.y;
	return MIN(MAXRADIUS, sqrt(dx*dx + dy*dy)) * DISTANCEFACTOR;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//	self.fillColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:CIRCLEALPHA];
	touchCenter = [[touches anyObject] locationInView:self];
	[self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	touchCenter = [[touches anyObject] locationInView:self];
	[self setNeedsDisplay];
}

//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//	[self resetColors];
//	[self setNeedsDisplay];
//}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	
}



- (void)dealloc {
	self.fillColor = nil;
	self.strokeColor = nil;
	free(centers);
	[UIAccelerometer sharedAccelerometer].delegate = nil;
	[accelerations release];
    [super dealloc];
}


@end
