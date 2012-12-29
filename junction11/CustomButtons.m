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

+ (void)makeOverlayWithColor:(UIColor *)color toView:(UIView *)view
{
//    button.imageView.contentMode = UIViewContentModeScaleToFill;
    
    CAGradientLayer *gradient = [[CAGradientLayer alloc] init];
    gradient.frame = view.bounds;
    //    gradient.position = CGPointMake(button.bounds.size.width/2, button.bounds.size.height/2);
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithWhite:1.0f alpha:0.2f] CGColor],
                       (id)[[UIColor colorWithWhite:1.0f alpha:0.1f] CGColor],
                       (id)[[UIColor colorWithWhite:0.75f alpha:0.1f] CGColor],
                       (id)[[UIColor colorWithWhite:0.4f alpha:0.1f] CGColor],
                       (id)[[UIColor colorWithWhite:1.0f alpha:0.2f] CGColor],
                       nil];
    gradient.locations = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0.0f],
                          [NSNumber numberWithFloat:0.5f],
                          [NSNumber numberWithFloat:0.5f],
                          [NSNumber numberWithFloat:0.8f],
                          [NSNumber numberWithFloat:1.0f],
                          nil];
    
    [view.layer addSublayer:gradient];
    
    view.layer.masksToBounds = YES;
    view.layer.borderColor = [UIColor blackColor].CGColor;
    view.layer.borderWidth = 0.5f;
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
