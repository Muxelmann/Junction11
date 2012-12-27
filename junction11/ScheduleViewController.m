//
//  ScheduleViewController.m
//  junction11
//
//  Created by Maximilian Zangs on 26.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import "ScheduleViewController.h"

@interface ScheduleViewController ()
@property (strong, nonatomic) Schedule *schedule;
@property (strong, nonatomic) ShowMenuViewController *show;
@property (strong, nonatomic) NSThread *updateSchedule;
@property (strong, nonatomic) NSIndexPath *selectedIndex;
@end

@implementation ScheduleViewController
@synthesize delegate = _delegate;
@synthesize schedule = _schedule;
@synthesize show = _show;
@synthesize updateSchedule = _updateSchedule;
@synthesize selectedIndex = _selectedIndex;

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
//    self.show = [self.storyboard instantiateViewControllerWithIdentifier:@"showMenuViewControllerID"];
//    self.show.view.backgroundColor = [UIColor redColor];
//    self.show.delegate = self;
    
    [self updateShows];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

//- (void)dealloc
//{
//    NSLog(@"Dealloc ScheduleViewController");
//    _schedule = nil;
//    _show = nil;
//    _updateSchedule = nil;
////    [super dealloc];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    NSLog(@"Searching Segue...");
    if ([segue.identifier isEqualToString:@"showShows"]) {
//        NSLog(@"showShows intercepted...");
        if ([segue.destinationViewController isKindOfClass:[ShowMenuViewController class]]) {
            ShowMenuViewController *viewController = segue.destinationViewController;
            viewController.delegate = self.delegate;
            viewController.dataSource = self;
            
            if ([sender isKindOfClass:[UITableViewCell class]]) {
                UITableViewCell *cell = sender;
                cell.selected = NO;
                
                self.selectedIndex = [(UITableView *)self.view indexPathForCell:cell];
                
//                NSLog(@"computed Index path %@", indexPath);
            }
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [self.schedule numberOfDaysInSchedule];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    return [self.schedule numberOfShowsPerDay:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
    UILabel *infoLabel = (UILabel *)[cell viewWithTag:2];
    UIImageView *socialImage = (UIImageView *)[cell viewWithTag:3];
    
    NSInteger show = indexPath.row;
    NSInteger day = indexPath.section;
    titleLabel.text = [self.schedule titleForShow:show onDay:day];
    infoLabel.text = [self.schedule infoForShow:show onDay:day];
    socialImage.hidden = ![self.schedule isLinkWithShow:show onDay:day];
    
    // Configure the cell...
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.schedule nameForDay:section];
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

- (Schedule *)schedule
{
    if (!_schedule) {
        _schedule = [[Schedule alloc] init];
    }
    return _schedule;
}

- (void)updateShows
{
    if (!self.updateSchedule.isExecuting) {
        
        self.updateSchedule = [[NSThread alloc] initWithTarget:self selector:@selector(updateShowsThread) object:nil];
        [self.updateSchedule start];
    }
}

- (void)updateShowsThread
{
    [self.schedule update];
    if ([self.view isKindOfClass:[UITableView class]])
        [(UITableView *)self.view reloadData];
}

#pragma mark ShowDataSource

- (NSString *)showTitle
{
    return [self.schedule titleForShow:self.selectedIndex.row onDay:self.selectedIndex.section];
}

- (BOOL)showHasURL
{
    return [self.schedule isLinkWithShow:self.selectedIndex.row onDay:self.selectedIndex.section];
}

- (NSString *)showInfo
{
    return [self.schedule infoForShow:self.selectedIndex.row onDay:self.selectedIndex.section];
}

- (NSString *)showDescription
{
    return [self.schedule descriptionForShow:self.selectedIndex.row onDay:self.selectedIndex.section];
}

- (NSString *)showURL
{
    return [self.schedule urlForShow:self.selectedIndex.row onDay:self.selectedIndex.section];
}

@end
