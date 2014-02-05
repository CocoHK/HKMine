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
}

@property (nonatomic, assign) IBOutlet HKBoardView *boardView;

- (IBAction)startNewGame:(id)sender;

@end