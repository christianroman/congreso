//
//  GradientView.m
//  Top Apps
//
//  Created by Christian Roman on 22/12/12.
//  Copyright (c) 2012 Christian Roman. All rights reserved.
//

#import "GradientView.h"

#define UIColorFromRGB(rgbValue)[UIColor colorWithRed:((float)((rgbValue&0xFF0000)>>16))/255.0 green:((float)((rgbValue&0xFF00)>>8))/255.0 blue:((float)(rgbValue&0xFF))/255.0 alpha:1.0]

@implementation GradientView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    /* Gradient */
    CGGradientRef glossGradient;
    CGColorSpaceRef rgbColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {
        241/255.0f, 244/255.0f, 245/255.0f, 1,
        229/255.0f, 233/255.0f, 235/255.0f, 1 };
    
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
    
    CGRect currentBounds = self.bounds;
    CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
    CGPoint midCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMaxY(currentBounds));
    CGContextDrawLinearGradient(currentContext, glossGradient, topCenter, midCenter, 0);
    
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace);
    
    // top border
    
    CGContextSetStrokeColorWithColor(currentContext, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(currentContext, 2);
    
    CGContextMoveToPoint(currentContext, 0, 0);
    CGContextAddLineToPoint(currentContext, rect.size.width, 0);
    CGContextSetShouldAntialias(currentContext, NO);
    CGContextStrokePath(currentContext);
    
    // bottom border
    
    CGContextSetStrokeColorWithColor(currentContext, UIColorFromRGB(0xb6c0c8).CGColor);
    CGContextSetLineWidth(currentContext, 2);
    
    CGContextMoveToPoint(currentContext, 0, rect.size.height);
    CGContextAddLineToPoint(currentContext, rect.size.width, rect.size.height);
    CGContextSetShouldAntialias(currentContext, NO);
    CGContextStrokePath(currentContext);
    
    [super drawRect:rect];
}


@end
