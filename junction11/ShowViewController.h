//
//  ShowViewController.h
//  junction11
//
//  Created by Maximilian Zangs on 26.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowViewDelegate;
@protocol ShowDataSource;
@protocol ShowSchedulingDelegate;

@interface ShowViewController : UITableViewController

@property (nonatomic, assign) id<ShowViewDelegate, ShowSchedulingDelegate> delegate;
@property (nonatomic, assign) id<ShowDataSource> dataSource;
//@property (nonatomic, assign) id<ShowSchedulingDelegate> notificationsDelegate;

@end

@protocol ShowViewDelegate <NSObject>

- (BOOL)areNotificationsEnabled;

@end

@protocol ShowDataSource <NSObject>

- (NSString *)showTitle;
- (NSString *)showInfo;
- (NSString *)showDescription;
- (BOOL)showHasURL;
- (BOOL)showHasFacebookURL;
- (NSString *)showURL;
- (NSDate *)showNotify;
- (NSDate *)showStartTime;

@end

@protocol ShowSchedulingDelegate <NSObject>

- (void)scheduleNotificationFor:(id<ShowDataSource>)dataSource;
- (BOOL)isNotificationForTime:(NSDate *)time;
- (BOOL)unscheduleNotificationForTime:(NSDate*)time;

@end