//
//  MainViewController.m
//  junction11
//
//  Created by Maximilian Zangs on 26.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *optionsButton;
@property (strong, nonatomic) WebRadioStream *stream;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeGesture;
@property (nonatomic) bool isOptionsVisible;

@end

@implementation MainViewController
@synthesize delegate = _delegate;
@synthesize stream = _stream;
@synthesize playButton = _playButton;
@synthesize optionsButton = _optionsButton;
@synthesize swipeGesture = _swipeGesture;
@synthesize isOptionsVisible = _isOptionsVisible;
@synthesize schedule = _schedule;

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
    
    self.stream.delegate = self;
    if ([self.view isKindOfClass:[MainView class]]) {
        ((MainView *)self.view).delegate = self;
    }
    
    self.view.userInteractionEnabled = YES;
    
    self.swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    self.swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:self.swipeGesture];
    self.isOptionsVisible = false;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];

    self.view.backgroundColor = [UIColor colorWithRed:(1./255.) green:(114./255.) blue:(173./255.) alpha:1.0];
    
   
    [self.playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    self.playButton.backgroundColor = [UIColor blackColor];
    self.playButton.imageView.contentMode = UIViewContentModeScaleToFill;

    CAGradientLayer *gradient = [[CAGradientLayer alloc] init];
    gradient.frame = self.playButton.bounds;
    gradient.position = CGPointMake(self.playButton.bounds.size.width/2, self.playButton.bounds.size.height/2);
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithWhite:1.0f alpha:0.4f] CGColor],
                        (id)[[UIColor colorWithWhite:1.0f alpha:0.2f] CGColor],
                        (id)[[UIColor colorWithWhite:0.75f alpha:0.2f] CGColor],
                        (id)[[UIColor colorWithWhite:0.4f alpha:0.2f] CGColor],
                        (id)[[UIColor colorWithWhite:1.0f alpha:0.4f] CGColor],
                       nil];
    gradient.locations = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0.0f],
                          [NSNumber numberWithFloat:0.5f],
                          [NSNumber numberWithFloat:0.5f],
                          [NSNumber numberWithFloat:0.8f],
                          [NSNumber numberWithFloat:1.0f],
                          nil];
    
    [self.playButton.layer addSublayer:gradient];
    
    self.playButton.layer.cornerRadius = 10.0f;
    self.playButton.layer.masksToBounds = YES;
    self.playButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.playButton.layer.borderWidth = 0.5f;
    
    // Once everything visual has been set up, start webstream
    [self.stream playAndResume:self.playButton];
//    NSLog(@"Start stream : %@", [self.stream play]);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self.view isKindOfClass:[MainView class]])
        [(MainView *)self.view enableFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    NSLog(@"Searching Segue...");
    if ([segue.identifier isEqualToString:@"showSchedule"]) {
//        NSLog(@"showSchedule intercepted...");

        if ([segue.destinationViewController isKindOfClass:[ScheduleNavigationController class]]) {
            ScheduleNavigationController *navigationController = (ScheduleNavigationController *)segue.destinationViewController;
            navigationController.scheduleDelegate = self.delegate;
            navigationController.schedule = self.schedule;
            
            if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
                if ([sender isKindOfClass:[UIBarButtonItem class]]) {
                    ((UIBarButtonItem *)sender).enabled = NO;
                    navigationController.popoverButton = (UIBarButtonItem *)sender;
                }
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (WebRadioStream *)stream
{
    if (!_stream) _stream = [[WebRadioStream alloc] init];
    return _stream;
}

- (IBAction)loadView:(id)sender {
    
    CGRect rect = self.view.frame;
    CGFloat constant = 259;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        constant = 320;
    
    if (self.isOptionsVisible) {
        rect.origin.x -= constant;
        
        self.optionsButton.title = @"Options";
        
        [self.delegate optionsWillDisappear];
        
        self.isOptionsVisible = false;
        self.swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    } else {
        rect.origin.x += constant;
        
        self.optionsButton.title = @"Back";
        
        [self.delegate optionsWillAppearWithWidth:constant];
        
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

- (IBAction)test:(id)sender {
    NSLog(@"STREAM %@", ([self.delegate isHeighStreamEnabled]) ? @"YES" : @"NO");
    NSLog(@"NOTIFICATION %@", ([self.delegate areNotificationsEnabled]) ? @"YES" : @"NO");
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    NSCalendar *greg = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    comp.minute = 1;
    NSDate *test = [greg dateByAddingComponents:comp toDate:now options:0];
    notification.fireDate = test;
    
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.alertBody = [@"Test " stringByAppendingString:@" will begin shortly"];
    notification.alertAction = @"Open Junction11 App";
    //    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.soundName = @"superNotification.caf";
    
    
    NSArray *userInfoKeys = [[NSArray alloc] initWithObjects: @"title", @"time", nil];
    NSArray *userInfoObjects = [[NSArray alloc] initWithObjects:@"Test", test, nil];
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjects:userInfoObjects forKeys:userInfoKeys];
    
    notification.userInfo = userInfo;
    
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    NSLog(@"Test Notification scheduled...");
}

- (BOOL)isInHeighStream
{
    return [self.delegate isHeighStreamEnabled];
}

- (IBAction)playButtonPressed:(UIButton *)sender
{
    sender.backgroundColor = [UIColor darkGrayColor];
}
- (IBAction)playButtonPushed:(UIButton *)sender
{
    [self.stream playAndResume:sender];
}

- (void)updateStreamQuality
{
    if ([self.stream isPlaying]) {
        [self.stream pause:self.playButton];
        [self.stream playAndResume:self.playButton];
    }
}

#pragma mark - Player iPod controlls

- (BOOL)canBecomeFirstResponder
{
    return (self.stream != NULL);
}

- (BOOL)canResignFirstResponder
{
    return YES;
//    return [self isFirstResponder];
}


- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    [self.stream remoteControlReceivedOfType:event.subtype];
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    // Do nothing
}

@end
