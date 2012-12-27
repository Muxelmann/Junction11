//
//  Schedule.h
//  junction11
//
//  Created by Maximilian Zangs on 26.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Schedule : NSObject

- (void)update;
- (NSInteger)numberOfDaysInSchedule;
- (NSString *)nameForDay:(NSInteger)day;
- (NSInteger)numberOfShowsPerDay:(NSInteger)day;

- (NSString *)titleForShow:(NSInteger)show onDay:(NSInteger)day;
- (NSString *)infoForShow:(NSInteger)show onDay:(NSInteger)day;
- (BOOL)isLinkWithShow:(NSInteger)show onDay:(NSInteger)day;

@end
