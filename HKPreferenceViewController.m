//
//  HKPreferenceViewController.m
//  HKMine
//
//  Created by Coco on 18/01/14.
//  Copyright (c) 2014 Coco. All rights reserved.
//

#import "HKPreferenceViewController.h"

@interface HKPreferenceViewController ()

@end

@implementation HKPreferenceViewController

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
    self.title = @"Preference";
    DAModularTableSection *levelSection = [DAModularTableSection section];
    levelSection.headerTitle = @"LEVEL";
    levelSection.headerHeight = 35.0f;
    self.tableView.rowHeight = 45.0f;

    [self.tableView insertSection:levelSection];
    
    DAModularTableRow *levelEasyRow = [DAModularTableRow row];
    levelEasyRow.text = @"Easy";
    levelEasyRow.detailText = @"9*9 10 mines";
    levelEasyRow.cellStyle = UITableViewCellStyleValue1;
    levelEasyRow.accessoryType = UITableViewCellAccessoryNone;
    levelEasyRow.didSelectBlock = ^(NSIndexPath *indexPath) {
        DAModularTableRow *tableRow = [self.tableView rowAtIndexPath:indexPath];
        tableRow.cellStyle = (tableRow.cellStyle == UITableViewCellStyleValue1 ? UITableViewCellStyleDefault : UITableViewCellStyleValue1);
        tableRow.accessoryType = (tableRow.accessoryType == UITableViewCellAccessoryCheckmark ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark);
        [self.tableView reloadRow:tableRow animated:YES];
    };
    [self.tableView insertRow:levelEasyRow];
    
    DAModularTableRow *levelMediumRow = [DAModularTableRow row];
    levelMediumRow.text = @"Medium";
    levelMediumRow.detailText = @"16*16 40 mines";
    levelMediumRow.cellStyle = UITableViewCellStyleValue1;
    levelMediumRow.accessoryType = UITableViewCellAccessoryNone;
    levelMediumRow.didSelectBlock = ^(NSIndexPath *indexPath) {
        DAModularTableRow *tableRow = [self.tableView rowAtIndexPath:indexPath];
        tableRow.cellStyle = (tableRow.cellStyle == UITableViewCellStyleValue1 ? UITableViewCellStyleDefault : UITableViewCellStyleValue1);
        tableRow.accessoryType = (tableRow.accessoryType == UITableViewCellAccessoryCheckmark ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark);
        [self.tableView reloadRow:tableRow animated:YES];
    };
    [self.tableView insertRow:levelMediumRow];
    
    DAModularTableRow *levelHardRow = [DAModularTableRow row];
    levelHardRow.text = @"Hard";
    levelHardRow.detailText = @"16*30 99 mines";
    levelHardRow.cellStyle = UITableViewCellStyleValue1;
    levelHardRow.accessoryType = UITableViewCellAccessoryNone;
    levelHardRow.didSelectBlock = ^(NSIndexPath *indexPath) {
        DAModularTableRow *tableRow = [self.tableView rowAtIndexPath:indexPath];
        tableRow.cellStyle = (tableRow.cellStyle == UITableViewCellStyleValue1 ? UITableViewCellStyleDefault : UITableViewCellStyleValue1);
        tableRow.accessoryType = (tableRow.accessoryType == UITableViewCellAccessoryCheckmark ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark);
        [self.tableView reloadRow:tableRow animated:YES];
    };
    [self.tableView insertRow:levelHardRow];
    
    DAModularTableRow *levelCustomRow = [DAModularTableRow row];
    levelCustomRow.text = @"Custom";
    levelCustomRow.rowHeight = 45.0f;
    levelCustomRow.didSelectBlock = ^(NSIndexPath *indexPath) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        DAModularTableRow *tableRow = [self.tableView rowAtIndexPath:indexPath];
        tableRow.rowHeight = (tableRow.rowHeight == 45.0f ? 200.0f : 45.0f);
        
        
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    };
    [self.tableView insertRow:levelCustomRow];

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
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

@end
