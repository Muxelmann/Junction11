//
//  OptionsViewController.m
//  junction11
//
//  Created by Maximilian Zangs on 26.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import "OptionsViewController.h"

@interface OptionsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *webcam;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingWebcam;
@property (weak, nonatomic) IBOutlet UITextView *descriptionBox;

@property (strong, nonatomic) NSThread *updateImage;

@end

@implementation OptionsViewController


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
    
    if ([self.view isKindOfClass:[UITableView class]]) {
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow_512.png"]];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.contentMode = UIViewContentModeScaleToFill;
        
        UITableView *tableView = (UITableView *)self.view;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.opaque = YES;
        tableView.backgroundView = imageView;
        
        [self updateWebcam];
    }
    
    self.descriptionBox.bounds = CGRectMake(0, 0, 239, 200);
    self.descriptionBox.text = @"This application has been developed to listen to Reading University's student web-radio.\n\rIt works best over Wifi and 3G as well as faster versions of GSM. In case you experience some streaming issues you can reduce the throughput by turning the high quality stream off.\n\rFurthermore you can have a quick peak into out studio. Update this webcam feed by tapping on it. Beware that it may take a while to load the image, so please be patient.";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    label.frame = CGRectMake(20, 6, 300, 30);
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
    label.frame = CGRectMake(0, 6, 259, 17);
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
    
    if (indexPath.section == 1 && indexPath.row == 0) {
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
    
    // Converting Image to fit perfectly
    CGSize imageSize = CGSizeMake(229, 170); // height & width - 2
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageSize.width, imageSize.height), NO, 0.0);
    [webcamImageRaw drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    UIImage *webcamImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Apply image to background
    CGRect rect = self.webcam.bounds;
    rect.size = imageSize;
    self.webcam.bounds = rect;
    self.webcam.contentMode = UIViewContentModeCenter;
    self.webcam.image = webcamImage;
    
    // Stop the activity indicator
    self.webcam.hidden = NO;
    [self.loadingWebcam stopAnimating];
}

@end
