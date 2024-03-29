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

// Just another main view to contain the options view so that it is easily embedded in iPad
@interface OptionsMenuViewController : UIViewController

@property (nonatomic, assign) id<OptionViewDelegate, MainViewDelegate, ManageNotificationsDelegate, ScheduleDataSource> delegate;

- (void)setWidth:(CGFloat)width;

@end