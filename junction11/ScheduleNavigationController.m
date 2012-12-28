//
//  ScheduleNavigationController.m
//  junction11
//
//  Created by Maximilian Zangs on 27.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import "ScheduleNavigationController.h"

@interface ScheduleNavigationController ()

@end

@implementation ScheduleNavigationController

@synthesize scheduleDelegate = _scheduleDelegate;
@synthesize schedule = _schedule;
@synthesize popoverButton = _popoverButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.popoverButton.enabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if ([[self.viewControllers lastObject] isKindOfClass:[ScheduleViewController class]]) {
        ScheduleViewController *viewController = (ScheduleViewController *)[self.viewControllers lastObject];
        viewController.delegate = self.scheduleDelegate;
        viewController.schedule = self.schedule;
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.navigationBar.barStyle = UIBarStyleBlack;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
