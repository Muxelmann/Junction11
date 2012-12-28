//
//  NotificationNavigationController.m
//  junction11
//
//  Created by Maximilian Zangs on 28.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import "NotificationNavigationController.h"

@interface NotificationNavigationController ()

@end

@implementation NotificationNavigationController
@synthesize notificationsDelegate = _notificationsDelegate;
@synthesize popover = _popover;

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
    
    if ([[self.viewControllers lastObject] isKindOfClass:[NotificationsViewController class]]) {
        NotificationsViewController *viewController = (NotificationsViewController *)[self.viewControllers lastObject];
        viewController.delegate = self.notificationsDelegate;
        viewController.button = self.button;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
