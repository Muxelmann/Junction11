//
//  MainViewController.m
//  junction11
//
//  Created by Maximilian Zangs on 26.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import "MainViewController.h"
#import "CustomButtons.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *optionsButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shoutboxConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shoutboxPlayButtonConstraint;
@property (strong, nonatomic) WebRadioStream *stream;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeGestureOptions;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeGestureShoutbox;

@end

@implementation MainViewController
@synthesize delegate = _delegate;
@synthesize stream = _stream;
@synthesize playButton = _playButton;
@synthesize optionsButton = _optionsButton;
@synthesize shoutboxConstraint = _shoutboxConstraint;
@synthesize shoutboxPlayButtonConstraint = _shoutboxPlayButtonConstraint;
@synthesize swipeGestureOptions = _swipeGestureOptions;
@synthesize swipeGestureShoutbox = _swipeGestureShoutbox;
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

    // Set up delegates and subviews first
    self.stream.delegate = self;
    for (UIView *view in self.view.subviews)
        if ([view.restorationIdentifier isEqualToString:@"shoutboxID"]) {
            view.backgroundColor = [UIColor clearColor];
            view.autoresizingMask = UIViewAutoresizingNone;
        }
    
    self.view.userInteractionEnabled = YES;
    
    // Gesture to display options menu
    self.swipeGestureOptions = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(loadOptionsView:)];
    self.swipeGestureOptions.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:self.swipeGestureOptions];
    
    self.shoutboxConstraint.constant = -237;
    // Gesture to display shoutbox
    self.swipeGestureShoutbox = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showShoutbox:)];
    self.swipeGestureShoutbox.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:self.swipeGestureShoutbox];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];

    self.view.backgroundColor = [UIColor colorWithRed:(1./255.) green:(114./255.) blue:(173./255.) alpha:1.0];
   
    [self.playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    [CustomButtons makeButtonGlossy:self.playButton];
    
    
    // Once everything visual has been set up, start webstream
    [self.stream playAndResume];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateButtonAndStream:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateButtonAndStream:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showSchedule"]) {

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

#pragma mark Getter and setter

- (WebRadioStream *)stream
{
    if (!_stream) _stream = [[WebRadioStream alloc] init];
    return _stream;
}

#pragma mark Loading subviews

- (IBAction)loadOptionsView:(id)sender {
    
    CGRect rect = self.view.frame;
    CGFloat constant = 259;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        constant = 320;
    
    if (self.swipeGestureOptions.direction == UISwipeGestureRecognizerDirectionLeft) {
        rect.origin.x -= constant;
        
        self.optionsButton.title = @"Options";
        
        [self.delegate optionsWillDisappear];
        
        self.swipeGestureOptions.direction = UISwipeGestureRecognizerDirectionRight;
    } else {
        rect.origin.x += constant;
        
        self.optionsButton.title = @"Back";
        
        [self.delegate optionsWillAppearWithWidth:constant];
        
        self.swipeGestureOptions.direction = UISwipeGestureRecognizerDirectionLeft;
    }
    
    [UIView animateWithDuration:.25f animations:^{
        self.view.frame = rect;
    } completion:^(BOOL isFinished){
        // Nothing to do when completed
    }];
}

- (IBAction)showShoutbox:(UISwipeGestureRecognizer *)recognizer
{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        recognizer.direction = UISwipeGestureRecognizerDirectionUp;
        [UIView animateWithDuration:0.5 animations:^{
            self.shoutboxConstraint.constant = 44;
            self.shoutboxPlayButtonConstraint.constant = 20;
            [self.view layoutIfNeeded];
        }];
    } else {
        recognizer.direction = UISwipeGestureRecognizerDirectionDown;
        [UIView animateWithDuration:0.5 animations:^{
            self.shoutboxConstraint.constant = -237;
            self.shoutboxPlayButtonConstraint.constant = 64;
            [self.view layoutIfNeeded];
        }];
    }
}

#pragma mark Setting and stream options

- (BOOL)isInHeighStream
{
    return [self.delegate isHeighStreamEnabled];
}

- (IBAction)playButtonPressed:(UIButton *)sender
{
    sender.backgroundColor = [UIColor darkGrayColor];
}
- (IBAction)playButtonReleased:(UIButton *)sender
{
    [self.stream playAndResume];
}

- (IBAction)playButtonReleasedOutside:(UIButton *)sender
{
    [self.stream update];
}

- (void)updateStreamQuality
{
    if ([self.stream isPlaying]) {
        [self.stream pause];
        [self.stream playAndResume];
    }
}

- (void)updateButtonAndStream:(id)sender
{
    if (self.isFirstResponder) {
        [self.stream update];
    }
    [self becomeFirstResponder];
}


#pragma mark - Player iPod controlls

- (BOOL)canBecomeFirstResponder
{
    return (self.stream != NULL);
}

- (BOOL)canResignFirstResponder
{
//    BOOL canResign = (!self.stream || ![self.stream isPlaying]);
    BOOL canResign = (self.swipeGestureShoutbox.direction == UISwipeGestureRecognizerDirectionUp);
//    NSLog(@"CAN RESIGN: %i", canResign);
    return canResign;
//    return [self isFirstResponder];
}

- (BOOL)becomeFirstResponder
{
    if (self.canBecomeFirstResponder) {
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        BOOL first = [super becomeFirstResponder];
//        NSLog(@"BECOME FIRST : %i", first);
        return first;
    }/* else
        NSLog(@"CANNOT BECOME FIRST");
      */
    return NO;
}

- (BOOL)resignFirstResponder
{
    if (self.canResignFirstResponder) {
        [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
        BOOL resign = [super resignFirstResponder];
//        NSLog(@"RESIGN FIRST : %i", resign);
        return resign;
    }/* else
        NSLog(@"CANNOT RESIGN FIRST");
      */
        
    return NO;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    [self.stream remoteControlReceivedOfType:event.subtype];
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    // Do nothing
}

#pragma mark Debugging code

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
    notification.soundName = @"superNotification.caf";
    
    
    NSArray *userInfoKeys = [[NSArray alloc] initWithObjects: @"title", @"time", nil];
    NSArray *userInfoObjects = [[NSArray alloc] initWithObjects:@"Test", test, nil];
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjects:userInfoObjects forKeys:userInfoKeys];
    
    notification.userInfo = userInfo;
    
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    NSLog(@"Test Notification scheduled...");
}

@end