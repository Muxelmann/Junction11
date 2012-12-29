//
//  OptionsViewController.m
//  junction11
//
//  Created by Maximilian Zangs on 26.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import "OptionsViewController.h"
#import "CustomButtons.h"

@interface OptionsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *webcam;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingWebcam;
@property (weak, nonatomic) IBOutlet UITextView *descriptionBox;
@property (weak, nonatomic) IBOutlet UISwitch *highQualitySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *notoficationsSwitch;
@property (weak, nonatomic) IBOutlet UITableViewCell *manageNotifications;
@property (weak, nonatomic) IBOutlet UILabel *manageNotificationsLabel;

@property (strong, nonatomic) NSThread *updateImage;

@end

@implementation OptionsViewController
@synthesize delegate = _delegate;
@synthesize webcam = _webcam;
@synthesize loadingWebcam = _loadingWebcam;
@synthesize descriptionBox = _descriptionBox;
@synthesize highQualitySwitch = _highQualitySwitch;
@synthesize notoficationsSwitch = _notoficationsSwitch;
@synthesize manageNotifications = _manageNotifications;
@synthesize manageNotificationsLabel = _manageNotificationsLabel;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];
    
    self.loadingWebcam.hidesWhenStopped = YES;
    self.loadingWebcam.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.loadingWebcam.backgroundColor = [UIColor clearColor];
    
    self.highQualitySwitch.on = [self.delegate isHeighStreamEnabled];
//    [self.highQualitySwitch setOn:[self.delegate isHeighStreamEnabled] animated:YES];
    self.notoficationsSwitch.on = [self.delegate areNotificationsEnabled];
//    [self.notoficationsSwitch setOn:[self.delegate areNotificationsEnabled] animated:YES];
    
    [self updateNotificationButton];
    
    self.manageNotificationsLabel.font = [UIFont boldSystemFontOfSize:20];
    self.manageNotificationsLabel.textColor = [UIColor whiteColor];
    self.manageNotificationsLabel.textAlignment = NSTextAlignmentCenter;
    
    if ([self.view isKindOfClass:[UITableView class]]) {

        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.contentMode = UIViewContentModeScaleToFill;
        
        UITableView *tableView = (UITableView *)self.view;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.opaque = YES;
        tableView.backgroundView = imageView;
    }
    
    [self updateWebcam];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.descriptionBox.bounds = CGRectMake(0, 0, self.view.bounds.size.width-20, 318);
    } else {
        self.descriptionBox.bounds = CGRectMake(0, 0, self.view.bounds.size.width-70, 318);
    }
    self.descriptionBox.text = @"This application has been developed to listen to Reading University's student web-radio.\n\rIt works best over Wifi and 3G as well as faster versions of GSM. In case you experience some streaming issues you can reduce the throughput by turning the high quality stream off.\n\rFurthermore you can have a quick peak into out studio. Update this webcam feed by tapping on it. Beware that it may take a while to load the image, so please be patient.";
    
    [(UITableView *)self.view reloadData];
    
    [self updateNotificationButton];
    
//    CGRect rect = self.webcam.frame;
//    rect.size = CGSizeMake(self.view.bounds.size.height-2, self.view.bounds.size.width-2);
//    self.webcam.frame = rect;
}

- (IBAction)switchFlicked:(UISwitch *)sender {
    NSLog(@"Switch...");
    switch (sender.tag) {
        case 0: // Quality
            [self.delegate setHeighStreamEnabled:sender.isOn];
            break;
            
        case 1: // Notifications
            [self.delegate setNotificationsEnabled:sender.isOn];
            break;
        default:
            break;
    }
    
    [self updateNotificationButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 6, self.view.bounds.size.width-40, 30);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.0];
    label.shadowColor = [UIColor colorWithRed:.0 green:.0 blue:.0 alpha:.0];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = sectionTitle;
    
    // Create header view and add label as a subview
    
    // you could also just return the label (instead of making a new view and adding the label as subview. With the view you have more flexibility to make a background color or different paddings
    UIView *view = [[UIView alloc] init];
    [view addSubview:label];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSString *sectionTitle = [self tableView:tableView titleForFooterInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 6, self.view.bounds.size.width, 17);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:.8 green:.8 blue:.8 alpha:1.0];
    label.shadowColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:.8];
    label.shadowOffset = CGSizeMake(0.0, 0.0);
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = sectionTitle;
    
    // Create header view and add label as a subview
    
    // you could also just return the label (instead of making a new view and adding the label as subview. With the view you have more flexibility to make a background color or different paddings
    UIView *view = [[UIView alloc] init];
    [view addSubview:label];
    view.contentMode = UIViewContentModeCenter;
    
    return view;
}

