//
//  HKPreferenceViewController.m
//  HKMine
//
//  Created by Coco on 18/01/14.
//  Copyright (c) 2014 Coco. All rights reserved.
//

#import "HKPreferenceViewController.h"
#import "DXTableViewModel.h"

@interface StyleValue1Cell : UITableViewCell @end

@implementation StyleValue1Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
}

@end


@interface HKPreferenceViewController ()
@property (strong, nonatomic) DXTableViewModel *tableViewModel;

@end

@implementation HKPreferenceViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.allowsSelectionDuringEditing = YES;
    self.title = @"Preference";
    self.tableViewModel.tableView = self.tableView;
    self.tableView.rowHeight = 45.0f;
    self.tableView.sectionHeaderHeight = 35.0f;
    
    DXTableViewSection *customSection = [[DXTableViewSection alloc]initWithName:@"Custom"];
    customSection.headerTitle = @"CUSTOM";
//    levelSection.headerHeight = 35.0f;
    
    
    DXTableViewSection *levelSection = [[DXTableViewSection alloc]initWithName:@"LEVEL"];
    levelSection.headerTitle = @"LEVEL";
//    levelSection.headerHeight = 35.0f;
    self.tableView.rowHeight = 45.0f;
    [self.tableViewModel addSection:levelSection];
    
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
        cell.detailTextLabel.hidden = (cell.detailTextLabel.hidden == YES ? NO : YES);
        
        cell.accessoryType = cell.accessoryType == UITableViewCellAccessoryCheckmark ?
        UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
        [row.tableView deselectRowAtIndexPath:row.rowIndexPath animated:YES];
    };
    [levelSection addRow:levelEasyRow];
    
    
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
        cell.detailTextLabel.hidden = (cell.detailTextLabel.hidden == YES ? NO : YES);
        
        cell.accessoryType = cell.accessoryType == UITableViewCellAccessoryCheckmark ?
        UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
        [row.tableView deselectRowAtIndexPath:row.rowIndexPath animated:YES];
    };
    [levelSection addRow:levelMediumRow];

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
        cell.detailTextLabel.hidden = (cell.detailTextLabel.hidden == YES ? NO : YES);
        
        cell.accessoryType = cell.accessoryType == UITableViewCellAccessoryCheckmark ?
        UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
        [row.tableView deselectRowAtIndexPath:row.rowIndexPath animated:YES];
    };
    [levelSection addRow:levelHardRow];

    DXTableViewRow *levelCustomRow = [[DXTableViewRow alloc]initWithCellReuseIdentifier:@"CustomCell"];
    levelCustomRow.cellClass = [UITableViewCell class];
    levelCustomRow.cellForRowBlock = ^(DXTableViewRow *row) {
        StyleValue1Cell *cell = [row.tableView dequeueReusableCellWithIdentifier:row.cellReuseIdentifier];
        cell.textLabel.text = @"Custom";
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    };
    levelCustomRow.didSelectRowBlock = ^(DXTableViewRow *row) {
//        [row.tableViewModel beginUpdates];

        UITableViewCell *cell = [row.tableView cellForRowAtIndexPath:row.rowIndexPath];
        if (cell.accessoryType == UITableViewCellAccessoryNone) {

            cell.accessoryType = UITableViewCellAccessoryCheckmark;
//            [self.tableViewModel addSection:customSection];
            NSLog(@"convert none to mark");
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
//            [self.tableViewModel removeSection:customSection];
            NSLog(@"convert mark to none");

        }
//        [row.tableViewModel endUpdates];
        [row.tableView deselectRowAtIndexPath:row.rowIndexPath animated:YES];

    };
    [levelSection addRow:levelCustomRow];
    
    
//    DXTableViewRow *typeinWidthRow = [[DXTableViewRow alloc] initWithCellReuseIdentifier:@"WidthCell"];
//    typeinWidthRow.editingStyle = UITableViewCellEditingStyleInsert;
//    addRow.cellClass = [UITableViewCell class];
//    addRow.configureCellBlock = ^(DXTableViewRow *row, UITableViewCell *cell) {
//        cell.textLabel.text = @"Add Item";
//    };
//    void (^addItemActionBlock)() = ^(DXTableViewRow *row) {
//        [editableSection insertRows:@[[self newItemRow]] afterRow:row withRowAnimation:UITableViewRowAnimationRight];
//        [row.tableView deselectRowAtIndexPath:row.rowIndexPath animated:YES];
//    };
//    addRow.didSelectRowBlock = addItemActionBlock;
//    addRow.commitEditingStyleForRowBlock = addItemActionBlock;
//    [editableSection addRow:addRow];

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
