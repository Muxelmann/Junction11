//
//  MainViewController.m
//  junction11
//
//  Created by Maximilian Zangs on 26.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import "MainViewController.h"
#import "CustomButtons.h"
#import <MessageUI/MessageUI.h>

@interface MainViewController () <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *optionsButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shoutboxConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shoutboxPlayButtonConstraint;
@property (weak, nonatomic) IBOutlet UILabel *onAirTop;
@property (weak, nonatomic) IBOutlet UILabel *onAirBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *onAirTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *onAirBottomConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *infoImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoImageConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *borderConstraint;

@property (strong, nonatomic) WebRadioStream *stream;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeGestureOptions;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeGestureShoutbox;
@property (strong, nonatomic) NSTimer *showDisplay;

@end

@implementation MainViewController
@synthesize delegate = _delegate;
@synthesize stream = _stream;
@synthesize playButton = _playButton;
@synthesize loadingActivity = _loadingActivity;
@synthesize optionsButton = _optionsButton;
@synthesize shoutboxConstraint = _shoutboxConstraint;
@synthesize shoutboxPlayButtonConstraint = _shoutboxPlayButtonConstraint;
@synthesize onAirTop = _onAirTop;
@synthesize onAirBottom = _onAirBottom;
@synthesize onAirTopConstraint = _onAirTopConstraint;
@synthesize infoImage = _infoImage;
@synthesize infoImageConstraint = _infoImageConstraint;
@synthesize borderConstraint = _borderConstraint;

@synthesize swipeGestureOptions = _swipeGestureOptions;
@synthesize swipeGestureShoutbox = _swipeGestureShoutbox;
@synthesize schedule = _schedule;
@synthesize showDisplay = _showDisplay;

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
    
    // Gesture to display shoutbox & move play button
    self.swipeGestureShoutbox = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showShoutbox:)];
    self.swipeGestureShoutbox.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:self.swipeGestureShoutbox];
    
    
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.shoutboxConstraint.constant = -237;
        self.shoutboxPlayButtonConstraint.constant = 84;
        self.onAirTopConstraint.constant = 60;
        self.onAirBottomConstraint.constant = 10;
        self.infoImageConstraint.constant = 0;
    } else {
        self.shoutboxConstraint.constant = -360;
        self.shoutboxPlayButtonConstraint.constant = 175;
        self.onAirTopConstraint.constant = 100;
        self.onAirBottomConstraint.constant = 10;
        self.infoImageConstraint.constant = 0;
    }
    
    // Layout the onAir Label
    self.onAirTop.textAlignment = NSTextAlignmentLeft;
    self.onAirTop.font = [UIFont systemFontOfSize:14];
    self.onAirTop.textColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    self.onAirTop.text = @"Current Show";
    
    self.onAirBottom.textAlignment = NSTextAlignmentCenter;
    self.onAirBottom.font = [UIFont boldSystemFontOfSize:15];
    self.onAirBottom.textColor = [UIColor whiteColor];
    self.onAirBottom.text = @"";
//    self.onAirBottom.text = [self.schedule currentShow];
    
    self.showDisplay = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:10 target:self selector:@selector(updateShowDisplay:) userInfo:nil repeats:YES];
    NSRunLoop * theRunLoop = [NSRunLoop currentRunLoop];
    [theRunLoop addTimer:self.showDisplay forMode:NSDefaultRunLoopMode];
    
    // Info image
    self.infoImage.backgroundColor = [UIColor clearColor];
    self.infoImage.contentMode = UIViewContentModeTop;
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone)
        self.infoImage.image = [UIImage imageNamed:@"junction11.png"];
    else
        self.infoImage.image = [UIImage imageNamed:@"junction11pad.png"];
    
    self.borderConstraint.constant = -20;
    
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
        
    } else if ([segue.identifier isEqualToString:@"loadShoutbox"]){
        
        if ([segue.destinationViewController isKindOfClass:[ShoutboxViewController class]]) {
            ShoutboxViewController *shoutboxController = (ShoutboxViewController *)segue.destinationViewController;
            shoutboxController.delegate = self;
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
    if ([UIDevice.currentDevice userInterfaceIdiom] == UIUserInterfaceIdiomPad)
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
    if (self.swipeGestureShoutbox.direction == UISwipeGestureRecognizerDirectionDown) {
        self.swipeGestureShoutbox.direction = UISwipeGestureRecognizerDirectionUp;
        
        if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            [UIView animateWithDuration:0.5 animations:^{
                self.shoutboxConstraint.constant = 44;
                self.shoutboxPlayButtonConstraint.constant = 20;
                self.onAirTopConstraint.constant = 20;
                self.infoImageConstraint.constant = -self.infoImage.bounds.size.height;
                [self.view layoutIfNeeded];
            }];
        } else {
            [UIView animateWithDuration:0.5 animations:^{
                self.shoutboxConstraint.constant = 44;
                self.shoutboxPlayButtonConstraint.constant = 90;
                self.onAirTopConstraint.constant = 50;
                NSLog(@"OR %i ", UIInterfaceOrientationIsLandscape(UIDevice.currentDevice.orientation));
                if (UIInterfaceOrientationIsLandscape(UIDevice.currentDevice.orientation))
                    self.infoImageConstraint.constant = -self.infoImage.bounds.size.height;
                
                [self.view layoutIfNeeded];
            }];
        }
    } else {
        self.swipeGestureShoutbox.direction = UISwipeGestureRecognizerDirectionDown;
        
        if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            [UIView animateWithDuration:0.5 animations:^{
                self.shoutboxConstraint.constant = -237;
                self.shoutboxPlayButtonConstraint.constant = 84;
                self.onAirTopConstraint.constant = 60;
                self.infoImageConstraint.constant = 0;
                [self.view layoutIfNeeded];
            }];
        } else {
            [UIView animateWithDuration:0.5 animations:^{
                self.shoutboxConstraint.constant = -360;
                self.shoutboxPlayButtonConstraint.constant = 180;
                self.onAirTopConstraint.constant = 100;
                self.infoImageConstraint.constant = 0;
                [self.view layoutIfNeeded];
            }];
        }
    }
}