/*
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
 
    if (indexPath.section == 2 && indexPath.row == 0) {
        [self updateWebcam];
    }
}

- (void)updateWebcam
{
    // Start the thread's execution
    if (!self.updateImage.isExecuting) {
        
        // Reset the thread so that it can be restarted if it executed already
        self.updateImage = [[NSThread alloc] initWithTarget:self selector:@selector(updateWebcamThread) object:NULL];
        
        [self.loadingWebcam startAnimating];
        self.webcam.hidden = YES;
        [self.updateImage start];
    }
}

- (void)updateWebcamThread
{
    // Address to webcam feed
    //    NSString *webcamURL = @"http://junction11.rusu.co.uk/wp-content/uploads/2011/01/webcam1-31-300x225.jpg";
    NSString *webcamURL = @"http://media.junction11radio.co.uk/webcams/webcam1.jpg";
    
    // Make URL and load image
    NSURL *url = [NSURL URLWithString:webcamURL];
    NSError *error = nil;
    NSData *webcamData = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
    
    // Check for errors and if one occured replace image with placeholder
    UIImage *webcamImageRaw;
    if (error != nil) {
        webcamImageRaw = [UIImage imageNamed:@"not_found.jpg"];
    } else {
        webcamImageRaw = [UIImage imageWithData:webcamData];
    }
    
    // Apply image to background
    self.webcam.contentMode = UIViewContentModeScaleToFill;// = UIViewContentModeCenter;
    self.webcam.image = webcamImageRaw;
    
    // Stop the activity indicator
    self.webcam.hidden = NO;
    [self.loadingWebcam stopAnimating];
}

- (void)updateNotificationButton
{
    if (!self.notoficationsSwitch.on || [self.delegate numberOfNotifications] < 1) {
        
        [CustomButtons makeCellButtonWhite:self.manageNotifications];
        self.manageNotifications.userInteractionEnabled = NO;
    } else {
        [CustomButtons makeCellButtonGreen:self.manageNotifications];
        self.manageNotifications.userInteractionEnabled = YES;
    }
    
    if (!self.notoficationsSwitch.on) {
        self.manageNotificationsLabel.text = @"Reminders off";
    } else if ([self.delegate numberOfNotifications] <= 0) {
        self.manageNotificationsLabel.text = @"No reminders";
    } else if ([self.delegate numberOfNotifications] == 1){
        self.manageNotificationsLabel.text = [NSString stringWithFormat:@"%i reminder", [self.delegate numberOfNotifications]];
    } else {
        self.manageNotificationsLabel.text = [NSString stringWithFormat:@"%i reminders", [self.delegate numberOfNotifications]];
    }
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
//    
//    if (indexPath.section == 1 && indexPath.row == 0) {
//        self.manageNotifications.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"glossButton.png"] stretchableImageWithLeftCapWidth:20.0 topCapHeight:0.0]];
//        self.manageNotifications.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"glossButtonSelected.png"] stretchableImageWithLeftCapWidth:20.0 topCapHeight:0.0]];
//    }
//    return cell;
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showNotifications"]) {
        self.manageNotifications.selected = NO;
        if ([segue.destinationViewController isKindOfClass:[NotificationNavigationController class]]) {
            NotificationNavigationController *viewController = (NotificationNavigationController *)segue.destinationViewController;
            viewController.navigationBar.barStyle = UIBarStyleBlackOpaque;
            viewController.notificationsDelegate = self.delegate;
            viewController.button = self;
            
            
            if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
                UIStoryboardPopoverSegue *popover = (UIStoryboardPopoverSegue *)segue;
                viewController.popover = popover.popoverController;
            }
        }
    }
}
@end
