//
//  PartidoCell.m
//  congreso
//
//  Created by Christian Roman on 24/03/13.
//  Copyright (c) 2013 Christian Roman. All rights reserved.
//

#import "PartidoCell.h"

@implementation PartidoCell

@synthesize title;
@synthesize picture;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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
    
    
    CGContextSetStrokeColorWithColor(currentContext, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(currentContext, 2);
    
    CGContextMoveToPoint(currentContext, 0, 0);
    CGContextAddLineToPoint(currentContext, rect.size.width, 0);
    CGContextSetShouldAntialias(currentContext, NO);
    CGContextStrokePath(currentContext);
    
    [super drawRect:rect];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animate
{
    UIColor * newShadow = highlighted ? [UIColor clearColor] : [UIColor whiteColor];
    
    self.title.shadowColor = newShadow;
    
    [super setHighlighted:highlighted animated:animate];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    UIColor * newShadow = selected ? [UIColor clearColor] : [UIColor whiteColor];
    
    self.title.shadowColor = newShadow;
    
    [super setSelected:selected animated:animated];
}

@end
