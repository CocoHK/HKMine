//
//  HKStatisticsViewController.m
//  HKMine
//
//  Created by Coco on 05/02/14.
//  Copyright (c) 2014 Coco. All rights reserved.
//

#import "HKStatisticsViewController.h"
#import "HKDataMgr.h"



@interface HKStatisticsViewController ()

@end

@implementation HKStatisticsViewController {
    HKDataMgr *dataMgr;
}

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
    dataMgr = [HKDataMgr shared];
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
        NSArray *statisticsDetailTitles = nil;
        if (!statisticsTitles)
            statisticsTitles = @[@"Best time",@"Games played",@"Games won",@"Percentage",@"Longest winning streak",@"Longest losing streak",@"Current streak"];
        if (!statisticsDetailTitles) {
            NSMutableDictionary *infoDict = [[dataMgr statisticsForLevel:indexPath.section] mutableCopy];

            statisticsDetailTitles = @[[NSString stringWithFormat:@"%.1f s",[infoDict[kBestTime] doubleValue]/10],
                                       [infoDict[kGamePlayed] stringValue] ?: @"0",
                                       [infoDict[kGameWon] stringValue] ?: @"0",
                                       infoDict[kPercentage] ?: @"0%",
                                       [infoDict[kLWinStreak] stringValue] ?: @"0",
                                       [infoDict[kLLoseStreak] stringValue] ?: @"0",
                                       [infoDict[kCurrentStreak] stringValue] ?: @"0"];
        }
        cell.textLabel.text = statisticsTitles[indexPath.row];
        cell.detailTextLabel.text = statisticsDetailTitles[indexPath.row];
        cell.userInteractionEnabled = NO;
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ResetCellIndentifier"];
        UIButton *resetBtn = (UIButton *)[cell viewWithTag:100];
        resetBtn.titleLabel.text = @"Reset";
        [resetBtn addTarget:self action:@selector(resetBtnAction:) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - Actions

- (IBAction)resetBtnAction:(id)sender {
    //get index of selected row
    UIView *cellView = [sender superview];
    while (cellView && ![cellView isKindOfClass:[UITableViewCell class]]) {
        cellView = cellView.superview;
    }
    NSIndexPath *cellIndex = [self.tableView indexPathForCell:(UITableViewCell *)cellView];
    [dataMgr resetDict:cellIndex.section];
    [self.tableView reloadData];
}

@end
