//
//  HKStatisticsViewController.m
//  HKMine
//
//  Created by Coco on 05/02/14.
//  Copyright (c) 2014 Coco. All rights reserved.
//

#import "HKStatisticsViewController.h"

@interface HKStatisticsViewController ()

@end

@implementation HKStatisticsViewController

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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = nil;
    switch (section) {
        case 0:
            sectionTitle = @"EASY";
            break;
        case 1:
            sectionTitle = @"MEDIUM";
            break;
        case 2:
            sectionTitle = @"HARD";
            break;
        default:
            break;
    }
    return sectionTitle;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.row <= 6) {
        static NSString *StatisticsCellIdentifier = @"StatisticsCellIdentifier";
        cell = [tableView dequeueReusableCellWithIdentifier:StatisticsCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:StatisticsCellIdentifier];
        }
        static NSArray *statisticsTitles = nil;
        static NSArray *statisticsDetailTitles = nil;
        if (!statisticsTitles)
            statisticsTitles = @[@"最佳时间",@"Games played",@"Games won",@"Rate",@"Longest winning streak",@"Longest losing streak",@"Current streak"];
        if (!statisticsDetailTitles)
            statisticsDetailTitles = @[@"date",@"value",@"value",@"value",@"value",@"value",@"value"];
        cell.textLabel.text = statisticsTitles[indexPath.row];
        cell.detailTextLabel.text = statisticsDetailTitles[indexPath.row];
        cell.userInteractionEnabled = NO;
    }
    else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"ResetCellIndentifier"];
            UIButton *resetBtn = (UIButton *)[cell viewWithTag:100];
            resetBtn.titleLabel.text = @"Reset";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int height;
    if (indexPath.row <= 6)
        height = 33;
    else
        height = 43;
    return height;
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
