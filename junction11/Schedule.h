//
//  Schedule.h
//  junction11
//
//  Created by Maximilian Zangs on 26.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Schedule : NSObject

- (BOOL)scheduleHasLoaded;

- (void)update;
- (NSInteger)numberOfDaysInSchedule;
- (NSString *)nameForDay:(NSInteger)day;
- (NSInteger)numberOfShowsPerDay:(NSInteger)day;

- (NSString *)titleForShow:(NSInteger)show onDay:(NSInteger)day;
- (NSString *)infoForShow:(NSInteger)show onDay:(NSInteger)day;
- (NSString *)descriptionForShow:(NSInteger)show onDay:(NSInteger)day;
- (BOOL)isLinkWithShow:(NSInteger)show onDay:(NSInteger)day;
- (BOOL)isFacebookLinkWithShow:(NSInteger)show onDay:(NSInteger)day;
- (NSString *)urlForShow:(NSInteger)show onDay:(NSInteger)day;

- (NSDate *)notifyTimeOfMinutes:(NSInteger)minutes beforeShow:(NSInteger)show onDay:(NSInteger)day;
- (NSDate *)startingTimeOfShow:(NSInteger)show onDay:(NSInteger)day;
@end
