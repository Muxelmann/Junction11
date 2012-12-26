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
    
//    UINavigationItem *backButton = [[UINavigationItem alloc] initWithTitle:@"Back"];
//    UINavigationItem *title = [[UINavigationItem alloc]initWithTitle:@"Schedule"];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(backButtonPressed:)];

    UINavigationItem *title = [[UINavigationItem alloc] initWithTitle:@"Title"];
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

- (IBAction)backButtonPressed:(id)sender
{
    NSLog(@"Back...");
}

@end
