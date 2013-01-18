//
//  Schedule.h
//  junction11
//
//  Created by Maximilian Zangs on 26.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScheduleDataSource.h"

@protocol ScheduleDataSource;

// This object ensures that the schedule is loaded and data is parsed corretcly
@interface Schedule : NSObject <ScheduleDataSource>

@end
