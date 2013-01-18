//
//  ScheduleViewController.h
//  junction11
//
//  Created by Maximilian Zangs on 26.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowViewController.h"
#import "ScheduleDataSource.h"

// The list of all shows
@interface ScheduleViewController : UITableViewController <ShowDataSource>

@property (nonatomic, assign) id<ShowViewDelegate, ShowSchedulingDelegate> delegate;
@property (nonatomic, assign) id<ScheduleDataSource> schedule;

@end