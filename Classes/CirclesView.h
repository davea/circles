//
//  CirclesView.h
//  Circles
//
//  Created by Dave Arter on 25/04/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CirclesView : UIView <UIAccelerometerDelegate> {
	UIColor *fillColor;
	UIColor *strokeColor;
	CGPoint *centers;
	CGPoint touchCenter;
	NSInteger circleCount;
	NSMutableArray *accelerations;
}

@property (retain) UIColor *fillColor;
@property (retain) UIColor *strokeColor;

- (CGFloat)touchDistanceFrom:(CGPoint)touch;
- (CGPoint)randomPointWithinRect:(CGRect)rect;
- (void)resetColors;
- (void)loadCircles;
- (void)generateRandomCircles;
- (void)generateGridCircles;
- (void)setR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b;
@end
