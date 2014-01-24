//
//  HKPreferenceViewController.m
//  HKMine
//
//  Created by Coco on 18/01/14.
//  Copyright (c) 2014 Coco. All rights reserved.
//

#import "HKPreferenceViewController.h"
#import "DXTableViewModel.h"

#define kLevel @"kLevel"
#define kCustomLevelWidth @"kCustomLevelWidth"
#define kCustomLevelHeight @"kCustomLevelHeight"
#define kCustomLevelMine @"kCustomLevelMine"

typedef NS_ENUM(NSUInteger, GameLevel) {
    GameLevelEasy = 0,
    GameLevelMedium,
    GameLevelHard,
    GameLevelCustom,
};

@interface StyleValue1Cell : UITableViewCell @end

@implementation StyleValue1Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
}

@end


@interface HKPreferenceViewController ()
@property (strong, nonatomic) DXTableViewModel *tableViewModel;
@property (strong, nonatomic) NSMutableDictionary *dataSource;
@property (retain, nonatomic) UILabel *widthLabel;
@property (retain, nonatomic) UILabel *heightLabel;
@property (retain, nonatomic) UILabel *mineLabel;

@end

@implementation HKPreferenceViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataSource = [@{kLevel: @(GameLevelEasy),
                         kCustomLevelWidth:@(9),
                         kCustomLevelHeight:@(9),
                         kCustomLevelMine:@(10)} mutableCopy];
    NSIndexPath *selectedIndexPath;
    
    self.tableView.allowsSelectionDuringEditing = YES;
    self.title = @"Preference";
    self.tableViewModel.tableView = self.tableView;
    self.tableView.rowHeight = 45.0f;
    self.tableView.sectionHeaderHeight = 35.0f;
    