- (IBAction)updateShowDisplay:(id)sender
{
    
    [UILabel animateWithDuration:0.25 animations:^{
 
        [self.onAirTop setAlpha:0.0];
        [self.onAirBottom setAlpha:0.0];
        
    } completion:^(BOOL finished){
        
        if ([self.onAirTop.text isEqualToString:@"Current Show"]) {
            self.onAirTop.text = @"Next show";
            self.onAirBottom.text = [self.schedule nextShow];
        } else {
            self.onAirTop.text = @"Current Show";
            self.onAirBottom.text = [self.schedule currentShow];
        }
        
        [UILabel animateWithDuration:0.25 animations:^{
            
            [self.onAirTop setAlpha:1.0];
            [self.onAirBottom setAlpha:1.0];
            
        }];
    }];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
            if (self.swipeGestureShoutbox.direction == UISwipeGestureRecognizerDirectionUp) {
                self.infoImageConstraint.constant = -self.infoImage.bounds.size.height;
            } else {
                self.infoImageConstraint.constant = 0;
            }
        } else {
            self.infoImageConstraint.constant = 0;
        }
    }
}

#pragma mark Setting and stream options

- (BOOL)isInHeighStream
{
    return [self.delegate isHeighStreamEnabled];
}

- (IBAction)playButtonPressed:(UIButton *)sender
{
    // Only do something if Options are NOT visible
    if (self.swipeGestureOptions.direction == UISwipeGestureRecognizerDirectionRight)
        sender.backgroundColor = [UIColor darkGrayColor];
}
- (IBAction)playButtonReleased:(UIButton *)sender
{
    // Only do something if Options are NOT visible
    if (self.swipeGestureOptions.direction == UISwipeGestureRecognizerDirectionRight)
        [self.stream playAndResume];
}

- (IBAction)playButtonReleasedOutside:(UIButton *)sender
{
    // Only do something if Options are NOT visible
    if (self.swipeGestureOptions.direction == UISwipeGestureRecognizerDirectionRight)
        [self.stream update];
}

- (void)updateStreamQuality
{
    if ([self.stream isPlaying]) {
        [self.stream pause];
        self.stream = nil;
        self.stream = [[WebRadioStream alloc] init];
        self.stream.delegate = self;
        [self.stream playAndResume];
    } else {
        self.stream = nil;
        self.stream = [[WebRadioStream alloc] init];
        self.stream.delegate = self;
    }
}

- (void)updateButtonAndStream:(id)sender
{
    if (self.isFirstResponder) {
        [self.stream update];
    }
    [self becomeFirstResponder];
}

- (void)presentMailForAdminNotificationOfError:(NSError *)error
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setToRecipients:[NSArray arrayWithObject:@"tech@junction11radio.co.uk"]];
        [mail setSubject:@"Could not connect to server"];
        NSString *body = [NSString stringWithFormat:@"<html><head><style> #description { padding: 7px; width: 90%%; background: #ccc; border-radius: 5px; font-family: Menlo; color: #444; font-size: 10px;}</style></head><body><p>Details: </p><p id=\"description\">%@</p></body></html>", error];
        [mail setMessageBody:body isHTML:YES];
        [self presentViewController:mail animated:YES completion:^{
            
        }];
    } else {
        NSLog(@"Can not contact admin...");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"SORRY AGAIN"
                                                            message:@"But I can not contact the Junction11 admin...\nProbably because you do not have an email address on this device."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (!error) {
        [controller dismissViewControllerAnimated:YES completion:^{
            NSLog(@"Admin contacted!");
        }];
    } else {
        NSLog(@"Error contacting admin:\n%@", error);
    }
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
/*
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
*/
@end