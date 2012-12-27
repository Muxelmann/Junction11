//
//  ViewController.m
//  junction11
//
//  Created by Maximilian Zangs on 19.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) MainViewController *main;
@property (strong, nonatomic) OptionsMenuViewController *options;

@property BOOL heighStream;
@property BOOL notifications;

- (void)didReceiveMemoryWarning;

@end

@implementation ViewController
@synthesize main = _main;
@synthesize options = _options;
@synthesize heighStream = _heighStream;
@synthesize notifications = _notifications;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.main = [self.storyboard instantiateViewControllerWithIdentifier:@"mainViewControllerID"];
    self.options = [self.storyboard instantiateViewControllerWithIdentifier:@"optionsMenuViewControllerID"];
    
    // Set self as options delegate, so that data change is received
    self.options.delegate = self;
    self.main.delegate = self;
    
    self.notifications = YES;
    self.heighStream = YES;
    
    // Make the main and options panel a child view controller
    [self addChildViewController:self.main];
    [self addChildViewController:self.options];
    
    // Setiup base/lower views (i.e. Options & Schedule)
    [self.view addSubview:self.options.view];
    
    // Tell main that it will appread
    [self.main viewWillAppear:YES];
    
    // Tell main where it will appear
    self.main.view.frame = self.view.bounds;
    // Make main appear
    [self.view addSubview:self.main.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ShowViewDelegate

- (BOOL)areNotificationsEnabled
{
    NSLog(@"NOTIFICATIONS CHECK! [%@]", (self.notifications) ? @"YES" : @"NO");
    return self.notifications;
}

- (BOOL)isHeighStreamEnabled
{
    NSLog(@"HEIGH STREAM CHECK! [%@]", (self.heighStream) ? @"YES" : @"NO");
    return self.heighStream;
}

#pragma mark MainViewDelegate

- (void)optionsWillAppear
{
    [self.options viewWillAppear:YES];
}

- (void)optionsWillDisappear
{
    [self.options viewWillDisappear:YES];
}

#pragma mark OptionsViewDelegate

- (void)setHeighStreamEnabled:(bool)isEnabled
{
    NSLog(@"STREAM CHANGED! [%@]", (isEnabled) ? @"YES" : @"NO");
    self.heighStream = isEnabled;
}

- (void)setNotificationsEnabled:(bool)isEnabled
{
    NSLog(@"NOTIFICATIONS CHANGED! [%@]", (isEnabled) ? @"YES" : @"NO");
    self.notifications = isEnabled;
}

@end