//    DXTableViewSection *customSection = [[DXTableViewSection alloc]initWithName:@"Custom"];
//    customSection.headerTitle = @"CUSTOM";
    
    DXTableViewSection *levelSection = [[DXTableViewSection alloc]initWithName:@"LEVEL"];
    levelSection.headerTitle = @"LEVEL";
    [self.tableViewModel addSection:levelSection];
    
    //levelEasyRow
    DXTableViewRow *levelEasyRow = [[DXTableViewRow alloc]initWithCellReuseIdentifier:@"EasyCell"];
    levelEasyRow.cellClass = [StyleValue1Cell class];
    levelEasyRow.cellForRowBlock = ^(DXTableViewRow *row) {
        StyleValue1Cell *cell = [row.tableView dequeueReusableCellWithIdentifier:row.cellReuseIdentifier];
        cell.textLabel.text = @"Easy";
        cell.detailTextLabel.text = @"9x9 10 mines";
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    };
    levelEasyRow.didSelectRowBlock = ^(DXTableViewRow *row) {
        UITableViewCell *cell = [row.tableView cellForRowAtIndexPath:row.rowIndexPath];
        NSLog(@"easy level row index is %i",[row.rowIndexPath indexAtPosition:[row.rowIndexPath length] -1]);
        cell.detailTextLabel.hidden = (cell.detailTextLabel.hidden == YES ? NO : YES);
        
        cell.accessoryType = cell.accessoryType == UITableViewCellAccessoryCheckmark ?
        UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
        [row.tableView deselectRowAtIndexPath:row.rowIndexPath animated:YES];
    };
    [levelSection addRow:levelEasyRow];
    
    //levelMediumRow
    DXTableViewRow *levelMediumRow = [[DXTableViewRow alloc]initWithCellReuseIdentifier:@"MediumCell"];
    levelMediumRow.cellClass = [StyleValue1Cell class];
    levelMediumRow.cellForRowBlock = ^(DXTableViewRow *row) {
        StyleValue1Cell *cell = [row.tableView dequeueReusableCellWithIdentifier:row.cellReuseIdentifier];
        cell.textLabel.text = @"Medium";
        cell.detailTextLabel.text = @"16x16 40 mines";
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    };
    levelMediumRow.didSelectRowBlock = ^(DXTableViewRow *row) {
        UITableViewCell *cell = [row.tableView cellForRowAtIndexPath:row.rowIndexPath];
        NSLog(@"Medium level row index is %i",[row.rowIndexPath indexAtPosition:[row.rowIndexPath length] -1]);

        cell.detailTextLabel.hidden = (cell.detailTextLabel.hidden == YES ? NO : YES);
        
        cell.accessoryType = cell.accessoryType == UITableViewCellAccessoryCheckmark ?
        UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
        [row.tableView deselectRowAtIndexPath:row.rowIndexPath animated:YES];
    };
    [levelSection addRow:levelMediumRow];
    
    //levelHardRow
    DXTableViewRow *levelHardRow = [[DXTableViewRow alloc]initWithCellReuseIdentifier:@"HardCell"];
    levelHardRow.cellClass = [StyleValue1Cell class];
    levelHardRow.cellForRowBlock = ^(DXTableViewRow *row) {
        StyleValue1Cell *cell = [row.tableView dequeueReusableCellWithIdentifier:row.cellReuseIdentifier];
        cell.textLabel.text = @"Hard";
        cell.detailTextLabel.text = @"16x30 99 mines";
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    };
    levelHardRow.didSelectRowBlock = ^(DXTableViewRow *row) {
        UITableViewCell *cell = [row.tableView cellForRowAtIndexPath:row.rowIndexPath];
        NSLog(@"hard level row index is %i",[row.rowIndexPath indexAtPosition:[row.rowIndexPath length] -1]);

        cell.detailTextLabel.hidden = (cell.detailTextLabel.hidden == YES ? NO : YES);
        
        cell.accessoryType = cell.accessoryType == UITableViewCellAccessoryCheckmark ?
        UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
        [row.tableView deselectRowAtIndexPath:row.rowIndexPath animated:YES];
    };
    [levelSection addRow:levelHardRow];
    
    //setWidthRow in Custom
    DXTableViewRow *setWidthRow = [[DXTableViewRow alloc] initWithCellReuseIdentifier:@"WidthCell"];
    setWidthRow.cellClass = [StyleValue1Cell class];
    setWidthRow.configureCellBlock = ^(DXTableViewRow *row, UITableViewCell *cell) {
        cell.textLabel.text = @"Width";
        
        UIStepper *widthStepper = [[UIStepper alloc] initWithFrame:CGRectMake(200, 7, 94, 29)];
        widthStepper.minimumValue = 9;
        widthStepper.maximumValue = 30;
        widthStepper.stepValue = 1;
        widthStepper.value = 20;
        self.widthLabel = [[UILabel alloc] initWithFrame:CGRectMake(106, 10, 40, 20)];
        self.widthLabel.text = [NSString stringWithFormat:@"%2.0f",widthStepper.value];
        [widthStepper addTarget:self action:@selector(widthValueChanged:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell addSubview:widthStepper];
        [cell addSubview:self.widthLabel];
    };
    
    //setHeightRow in Custom
    DXTableViewRow *setHeightRow = [[DXTableViewRow alloc] initWithCellReuseIdentifier:@"HeightCell"];
    setHeightRow.cellClass = [StyleValue1Cell class];
    setHeightRow.configureCellBlock = ^(DXTableViewRow *row, UITableViewCell *cell) {
        cell.textLabel.text = @"Height";
        
        UIStepper *heightStepper = [[UIStepper alloc] initWithFrame:CGRectMake(200, 7, 94, 29)];
        heightStepper.minimumValue = 9;
        heightStepper.maximumValue = 24;
        heightStepper.stepValue = 1;
        heightStepper.value = 16;
        self.heightLabel = [[UILabel alloc] initWithFrame:CGRectMake(106, 10, 40, 20)];
            self.heightLabel.text = [NSString stringWithFormat:@"%2.0f",heightStepper.value];
        
        [heightStepper addTarget:self action:@selector(heightValueChanged:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell addSubview:heightStepper];
        [cell addSubview:self.heightLabel];
    };
    
//    //setMineRow in Custom
//    DXTableViewRow *setMineRow = [[DXTableViewRow alloc] initWithCellReuseIdentifier:@"HeightCell"];
//    setMineRow.cellClass = [StyleValue1Cell class];
//    setMineRow.configureCellBlock = ^(DXTableViewRow *row, UITableViewCell *cell) {
//        cell.textLabel.text = @"Mine";
//        
//        UISlider *mineSlider = [[UISlider alloc] initWithFrame:CGRectMake(113, 5, 189, 34)];
//
//        self.heightLabel = [[UILabel alloc] initWithFrame:CGRectMake(106, 10, 40, 20)];
//        self.heightLabel.text = @"16";
//        [heightStepper addTarget:self action:@selector(heightValueChanged:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [cell addSubview:heightStepper];
//        [cell addSubview:self.heightLabel];
//    };
    
    //levelCustomRow
    DXTableViewRow *levelCustomRow = [[DXTableViewRow alloc]initWithCellReuseIdentifier:@"CustomCell"];
    levelCustomRow.cellClass = [UITableViewCell class];
    levelCustomRow.cellForRowBlock = ^(DXTableViewRow *row) {
        StyleValue1Cell *cell = [row.tableView dequeueReusableCellWithIdentifier:row.cellReuseIdentifier];
        cell.textLabel.text = @"Custom";
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    };
    levelCustomRow.didSelectRowBlock = ^(DXTableViewRow *row) {
        UITableViewCell *cell = [row.tableView cellForRowAtIndexPath:row.rowIndexPath];
        NSLog(@"custom level row index is %@",row.rowIndexPath);

        if (cell.accessoryType == UITableViewCellAccessoryNone) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;

            [levelSection insertRows:@[setWidthRow] afterRow:row withRowAnimation:UITableViewRowAnimationTop];
            [levelSection insertRows:@[setHeightRow] afterRow:setWidthRow withRowAnimation:UITableViewRowAnimationTop];

            NSLog(@"convert none to mark");
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [levelSection removeRow:setWidthRow];
            [levelSection removeRow:setHeightRow];
            self.heightLabel.text = @"";
            self.widthLabel.text = @"";

            [row.tableView reloadData];
            NSLog(@"convert mark to none");
        }
        [row.tableView deselectRowAtIndexPath:row.rowIndexPath animated:YES];

    };
    [levelSection addRow:levelCustomRow];


}

- (void)widthValueChanged:(UIStepper *)sender {
    double widthValue = [sender value];
    self.widthLabel.text = [NSString stringWithFormat:@"%2.0f",widthValue];
    
}

- (void)heightValueChanged:(UIStepper *)sender {
    double heightValue = [sender value];
    self.heightLabel.text = [NSString stringWithFormat:@"%2.0f",heightValue];
}


- (DXTableViewModel *)tableViewModel
{
    if (nil == _tableViewModel) {
        _tableViewModel = [[DXTableViewModel alloc] init];
    }
    return _tableViewModel;
}

- (DXTableViewRow *)newItemRow
{
    DXTableViewRow *row = [[DXTableViewRow alloc] initWithCellReuseIdentifier:@"ItemCell"];
    row.cellClass = [UITableViewCell class];
    row.configureCellBlock = ^(DXTableViewRow *row, UITableViewCell *cell) {
        cell.textLabel.text = @"Item";
    };
    return row;
}




@end
