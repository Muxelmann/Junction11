//
//  CustomButtons.h
//  junction11
//
//  Created by Maximilian Zangs on 29.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import <Foundation/Foundation.h>

// This object simply generates custom buttons so that the code needn't be rewritten
@interface CustomButtons : NSObject

+ (void)makeButtonGlossy:(UIButton *)sender;

+ (void)makeCellButtonRed:(UITableViewCell *)cell;
+ (void)makeCellButtonGreen:(UITableViewCell *)cell;
+ (void)makeCellButtonWhite:(UITableViewCell *)cell;

+ (void)applyOverlaytoView:(UIView *)view;
+ (void)makeOverlayWithColor:(UIColor *)color toView:(UIView *)view;
+ (void)makeHollowView:(UIView *)view;

@end
