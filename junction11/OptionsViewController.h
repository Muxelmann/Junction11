//
//  OptionsViewController.h
//  junction11
//
//  Created by Maximilian Zangs on 26.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol OptionViewDelegate;

@interface OptionsViewController : UITableViewController

@property (nonatomic, assign) id<OptionViewDelegate> delegate;

@end

@protocol OptionViewDelegate <NSObject>

- (BOOL)areNotificationsEnabled;
- (BOOL)isHeighStreamEnabled;
- (void)setHeighStreamEnabled:(bool)isEnabled;
- (void)setNotificationsEnabled:(bool)isEnabled;

@end
