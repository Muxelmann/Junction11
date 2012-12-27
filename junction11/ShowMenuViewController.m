//
//  ShowMenuViewController.m
//  junction11
//
//  Created by Maximilian Zangs on 26.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import "ShowMenuViewController.h"

@interface ShowMenuViewController ()

@end

@implementation ShowMenuViewController
@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    NSLog(@"Searching Segue...");
    if ([segue.identifier isEqualToString:@"showShow"]) {
//        NSLog(@"showShow intercepted...");
        if ([segue.destinationViewController isKindOfClass:[ShowViewController class]]) {
            ShowViewController *viewController = segue.destinationViewController;
            viewController.delegate = self.delegate;
            viewController.dataSource = self.dataSource;
        }
    }
}

@end
