//
//  KBDetailDisclosureButton.m
//  PickyBird
//
//  Created by Karl Bode on 22.07.12.
//  Copyright (c) 2012 hot coffee apps - Karl Bode und Jonas Panten GbR. All rights reserved.
//

#import "KPBDetailDisclosureButton.h"
#import <QuartzCore/QuartzCore.h>

CGFloat const DetailDisclosureDim = 30.f;

@implementation KPBDetailDisclosureButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tintColor = [UIColor colorWithRed:0.769 green:0.314 blue:0.294 alpha:1];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.tintColor = [UIColor colorWithRed:0.769 green:0.314 blue:0.294 alpha:1];
    }
    return self;
}

- (void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    [self setupImages];
}

- (void)setupImages
{
    
    UIImage *normalImage = [self drawImageHighlighted:NO];
    
    [self setImage:normalImage forState:UIControlStateNormal];
    
    UIImage *hightlightedImage = [self drawImageHighlighted:YES];
    
    [self setImage:hightlightedImage forState:UIControlStateHighlighted];
}

- (UIImage *)drawImageHighlighted:(BOOL)highlighted
{
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self drawImageToContext:ctx inRect:self.bounds highlighted:highlighted];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)drawImageToContext:(CGContextRef)ctx inRect:(CGRect)rect highlighted:(BOOL)highlighted
{
    
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    
    // draw background with shadow
    
    CGRect disclosureFrame = CGRectMake((width - DetailDisclosureDim) / 2.f, (height - DetailDisclosureDim) / 2.f, DetailDisclosureDim, DetailDisclosureDim);
    
    disclosureFrame = CGRectInset(disclosureFrame, 3.f, 3.f);
        
    UIBezierPath *disclosureBackgroundPath = [UIBezierPath bezierPathWithOvalInRect:disclosureFrame];
    
    UIColor *color = self.tintColor;
    if (color == nil) {
        color = [UIColor colorWithRed:0.769 green:0.314 blue:0.294 alpha:1];
    }
    
    [color setFill];
    
    CGContextSaveGState(ctx);
    
    CGContextSetShadowWithColor(ctx, CGSizeMake(0.f, 1.f), 3.f, [[[UIColor darkGrayColor] colorWithAlphaComponent:1.f] CGColor]);
    
    [disclosureBackgroundPath fill];
    
    CGContextRestoreGState(ctx);
    
    
    if (highlighted) {
        
        CGContextSaveGState(ctx);
        
        [[[UIColor blackColor] colorWithAlphaComponent:.4f] setFill];
        
        [disclosureBackgroundPath fill];
        
        CGContextRestoreGState(ctx);
        
    }
    
    [disclosureBackgroundPath addClip];
    
    UIBezierPath *glarePath = [UIBezierPath bezierPath];
    [glarePath moveToPoint:CGPointZero];
    [glarePath addLineToPoint:CGPointMake(0.f, CGRectGetHeight(disclosureFrame) / 2.f + 1.f)];
    [glarePath addQuadCurveToPoint:CGPointMake(CGRectGetWidth(disclosureFrame), CGRectGetHeight(disclosureFrame) / 2.f + 1.f) controlPoint:CGPointMake(CGRectGetWidth(disclosureFrame) / 2.f, CGRectGetHeight(disclosureFrame) / 2.f - 5.f)];
    [glarePath addLineToPoint:CGPointMake(CGRectGetWidth(disclosureFrame), 0.f)];
    [glarePath closePath];
    
    CGContextSaveGState(ctx);
    
    CGContextTranslateCTM(ctx, disclosureFrame.origin.x, disclosureFrame.origin.y);
    
    [[[UIColor whiteColor] colorWithAlphaComponent:.3f] setFill];
    
    [glarePath fill];
    
    CGContextRestoreGState(ctx);
    
    [[UIColor whiteColor] setStroke];
    
    UIBezierPath *disclosureBorderPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(disclosureFrame, 1.f, 1.f)];
    disclosureBorderPath.lineWidth = 3.f;
    
    [disclosureBorderPath stroke];
    
    CGFloat accessoryDim = CGRectGetHeight(disclosureFrame) / 5.5f;
    
    UIBezierPath *accessoryPath = [UIBezierPath bezierPath];
    [accessoryPath moveToPoint:CGPointMake(1.f, 0.f)];
    [accessoryPath addLineToPoint:CGPointMake(accessoryDim + 1.f, accessoryDim)];
    [accessoryPath addLineToPoint:CGPointMake(1.f, accessoryDim + accessoryDim)];
    accessoryPath.lineCapStyle = kCGLineCapSquare;
    accessoryPath.lineWidth = 3.f;
    
    CGContextSaveGState(ctx);
    
    CGPoint accessoryOffset = CGPointMake((CGRectGetWidth(disclosureFrame) - accessoryDim) / 2.f, (CGRectGetHeight(disclosureFrame) - accessoryDim - accessoryDim) / 2.f);
    
    CGContextTranslateCTM(ctx, CGRectGetMinX(disclosureFrame), CGRectGetMinY(disclosureFrame));
    CGContextTranslateCTM(ctx, accessoryOffset.x, accessoryOffset.y);
    
    
    CGContextSetShadowWithColor(ctx, CGSizeMake(.25f, -.25f), 1.f, [[[UIColor blackColor] colorWithAlphaComponent:.7f] CGColor]);
    
    [[UIColor whiteColor] setStroke];
    
    [accessoryPath stroke];
    
    CGContextRestoreGState(ctx);
    
//    CAShapeLayer *accessoryLayer = [CAShapeLayer layer];
//    accessoryLayer.frame = CGRectMake((CGRectGetWidth(disclosureFrame) - accessoryDim) / 2.f, (CGRectGetHeight(disclosureFrame) - accessoryDim - accessoryDim) / 2.f, accessoryDim, accessoryDim + accessoryDim);
//    accessoryLayer.path = [accessoryPath CGPath];
//    accessoryLayer.strokeColor = [[UIColor whiteColor] CGColor];
//    accessoryLayer.fillColor = [[UIColor clearColor] CGColor];
//    accessoryLayer.lineWidth = 3.f;
//    accessoryLayer.shadowColor = [[UIColor blackColor] CGColor];
//    accessoryLayer.shadowOpacity = .7f;
//    accessoryLayer.shadowRadius = 0.f;
//    accessoryLayer.shadowOffset = CGSizeMake(.25f, .25f);
//    
    
    
}

@end
