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
@property (strong, nonatomic) OptionsViewController *options;

- (void)didReceiveMemoryWarning;

@end

@implementation ViewController
@synthesize main = _main;
@synthesize options = _options;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.main = [self.storyboard instantiateViewControllerWithIdentifier:@"mainViewControllerID"];
    self.options = [self.storyboard instantiateViewControllerWithIdentifier:@"optionsMenuViewControllerID"];
    
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

- (BOOL)optionsWillAppear
{
    [self.options viewWillAppear:YES];
    return true;
}

- (BOOL)optionsWillDisappear
{
    [self.options viewWillDisappear:YES];
    return true;
}

@end
