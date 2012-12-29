//
//  MainViewController.h
//  junction11
//
//  Created by Maximilian Zangs on 26.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleNavigationController.h"
#import "WebRadioStream.h"

@protocol MainViewDelegate;

@interface MainViewController : UIViewController <WebPlayerDelegate>

@property (nonatomic, assign) id<ShowViewDelegate, MainViewDelegate, ShowSchedulingDelegate> delegate;
@property (nonatomic, assign) id<ScheduleDataSource> schedule;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

- (IBAction)loadOptionsView:(id)sender;
- (IBAction)playButtonPressed:(UIButton *)sender;
- (IBAction)playButtonReleased:(UIButton *)sender;
- (IBAction)playButtonReleasedOutside:(UIButton *)sender;

- (void)updateStreamQuality;

@end

@protocol MainViewDelegate <NSObject>

- (BOOL)isHeighStreamEnabled;
- (void)optionsWillAppearWithWidth:(CGFloat)width;
- (void)optionsWillDisappear;

@end