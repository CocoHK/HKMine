//
//  CEViewController.h
//  DrawPractice
//
//  Created by Coco on 15/12/13.
//  Copyright (c) 2013 Coco. All rights reserved.
//

#import "HKBoardView.h"
#import "MZRSlideInMenu.h"

@interface HKViewController : UIViewController <UIScrollViewDelegate,HKBoardViewDelegate,UIAlertViewDelegate,MZRSlideInMenuDelegate> {
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIButton *restartBtn;
    IBOutlet UIBarButtonItem *optionBtn;
    IBOutlet UIBarButtonItem *statisticsBtn;
    IBOutlet UILabel *countTimeLabel;
    IBOutlet UILabel *showMineLabel;
    IBOutlet UIImageView *clockImageView;
    IBOutlet UIImageView *bombImageView;
}

@property (nonatomic, assign) IBOutlet HKBoardView *boardView;
//@property (nonatomic, assign) NSString *timeStr;
- (IBAction)startNewGame:(id)sender;

@end