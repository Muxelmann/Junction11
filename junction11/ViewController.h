//
//  ViewController.h
//  junction11
//
//  Created by Maximilian Zangs on 19.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionsMenuViewController.h"
#import "OptionsViewController.h"
#import "MainViewController.h"
#import "Schedule.h"

// The main view controller that displays the player and options
@interface ViewController : UIViewController <OptionViewDelegate, MainViewDelegate, ShowViewDelegate, ShowSchedulingDelegate, ManageNotificationsDelegate, ScheduleDataSource>


@end
