//
//  ScheduleNavigationController.h
//  junction11
//
//  Created by Maximilian Zangs on 27.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleViewController.h"

@interface ScheduleNavigationController : UINavigationController

@property (assign, nonatomic) id<ShowViewDelegate, ShowSchedulingDelegate>scheduleDelegate;
@property (assign, nonatomic) id<ScheduleDataSource>schedule;
@property (assign, nonatomic) UIBarButtonItem *popoverButton;

@end
