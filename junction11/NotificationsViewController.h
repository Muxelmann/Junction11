//
//  NotificationsViewController.h
//  junction11
//
//  Created by Maximilian Zangs on 28.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ScheduleDataSource.h"

@protocol ManageNotificationsDelegate;
@protocol NotidicationButtonDelegate;

@interface NotificationsViewController : UITableViewController

@property (assign, nonatomic) id<ManageNotificationsDelegate> delegate;
@property (assign, nonatomic) id<NotidicationButtonDelegate> button;

@end

@protocol ManageNotificationsDelegate <NSObject>

- (BOOL)unscheduleNotificationForTime:(NSDate*)time;
- (NSInteger)numberOfNotifications;

- (NSDate *)timeForNotificationAtIndex:(NSInteger)index;
- (NSString *)titleForNotificationAtIndex:(NSInteger)index;

@end

@protocol NotidicationButtonDelegate <NSObject>

- (void)updateNotificationButton;

@end