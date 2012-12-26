//
//  MainViewController.m
//  junction11
//
//  Created by Maximilian Zangs on 26.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *optionsButton;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeGesture;
@property (nonatomic) bool isOptionsVisible;

@end

@implementation MainViewController
@synthesize optionsButton = _optionsButton;
@synthesize swipeGesture = _swipeGesture;
@synthesize isOptionsVisible = _isOptionsVisible;

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
    
    self.view.userInteractionEnabled = YES;
    self.swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    self.swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:self.swipeGesture];
    self.isOptionsVisible = false;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loadView:(id)sender {
    
    CGRect rect = self.view.frame;
    CGFloat constant = 259;
    
    if (self.isOptionsVisible) {
        rect.origin.x -= constant;
        
        self.optionsButton.title = @"Options";
        
        if ([self.parentViewController isKindOfClass:[ViewController class]]) {
            ViewController *parent = (ViewController *)self.parentViewController;
            [parent optionsWillDisappear];
        }
        
        self.isOptionsVisible = false;
        self.swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    } else {
        rect.origin.x += constant;
        
        self.optionsButton.title = @"Back";
        
        if ([self.parentViewController isKindOfClass:[ViewController class]]) {
            ViewController *parent = (ViewController *)self.parentViewController;
            [parent optionsWillAppear];
        }
        
        self.isOptionsVisible = true;
        self.swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    }
    
    [UIView animateWithDuration:.25f animations:^{
        self.view.frame = rect;
    } completion:^(BOOL isFinished){
        // Nothing to do when completed
    }];
}

- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)recognizer
{
    [self loadView:nil];
}

@end