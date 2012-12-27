//
//  OptionsMenuViewController.m
//  junction11
//
//  Created by Maximilian Zangs on 26.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import "OptionsMenuViewController.h"

@interface OptionsMenuViewController ()

@property (weak, nonatomic) IBOutlet UIView *container;

@end

@implementation OptionsMenuViewController
@synthesize delegate = _delegate;
@synthesize container = _container;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.frame = CGRectMake(0, 0, 259, self.parentViewController.view.bounds.size.height);
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    NSLog(@"View will appread");
//    NSLog(@"No of children: %i", [self.childViewControllers count]);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    NSLog(@"View will disappear");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    NSLog(@"Searching Segue...");
    if ([segue.identifier isEqualToString:@"loadOptions"]) {
//        NSLog(@"loadOptions intercepted...");
        if ([segue.destinationViewController isKindOfClass:[OptionsViewController class]]) {
            ((OptionsViewController *)segue.destinationViewController).delegate = self;
        }
    }
}

- (void)setHeighStreamEnabled:(bool)isEnabled
{
    [self.delegate setHeighStreamEnabled:isEnabled];
}

- (void)setNotificationsEnabled:(bool)isEnabled
{
    [self.delegate setNotificationsEnabled:isEnabled];
}

- (BOOL)areNotificationsEnabled
{
    return [self.delegate areNotificationsEnabled];
}

- (BOOL)isHeighStreamEnabled
{
    return [self.delegate isHeighStreamEnabled];
}

@end
