//
//  ScheduleMenuViewController.m
//  junction11
//
//  Created by Maximilian Zangs on 26.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import "ScheduleMenuViewController.h"

@interface ScheduleMenuViewController ()
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@end

@implementation ScheduleMenuViewController
@synthesize delegate = _delegate;
@synthesize navigationBar = _navigationBar;

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
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(backButtonPressed:)];

    UINavigationItem *title = [[UINavigationItem alloc] initWithTitle:@"Schedule"];
    title.rightBarButtonItem = backButton;
    title.hidesBackButton = YES;

    [self.navigationBar pushNavigationItem:title animated:YES];
    
    self.navigationBar.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    NSLog(@"Searching Segue...");
    if ([segue.identifier isEqualToString:@"loadSchedule"]) {
//        NSLog(@"loadSchedule intercepted...");
        if ([segue.destinationViewController isKindOfClass:[ScheduleViewController class]]) {
            ((ScheduleViewController *)segue.destinationViewController).delegate = self.delegate;
        }
    }
}

- (IBAction)backButtonPressed:(id)sender
{
    [self viewWillDisappear:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        [self saveNewNotifications];
    }];
}

- (void)saveNewNotifications
{
    [self removeFromParentViewController];
//    NSLog(@"Save notifications");
}

@end
