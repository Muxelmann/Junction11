//
//  MainViewController.h
//  junction11
//
//  Created by Maximilian Zangs on 26.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleMenuViewController.h"

@protocol MainViewDelegate;

@interface MainViewController : UIViewController// <ShowViewDelegate>

@property (nonatomic, assign) id<ShowViewDelegate, MainViewDelegate> delegate;

@end

@protocol MainViewDelegate <NSObject>

- (BOOL)isHeighStreamEnabled;
- (void)optionsWillAppear;
- (void)optionsWillDisappear;

@end