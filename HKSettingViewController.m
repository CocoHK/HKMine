//
//  HKSettingViewController.m
//  HKMine
//
//  Created by Coco on 02/02/14.
//  Copyright (c) 2014 Coco. All rights reserved.
//

#import "HKSettingViewController.h"
#define kLevel @"kLevel"
#define kCustomLevelWidth @"kCustomLevelWidth"
#define kCustomLevelHeight @"kCustomLevelHeight"
#define kCustomLevelMine @"kCustomLevelMine"

typedef NS_ENUM(NSUInteger, CellLevel) {
    CellLevelEasy = 0,
    CellLevelMedium,
    CellLevelHard,
    CellLevelCustom,
    CellLevelCustomWidth,
    CellLevelCustomHeight,
    CellLevelCustomMine,
};
@interface HKSettingViewController () {

}

@end

@implementation HKSettingViewController

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
    // Return the number of sections.
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionHeader = nil;
    switch (section) {
        case 0:
            sectionHeader = @"LEVEL";
            break;
        case 1:
            sectionHeader = @"OTHER";
            break;
        default:
            break;
    }
    return sectionHeader;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int rowNumber = 0;
    switch (section) {
        case 0:
        {
            int selectLevel = [[NSUserDefaults standardUserDefaults] integerForKey:kLevel];
            if (selectLevel == 3) {
                rowNumber = 7;
            }
            else {
                rowNumber = 4;
            }
        }
            break;
//        case 1:
//            rowNumber = 3;
//            break;
        default:
            break;
    }
    return rowNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case CellLevelEasy:
                case CellLevelMedium:
                case CellLevelHard:
                case CellLevelCustom:
                {
                    static NSString *levelCellIdentifier = @"levelCellIdentifier";
                    cell = [tableView dequeueReusableCellWithIdentifier:levelCellIdentifier];
                    if (cell == nil) {
                        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:levelCellIdentifier];
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    
                    static NSArray *levelTitles = nil;
                    static NSArray *detailTitles = nil;
                    if (!levelTitles)
                        levelTitles = @[@"Easy",@"Medium",@"Hard",@"Custom"];
                    if (!detailTitles)
                        detailTitles = @[@"9x9 10 mines",@"16x16 40 mines",@"16x30 99 mines",@""];

                    cell.textLabel.text = levelTitles[indexPath.row];
                    cell.detailTextLabel.text = detailTitles[indexPath.row];
                    int selectLevel = [[NSUserDefaults standardUserDefaults] integerForKey:kLevel];
                    if (indexPath.row == selectLevel) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else
                        cell.accessoryType = UITableViewCellAccessoryNone;
                }
                    break;
                 case CellLevelCustomWidth:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"CustomSizeCellIndentifier" ];
                    cell.textLabel.text = @"Width";
                    UIStepper *widthStepper = (UIStepper *)[cell viewWithTag:102];
                    widthStepper.minimumValue = 9;
                    widthStepper.maximumValue = 30;
                    widthStepper.stepValue = 1;
                    double widthValue = [[NSUserDefaults standardUserDefaults] doubleForKey:kCustomLevelWidth];
                    if (widthValue == 0) {
                        widthStepper.value = 20;
                        [[NSUserDefaults standardUserDefaults] setDouble:widthStepper.value forKey:kCustomLevelWidth];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                    else {
                        widthStepper.value = widthValue;
                    }
                    UILabel *widthLabel = (UILabel *) [cell viewWithTag:101];
                    widthLabel.text = [NSString stringWithFormat:@"%2.0f",widthStepper.value];

                }
                    break;
                case CellLevelCustomHeight:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"CustomSizeCellIndentifier"];
                    cell.textLabel.text = @"Height";

                    UIStepper *heightStepper = (UIStepper *)[cell viewWithTag:102];
                    heightStepper.minimumValue = 9;
                    heightStepper.maximumValue = 24;
                    heightStepper.stepValue = 1;
                    
                    double heightValue = [[NSUserDefaults standardUserDefaults] doubleForKey:kCustomLevelHeight];
                    if (heightValue == 0) {
                        heightStepper.value = 16;
                        [[NSUserDefaults standardUserDefaults] setDouble:heightStepper.value forKey:kCustomLevelHeight];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                    else {
                        heightStepper.value = heightValue;
                    }
                    UILabel *heightLabel = (UILabel *) [cell viewWithTag:101];
                    heightLabel.text = [NSString stringWithFormat:@"%2.0f",heightStepper.value];
                }
                    break;
                case CellLevelCustomMine:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"CustomMineCellIndentifier"];
                    cell.textLabel.text = @"Mine";
                    UISlider *mineSlider = (UISlider *)[cell viewWithTag:202];
                    mineSlider.minimumValue = 10;
                    double widthValue = [[NSUserDefaults standardUserDefaults] doubleForKey:kCustomLevelWidth];
                    double heightValue = [[NSUserDefaults standardUserDefaults] doubleForKey:kCustomLevelHeight];
                    mineSlider.maximumValue = (widthValue - 1) * (heightValue - 1);
                    double mineValue = [[NSUserDefaults standardUserDefaults] doubleForKey:kCustomLevelMine];
                    if (mineValue == 0) {
                        mineSlider.value = 10;
                        [[NSUserDefaults standardUserDefaults] setDouble:mineSlider.value forKey:kCustomLevelMine];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                    UILabel *mineLabel = (UILabel *)[cell viewWithTag:201];
                    mineLabel.text =  [NSString stringWithFormat:@"%2.0f",mineSlider.value];
                    
                }
                    break;
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row <= 3) {
        [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:kLevel];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.tableView reloadData];
    }
    
    
    
}

#pragma mark - Actions
- (IBAction)changeStepper:(UIStepper *)sender {
    //get index of selected row
    UIView *cellView = [sender superview];
    while (cellView && ![cellView isKindOfClass:[UITableViewCell class]]) {
        cellView = cellView.superview;
    }
    NSIndexPath *cellIndex = [self.tableView indexPathForCell:(UITableViewCell *)cellView];
    NSLog(@"cellIndex is %d",[cellIndex row]);
    
    if (cellIndex.row == CellLevelCustomWidth) {
        double widthValue = [sender value];
        [[NSUserDefaults standardUserDefaults] setDouble:widthValue forKey:kCustomLevelWidth];
    }
    else if (cellIndex.row == CellLevelCustomHeight) {
        double heightValue = [sender value];
        [[NSUserDefaults standardUserDefaults] setDouble:heightValue forKey:kCustomLevelHeight];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.tableView reloadData];
}

- (IBAction)changeSlider:(id)sender {
    
}

@end
