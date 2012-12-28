//
//  ViewController.m
//  junction11
//
//  Created by Maximilian Zangs on 19.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) MainViewController *main;
@property (strong, nonatomic) OptionsMenuViewController *options;

@property BOOL heighStream;
@property BOOL notifications;

@property (strong, nonatomic) Schedule *schedule;
@property (strong, nonatomic) NSMutableArray *notificationsArray;

- (void)didReceiveMemoryWarning;

@end

@implementation ViewController
@synthesize main = _main;
@synthesize options = _options;
@synthesize heighStream = _heighStream;
@synthesize notifications = _notifications;
@synthesize notificationsArray = _notificationsArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.main = [self.storyboard instantiateViewControllerWithIdentifier:@"mainViewControllerID"];
    self.options = [self.storyboard instantiateViewControllerWithIdentifier:@"optionsMenuViewControllerID"];
    
    // Set self as options delegate, so that data change is received
    self.options.delegate = self;
    self.main.delegate = self;
    self.main.schedule = self.schedule;
    
    [self loadData];
    
    // Make the main and options panel a child view controller
    [self addChildViewController:self.main];
    [self addChildViewController:self.options];
    
    // Setiup base/lower views (i.e. Options & Schedule)
    [self.view addSubview:self.options.view];
    
    // Tell main that it will appread
    [self.main viewWillAppear:YES];
    
    // Tell main where it will appear
    self.main.view.frame = self.view.bounds;
    // Make main appear
    [self.view addSubview:self.main.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (Schedule *)schedule
{
    if (!_schedule) {
        _schedule = [[Schedule alloc] init];
    }
    return _schedule;
}

#pragma mark User Defaults

- (void)saveData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Stream Quality
    NSNumber *heighStream = [[NSNumber alloc] initWithBool:self.heighStream];
    [defaults setObject:heighStream forKey:@"stream"];
    
    // Notifications Enabled
    NSNumber *notifications = [[NSNumber alloc] initWithBool:self.notifications];
    [defaults setObject:notifications forKey:@"notifications"];
    
    // Notifications Array
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.notificationsArray] forKey:@"notificationsArray"];
//    [defaults setObject:[self.notificationsArray copy] forKey:@"notificationsArray"];
    
    [defaults synchronize];
    NSLog(@"Data saved [%i, %i]", self.heighStream, self.notifications);
}

- (void)loadData
{
    // Get the stored data before the view loads
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *notifications = [defaults objectForKey:@"notifications"];
    if (notifications)
        self.notifications = [notifications boolValue];
    else
        self.notifications = YES;
    
    NSNumber *heighStream = [defaults objectForKey:@"stream"];
    if (heighStream)
        self.heighStream = [heighStream boolValue];
    else
        self.heighStream = YES;
    
    NSData *notificationsArray = [defaults objectForKey:@"notificationsArray"];
    if (notificationsArray)
        self.notificationsArray = [NSKeyedUnarchiver unarchiveObjectWithData:notificationsArray];
//    else
//        self.notificationsArray = [[NSMutableArray alloc] init];
    
    if (![self.notificationsArray isKindOfClass:[NSMutableArray class]])
        self.notificationsArray = [[NSMutableArray alloc] init];
    
    NSLog(@"Data loaded [%i, %i]", self.heighStream, self.notifications);
}

#pragma mark MainViewDelegate

- (void)optionsWillAppearWithWidth:(CGFloat)width
{
//    CGRect frameRect = self.options.view.frame;
//    frameRect.size.width = width;
//    frameRect.origin = CGPointMake(0, 0);
//    self.options.view.frame = frameRect;
    
    [self.options setWidth:width];
    [self.options viewWillAppear:YES];
}

- (void)optionsWillDisappear
{
    [self.options viewWillDisappear:YES];
}

#pragma mark OptionsViewDelegate

- (void)setHeighStreamEnabled:(bool)isEnabled
{
    NSLog(@"STREAM CHANGED! [%@]", (isEnabled) ? @"YES" : @"NO");
    self.heighStream = isEnabled;
    [self saveData];
}

- (void)setNotificationsEnabled:(bool)isEnabled
{
    NSLog(@"NOTIFICATIONS CHANGED! [%@]", (isEnabled) ? @"YES" : @"NO");
    self.notifications = isEnabled;
    [self saveData];
}

- (NSInteger)numberOfNotifications
{
    return [self.notificationsArray count];
}

#pragma mark ManageNotificationsDelegate


- (NSDate *)timeForNotificationAtIndex:(NSInteger)index
{
    UILocalNotification *notification = [self.notificationsArray objectAtIndex:index];
    return [notification.userInfo objectForKey:@"time"];
}

- (NSString *)titleForNotificationAtIndex:(NSInteger)index
{
    UILocalNotification *notification = [self.notificationsArray objectAtIndex:index];
    return [notification.userInfo objectForKey:@"title"];
}

#pragma mark ShowViewDelegate

- (BOOL)areNotificationsEnabled
{
    NSLog(@"NOTIFICATIONS CHECK! [%@]", (self.notifications) ? @"YES" : @"NO");
    return self.notifications;
}

- (BOOL)isHeighStreamEnabled
{
    NSLog(@"HEIGH STREAM CHECK! [%@]", (self.heighStream) ? @"YES" : @"NO");
    return self.heighStream;
}

#pragma mark ShowSchedulingDelegate

- (BOOL)isNotificationForTime:(NSDate *)time
{
    if (!self.notifications)
        return NO;
    
    if ([self.notificationsArray count] == 0)
        return NO;
    
    NSEnumerator *enumerator = [self.notificationsArray objectEnumerator];
    id object;
    
    while (object = [enumerator nextObject]) {
        if ([object isKindOfClass:[UILocalNotification class]]) {
            UILocalNotification *notification = (UILocalNotification *)object;
            
            NSDate* timeObject = [notification.userInfo objectForKey:@"time"];
            
            if ([timeObject isEqualToDate:time]) {
                NSLog(@"Notification found");
                return YES;
            }
        }
    }
    
    return NO;
}


- (void)scheduleNotificationFor:(id<ShowDataSource>)dataSource
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [dataSource showNotify];
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.alertBody = [[dataSource showTitle] stringByAppendingString:@" will begin shortly"];
    notification.alertAction = @"Start Listening";
    notification.soundName = UILocalNotificationDefaultSoundName;

    
    NSArray *userInfoKeys = [[NSArray alloc] initWithObjects: @"title", @"time", nil];
    NSArray *userInfoObjects = [[NSArray alloc] initWithObjects:[dataSource showTitle], [dataSource showStartTime], nil];
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjects:userInfoObjects forKeys:userInfoKeys];
    
    notification.userInfo = userInfo;
    
    notification.repeatInterval = NSWeekCalendarUnit;
    
    [self.notificationsArray addObject:notification];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    [self saveData];
    
    NSLog(@"Notification scheduled [%i]", [self.notificationsArray count]);
}

- (BOOL)unscheduleNotificationForTime:(NSDate*)time
{
    NSEnumerator *enumerator = [self.notificationsArray objectEnumerator];
    id object;
    
    while (object = [enumerator nextObject]) {
        if ([object isKindOfClass:[UILocalNotification class]]) {
            UILocalNotification *notification = (UILocalNotification *)object;
            
            NSDate* timeObject = [notification.userInfo objectForKey:@"time"];
            
            if ([timeObject isEqualToDate:time]) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                [self.notificationsArray removeObject:object];
                [self saveData];
                NSLog(@"Notification canceled [%i]", [self.notificationsArray count]);
                return YES;
            }
        }
    }
    return NO;
}

@end
