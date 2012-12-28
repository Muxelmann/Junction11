//
//  NotificationNavigationController.h
//  junction11
//
//  Created by Maximilian Zangs on 28.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationsViewController.h"

@interface NotificationNavigationController : UINavigationController

@property (nonatomic, assign) id<ManageNotificationsDelegate> notificationsDelegate;
@property (assign, nonatomic) id<NotidicationButtonDelegate> button;

@property (strong, nonatomic) UIPopoverController *popover;

@end
