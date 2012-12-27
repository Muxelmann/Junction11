//
//  ShowViewController.m
//  junction11
//
//  Created by Maximilian Zangs on 26.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import "ShowViewController.h"

@interface ShowViewController ()
@end

@implementation ShowViewController
@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;

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

    NSLog(@"Show checks notifications:[%@]", ([self.delegate areNotificationsEnabled]) ? @"YES" : @"NO");
    
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
    NSInteger numberOfSections = 1;
    
    if ([self.delegate areNotificationsEnabled])
        numberOfSections++;
    
    if ([self.dataSource showHasURL])
        numberOfSections++;
    
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section == 0)
        return 2;
    else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier;
    
    switch (indexPath.section) {
        case 0: // Standard
            switch (indexPath.row) {
                case 0:
                    CellIdentifier = @"topCell";
                    break;
                    
                case 1:
                    CellIdentifier = @"textCell";
                    break;
            }
            break;
        case 1: // Notification or link...
            if ([self.delegate areNotificationsEnabled])
                CellIdentifier = @"notifyCell";
            else
                CellIdentifier = @"linkCell";
            break;
        case 2:
            CellIdentifier = @"linkCell";
            break;
        default:
            break;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
    if (titleLabel) {
        titleLabel.textAlignment = NSTextAlignmentRight;
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        titleLabel.text = [self.dataSource showTitle];
    }
    
    UILabel *infoLabel = (UILabel *)[cell viewWithTag:2];
    if (infoLabel) {
        infoLabel.textAlignment = NSTextAlignmentRight;
        infoLabel.textColor = [UIColor darkGrayColor];
        infoLabel.font = [UIFont italicSystemFontOfSize:15];
        infoLabel.text = [self.dataSource showInfo];
    }
    
    UITextView *descriptionTextField = (UITextView *)[cell viewWithTag:3];
    if (descriptionTextField) {
        descriptionTextField.backgroundColor = [UIColor clearColor];
        descriptionTextField.text = [self.dataSource showDescription];
    }
    
    UILabel *linkLabel = (UILabel *)[cell viewWithTag:4];
    if (linkLabel) {
        NSLog(@"%@", [self.dataSource showURL]);
        linkLabel.text = [self.dataSource showURL];
    }
    
    UILabel *notifyLabel = (UILabel *)[cell viewWithTag:5];
    if (notifyLabel) {
        notifyLabel.text = @"Notify Here";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: // Standard
            switch (indexPath.row) {
                case 0:
                    return 84.0;
                    break;
                    
                case 1:
                    return 150.0;
                    break;
            }
            break;
        case 1: // Notification or link...
            if ([self.delegate areNotificationsEnabled])
                return 46.0;
            else
                return 46.0;
            break;
        case 2:
            return 46.0;
            break;
    }
    
    return 46.0;
}

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
}

@end
