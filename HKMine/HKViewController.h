//
//  CEViewController.h
//  DrawPractice
//
//  Created by Coco on 15/12/13.
//  Copyright (c) 2013 Coco. All rights reserved.
//

#import "HKBoardView.h"

@interface HKViewController : UIViewController <UIScrollViewDelegate,HKBoardViewDelegate,UIAlertViewDelegate> {
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIButton *restartBtn;
    IBOutlet UIBarButtonItem *preferenceBtn;
    IBOutlet UIBarButtonItem *statisticsBtn;
    IBOutlet UILabel *countTimeLabel;
}

@property (nonatomic, assign) IBOutlet HKBoardView *boardView;
//@property (nonatomic, assign) NSTimer *timer;
//@property (nonatomic, assign) NSString *timeStr;
- (IBAction)startNewGame:(id)sender;

@end