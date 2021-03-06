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
#define kNeedSound @"kNeedSound"
#define kNeedVibration @"kNeedVibration"

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
            NSInteger selectLevel = [dataMgr integerForKey:kLevel];
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
                    
                    NSInteger selectLevel = [dataMgr integerForKey:kLevel];
                    
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
                    widthStepper.value = [dataMgr integerForKey:kCustomLevelWidth];
                    
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
                    
                    double heightValue = [dataMgr integerForKey:kCustomLevelHeight];
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
                    NSInteger widthValue = [dataMgr integerForKey:kCustomLevelWidth];
                    NSInteger heightValue =[dataMgr integerForKey:kCustomLevelHeight];
                    mineSlider.maximumValue = (widthValue - 1) * (heightValue - 1);
                    NSInteger mineValue = [dataMgr integerForKey:kCustomLevelMine];
                    
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

            switch (indexPath.row) {

                case 0:
                {
                   BOOL addSound = [dataMgr boolForKey:kNeedSound];
                    aSwitch.on = addSound;
                    NSLog(@"switch if is on %@",aSwitch.on?@"YES":@"NO");
                }
                    break;
                case 1:
                {
                    BOOL addVibration = [dataMgr boolForKey:kNeedVibration];
                    aSwitch.on = addVibration;
                }
                    break;
                default:
                    break;
            }
            
        }
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger lastSelectLevel = [dataMgr integerForKey:kLevel];
    
    
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

        [dataMgr setInteger:[setWidthArray[indexPath.row] intValue] forKey:kCustomLevelWidth];
        [dataMgr setInteger:[setHeightArray[indexPath.row] intValue] forKey:kCustomLevelHeight];
        [dataMgr setInteger:[setMineArray [indexPath.row] intValue] forKey:kCustomLevelMine];
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
        [dataMgr setInteger:widthValue forKey:kCustomLevelWidth];
        NSLog(@"userDefaults width is %d",widthValue);
        
    }
    else if (cellIndex.row == CellLevelCustomHeight) {
        int heightValue = [sender value];
        [dataMgr setInteger:heightValue forKey:kCustomLevelHeight];
        NSLog(@"userDefaults height is %d",heightValue);
        
    }
    [self.tableView reloadData];
    
}

- (IBAction)changeSlider:(UISlider *)sender {
    int mineValue = [sender value];
    [dataMgr setInteger:mineValue forKey:kCustomLevelMine];
    [self.tableView reloadData];
    NSLog(@"userDefaults mine is %i",mineValue);
    
}

- (IBAction)changeSwitch:(UISwitch *)sender {
    //get index of selected row
    UIView *cellView = [sender superview];
    while (cellView && ![cellView isKindOfClass:[UITableViewCell class]]) {
        cellView = cellView.superview;
    }
    NSIndexPath *cellIndex = [self.tableView indexPathForCell:(UITableViewCell *)cellView];
    if (cellIndex.row == 0) {
        [dataMgr willChangeValueForKey:kNeedSound];
        [dataMgr setBool:sender.on forKey:kNeedSound];
        [dataMgr didChangeValueForKey:kNeedSound];
        NSLog(@"addSound is %@",[dataMgr boolForKey:kNeedSound]?@"yes":@"no");
        
    }
    else if (cellIndex.row == 1) {
        [dataMgr setBool:sender.on forKey:kNeedVibration];
        NSLog(@"addVibration is %@",sender.on?@"yes":@"no");
    }
}

@end
