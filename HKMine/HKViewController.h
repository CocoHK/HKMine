//
//  CEViewController.h
//  DrawPractice
//
//  Created by Coco on 15/12/13.
//  Copyright (c) 2013 Coco. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKBoardView;

@interface HKViewController : UIViewController <UIScrollViewDelegate> {
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIButton *restartBtn;
}

@property (nonatomic, assign) IBOutlet HKBoardView *boardView;

- (IBAction)startNewGame:(id)sender;
@end