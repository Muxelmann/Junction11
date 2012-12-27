//
//  ScheduleMenuViewController.h
//  junction11
//
//  Created by Maximilian Zangs on 26.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleViewController.h"

@interface ScheduleMenuViewController : UIViewController// <ShowViewDelegate>

@property (nonatomic, assign) id<ShowViewDelegate, ShowSchedulingDelegate> delegate;

@end
