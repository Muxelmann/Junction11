//
//  NotificationsViewController.m
//  junction11
//
//  Created by Maximilian Zangs on 28.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import "NotificationsViewController.h"
#import "NotificationNavigationController.h"
#import "CustomButtons.h"

@interface NotificationsViewController ()

@property (weak, nonatomic) UIBarButtonItem *deleteAll;
@property (weak, nonatomic) IBOutlet UINavigationItem *bar;

@end

@implementation NotificationsViewController
@synthesize delegate = _delegate;
@synthesize deleteAll = _deleteAll;

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

    UIBarButtonItem* deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"Delete all" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteAll:)];
    deleteItem.tintColor = [UIColor redColor];
    self.navigationItem.rightBarButtonItem = deleteItem;
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    // Always one section
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.delegate numberOfNotifications];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
    if (titleLabel) {
        titleLabel.text = [self.delegate titleForNotificationAtIndex:indexPath.row];
    }
    
    UILabel *infoLabel = (UILabel *)[cell viewWithTag:2];
    if (infoLabel) {
        NSDate *date = [self.delegate timeForNotificationAtIndex:indexPath.row];

        NSString *text = @"On ";
        
        NSCalendar *gregorian = [NSCalendar currentCalendar];
        NSDateComponents *dateDifference = [[NSDateComponents alloc] init];
        dateDifference.day = 1 - gregorian.firstWeekday;
        
        date = [gregorian dateByAddingComponents:dateDifference toDate:date options:0];
        
        NSInteger weekday = [gregorian components:NSWeekdayCalendarUnit fromDate:date].weekday;

        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        text = [text stringByAppendingString:[format.weekdaySymbols objectAtIndex:weekday]];
        
        text = [text stringByAppendingString:@"s at "];
        
        infoLabel.text = [text stringByAppendingString:[NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.delegate unscheduleNotificationForTime:[self.delegate timeForNotificationAtIndex:indexPath.row]];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self.button updateNotificationButton];
        
        if ([self.delegate numberOfNotifications] < 1) {
            if ([self.parentViewController isKindOfClass:[NotificationNavigationController class]]) {
                NotificationNavigationController *navigationController = (NotificationNavigationController *)self.parentViewController;
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
                    [navigationController.popover dismissPopoverAnimated:YES];
                else {
                    [self doneButton:NULL];
                }
            }
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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
}

- (IBAction)deleteAll:(id)sender
{
    NSInteger i = [self.delegate numberOfNotifications];
    while (i > 0) {
        [self.delegate unscheduleNotificationForTime:[self.delegate timeForNotificationAtIndex:0]];
        i--;
    }
    
    [self.button updateNotificationButton];
    [self doneButton:NULL];
}

- (IBAction)doneButton:(id)sender
{
    [self viewWillDisappear:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        [self removeFromParentViewController];
    }];
}


@end
