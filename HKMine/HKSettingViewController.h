//
//  HKSettingViewController.h
//  HKMine
//
//  Created by Coco on 02/02/14.
//  Copyright (c) 2014 Coco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKSettingViewController : UITableViewController

- (IBAction)changeStepper:(id)sender;
- (IBAction)changeSlider:(id)sender;
- (IBAction)changeSwitch:(id)sender;

@property(nonatomic,assign) BOOL needSound;
@property(nonatomic,assign) BOOL needShake;
@end
