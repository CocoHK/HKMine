//
//  HKSettingViewController.m
//  HKMine
//
//  Created by Coco on 02/02/14.
//  Copyright (c) 2014 Coco. All rights reserved.1
//

#import "HKSettingViewController.h"
#import "HKAppDelegate.h"
#import "HKDataMgr.h"

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
    HKDataMgr *dataMgr;
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
    // Return the number of sections.
    return 2;
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
            int selectLevel = [dataMgr integerForKey:kLevel];
            if (selectLevel < 3) {
                rowNumber = 4;
            }
            else {
                rowNumber = 7;
            }
        }
            break;
        case 1:
            rowNumber = 3;
            break;
        default:
            break;
    }
    return rowNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0://section 0
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
                    
                    int selectLevel = [dataMgr integerForKey:kLevel];
                    
                    if (indexPath.row == selectLevel)
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    else
                        cell.accessoryType = UITableViewCellAccessoryNone;
                }
                    break;
                case CellLevelCustomWidth:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"CustomSizeCellIndentifier"];
                    cell.textLabel.text = @"Width";
                    UIStepper *widthStepper = (UIStepper *)[cell viewWithTag:102];
                    widthStepper.minimumValue = 9;
                    widthStepper.maximumValue = 30;
                    widthStepper.stepValue = 1;
                    int widthValue = [[NSUserDefaults standardUserDefaults] integerForKey:kCustomLevelWidth];
                    widthStepper.value = widthValue;
                    
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
                    
                    double heightValue = [[NSUserDefaults standardUserDefaults] integerForKey:kCustomLevelHeight];
                    heightStepper.value = heightValue;
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
                    int widthValue = [[NSUserDefaults standardUserDefaults] integerForKey:kCustomLevelWidth];
                    int heightValue = [[NSUserDefaults standardUserDefaults] integerForKey:kCustomLevelHeight];
                    mineSlider.maximumValue = (widthValue - 1) * (heightValue - 1);
                    int mineValue = [[NSUserDefaults standardUserDefaults] integerForKey:kCustomLevelMine];
                    
                    mineSlider.value = mineValue;
                    UILabel *mineLabel = (UILabel *)[cell viewWithTag:201];
                    mineLabel.text =  [NSString stringWithFormat:@"%2.0f",mineSlider.value];
                    
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1://section 1
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCellIndentifier"];
            static NSArray *section1Array = nil;
            if (!section1Array) {
                section1Array = @[@"Sounds",@"Vibration",@"Game Center"];
            }
            cell.textLabel.text = section1Array[indexPath.row];
            UISwitch *aSwitch = (UISwitch *)[cell viewWithTag:301];
            aSwitch.on = YES;
            
        }
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int lastSelectLevel = [dataMgr integerForKey:kLevel];
    
    
    if (lastSelectLevel == indexPath.row) {
        return;
    }

    //新增，把当前难度存在appdelegate中
    [dataMgr setInteger:indexPath.row forKey:kLevel];
    if (indexPath.row <= 2) {
        if (lastSelectLevel == 3) {
            NSIndexPath *path1 = [NSIndexPath indexPathForRow:CellLevelCustomWidth inSection:0];
            NSIndexPath *path2 = [NSIndexPath indexPathForRow:CellLevelCustomHeight inSection:0];
            NSIndexPath *path3 = [NSIndexPath indexPathForRow:CellLevelCustomMine inSection:0];
            NSArray *indexArray = @[path1,path2,path3];
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastSelectLevel inSection:0], indexPath]
                                  withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }
        static NSArray *setWidthArray = nil;
        static NSArray *setHeightArray = nil;
        static NSArray *setMineArray = nil;
        if (!setWidthArray)
            setWidthArray = @[@(9),@(16),@(16)];
        if (!setHeightArray)
            setHeightArray = @[@(9),@(16),@(30)];
        if (!setMineArray)
            setMineArray = @[@(10),@(40),@(99)];

        [[NSUserDefaults standardUserDefaults] setInteger:[setWidthArray[indexPath.row] intValue] forKey:kCustomLevelWidth];
        [[NSUserDefaults standardUserDefaults] setInteger:[setHeightArray[indexPath.row] intValue] forKey:kCustomLevelHeight];
        [[NSUserDefaults standardUserDefaults] setInteger:[setMineArray [indexPath.row] intValue] forKey:kCustomLevelMine];
        [self.tableView reloadData];
    }
    else if (indexPath.row == 3 && lastSelectLevel != 3) {
        NSIndexPath *path1 = [NSIndexPath indexPathForRow:CellLevelCustomWidth inSection:0];
        NSIndexPath *path2 = [NSIndexPath indexPathForRow:CellLevelCustomHeight inSection:0];
        NSIndexPath *path3 = [NSIndexPath indexPathForRow:CellLevelCustomMine inSection:0];
        NSArray *indexArray = @[path1,path2,path3];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastSelectLevel inSection:0], indexPath]
                              withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
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
    if (cellIndex.row == CellLevelCustomWidth) {
        int widthValue = [sender value];
        [[NSUserDefaults standardUserDefaults] setInteger:widthValue forKey:kCustomLevelWidth];
        NSLog(@"userDefaults width is %d",widthValue);
        
    }
    else if (cellIndex.row == CellLevelCustomHeight) {
        int heightValue = [sender value];
        [[NSUserDefaults standardUserDefaults] setInteger:heightValue forKey:kCustomLevelHeight];
        NSLog(@"userDefaults height is %d",heightValue);
        
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.tableView reloadData];
    
}

- (IBAction)changeSlider:(UISlider *)sender {
    int mineValue = [sender value];
    [[NSUserDefaults standardUserDefaults] setInteger:mineValue forKey:kCustomLevelMine];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.tableView reloadData];
    NSLog(@"userDefaults mine is %i",mineValue);
    
}

- (IBAction)changeSwitch:(UISwitch *)sender {
    BOOL ifOn = sender.on;
}

@end
