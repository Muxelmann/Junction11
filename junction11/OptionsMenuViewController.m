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
@property (strong, nonatomic) OptionsViewController *options;
@property CGFloat width;

@end

@implementation OptionsMenuViewController
@synthesize delegate = _delegate;
@synthesize container = _container;
@synthesize options = _options;
@synthesize width = _width;

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
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;

    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    for (int i = 0; i < [self.childViewControllers count]; i++) {
        [[self.childViewControllers objectAtIndex:i] viewWillAppear:animated];
    }
    CGRect rect;
//    if ([UIDevice.currentDevice userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        rect = self.view.frame;
        rect.origin = CGPointMake(0, 0);
        rect.size.height += 20;
        self.view.frame = rect;
//    }
    
    rect = self.options.view.frame;
    rect.size.width = self.width;
    rect.origin = CGPointMake(0, 0);
    self.options.view.frame = rect;
    
//    NSLog(@"View will appread");
//    NSLog(@"No of children: %i", [self.childViewControllers count]);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    for (int i = 0; i < [self.childViewControllers count]; i++) {
        [[self.childViewControllers objectAtIndex:i] viewWillDisappear:animated];
    }
//    NSLog(@"View will disappear");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
//{
//    
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    NSLog(@"Searching Segue...");
    if ([segue.identifier isEqualToString:@"loadOptions"]) {
//        NSLog(@"loadOptions intercepted...");
        if ([segue.destinationViewController isKindOfClass:[OptionsViewController class]]) {
            
//            if ([UIDevice.currentDevice userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//                self.view.frame = CGRectMake(0, 0, 259, self.parentViewController.view.bounds.size.height);
//            }
            
            
            self.options = (OptionsViewController *)segue.destinationViewController;
            self.options.delegate = self.delegate;
        }
    }
}

@end
