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

@interface ViewController : UIViewController <OptionViewDelegate, MainViewDelegate, ShowViewDelegate, ShowSchedulingDelegate>

//- (void)setHeighStreamEnabled:(bool)isEnabled;
//- (void)setNotificationsEnabled:(bool)isEnabled;

//@property (nonatomic) BOOL isInHeighStream;
//@property (nonatomic) BOOL areNotificationsEnabled;
//- (BOOL)isInHeighStream;
//- (BOOL)areNotificationsEnabled;

@end
