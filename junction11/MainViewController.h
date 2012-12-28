//
//  MainViewController.h
//  junction11
//
//  Created by Maximilian Zangs on 26.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleNavigationController.h"

@protocol MainViewDelegate;

@interface MainViewController : UIViewController

@property (nonatomic, assign) id<ShowViewDelegate, MainViewDelegate, ShowSchedulingDelegate> delegate;
@property (nonatomic, assign) id<ScheduleDataSource> schedule;

@end

@protocol MainViewDelegate <NSObject>

- (BOOL)isHeighStreamEnabled;
- (void)optionsWillAppearWithWidth:(CGFloat)width;
- (void)optionsWillDisappear;

@end