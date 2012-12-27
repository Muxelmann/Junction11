//
//  ScheduleViewController.h
//  junction11
//
//  Created by Maximilian Zangs on 26.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Schedule.h"
#import "ShowMenuViewController.h"

@interface ScheduleViewController : UITableViewController <ShowViewDelegate>

@property (nonatomic, assign) id<ShowViewDelegate> delegate;

@end
