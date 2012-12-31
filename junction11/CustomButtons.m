//
//  CustomButtons.m
//  junction11
//
//  Created by Maximilian Zangs on 29.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import "CustomButtons.h"
#import <QuartzCore/QuartzCore.h>

@implementation CustomButtons

+ (void)makeButtonGlossy:(UIButton *)button
{
    button.imageView.contentMode = UIViewContentModeScaleToFill;
    
    CAGradientLayer *gradient = [[CAGradientLayer alloc] init];
    gradient.frame = button.bounds;
//    gradient.position = CGPointMake(button.bounds.size.width/2, button.bounds.size.height/2);
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithWhite:1.0f alpha:0.4f] CGColor],
                       (id)[[UIColor colorWithWhite:1.0f alpha:0.2f] CGColor],
                       (id)[[UIColor colorWithWhite:0.75f alpha:0.2f] CGColor],
                       (id)[[UIColor colorWithWhite:0.4f alpha:0.2f] CGColor],
                       (id)[[UIColor colorWithWhite:1.0f alpha:0.4f] CGColor],
                       nil];
    gradient.locations = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0.0f],
                          [NSNumber numberWithFloat:0.5f],
                          [NSNumber numberWithFloat:0.5f],
                          [NSNumber numberWithFloat:0.8f],
                          [NSNumber numberWithFloat:1.0f],
                          nil];
    
    [button.layer addSublayer:gradient];
    
    if (button.frame.size.height > 40)
        button.layer.cornerRadius = 10.0f;
    else
        button.layer.cornerRadius = 5.0f;
    
    button.layer.masksToBounds = YES;
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.borderWidth = 0.5f;
}

+ (void)makeCellButtonRed:(UITableViewCell *)cell
{
    cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"red.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"redDark.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0]];
}

+ (void)makeCellButtonGreen:(UITableViewCell *)cell
{
    cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"green.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"greenDark.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0]];
}

+ (void)makeCellButtonWhite:(UITableViewCell *)cell
{
    cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"white.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"whiteDark.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0]];
}

+ (void)applyOverlaytoView:(UIView *)view
{
    view.contentMode = UIViewContentModeScaleToFill;
    
    CALayer *bottomBorder = [CALayer layer];
    
//    NSLog(@"height %f", view.bounds.size.height);
    bottomBorder.frame = CGRectMake(0.0f, view.bounds.size.height-1, view.bounds.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    
    [view.layer addSublayer:bottomBorder];
}

+ (void)makeOverlayWithColor:(UIColor *)color toView:(UIView *)view
{
    view.contentMode = UIViewContentModeScaleToFill;

    CGColorRef colorRef = [color CGColor];
    
    CGFloat borderWidth = 5.0f;
    
    int numComponents = CGColorGetNumberOfComponents(colorRef);
    if (numComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(colorRef);
        CGFloat red = components[0];
        CGFloat green = components[1];
        CGFloat blue = components[2];

        CAGradientLayer *gradient = [[CAGradientLayer alloc] init];
        gradient.frame = CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height-borderWidth);
        
        gradient.colors = [NSArray arrayWithObjects:
                           (id)[[UIColor colorWithRed:red green:green blue:blue alpha:0.2f] CGColor],
                           (id)[[UIColor colorWithRed:red green:green blue:blue alpha:0.1f] CGColor],
                           (id)[[UIColor colorWithRed:red*0.75 green:green*0.75 blue:blue*0.75 alpha:0.1f] CGColor],
                           (id)[[UIColor colorWithRed:red*0.40 green:green*0.40 blue:blue*0.40 alpha:0.1f] CGColor],
                           (id)[[UIColor colorWithRed:red green:green blue:blue alpha:0.2f] CGColor],
                           nil];
        gradient.locations = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.0f],
                              [NSNumber numberWithFloat:0.5f],
                              [NSNumber numberWithFloat:0.5f],
                              [NSNumber numberWithFloat:0.8f],
                              [NSNumber numberWithFloat:1.0f],
                              nil];
        
        [view.layer addSublayer:gradient];
    }
    
    CAGradientLayer *bottomBorder = [[CAGradientLayer alloc] init];
    
    bottomBorder.frame = CGRectMake(0.0f, view.bounds.size.height-borderWidth, view.bounds.size.width, borderWidth);
//    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    
    bottomBorder.colors = [NSArray arrayWithObjects:
                           (id)[[UIColor colorWithWhite:0.0 alpha:1.0] CGColor],
                           (id)[[UIColor colorWithWhite:0.0 alpha:0.8] CGColor],
                           (id)[[UIColor colorWithWhite:0.0 alpha:0.4] CGColor],
                           (id)[[UIColor colorWithWhite:0.0 alpha:0.1] CGColor],
                           (id)[[UIColor colorWithWhite:0.0 alpha:0.0] CGColor],
                       nil];
    bottomBorder.locations = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0.0f],
                          [NSNumber numberWithFloat:0.25f],
                          [NSNumber numberWithFloat:0.5f],
                          [NSNumber numberWithFloat:0.75f],
                          [NSNumber numberWithFloat:1.0f],
                          nil];
    
    [view.layer addSublayer:bottomBorder];
    
//    view.layer.masksToBounds = YES;
//    view.layer.borderColor = [UIColor blackColor].CGColor;
//    view.layer.borderWidth = 0.5f;
}

+ (void)makeHollowView:(UIView *)view
{
    view.backgroundColor = [UIColor clearColor];
    
    if (view.frame.size.height > 40)
        view.layer.cornerRadius = 10.0f;
    else
        view.layer.cornerRadius = 5.0f;
    
    view.layer.masksToBounds = YES;
    view.layer.borderColor = [UIColor blackColor].CGColor;
    view.layer.borderWidth = 0.5f;
}

@end
