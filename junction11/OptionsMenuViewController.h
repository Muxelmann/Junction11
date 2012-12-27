//
//  OptionsMenuViewController.h
//  junction11
//
//  Created by Maximilian Zangs on 26.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionsViewController.h"
#import "MainViewController.h"

@interface OptionsMenuViewController : UIViewController

@property (nonatomic, assign) id<OptionViewDelegate, MainViewDelegate> delegate;

- (void)setWidth:(CGFloat)width;

@end