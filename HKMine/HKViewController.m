//
//  CEViewController.m
//  DrawPractice
//
//  Created by Coco on 15/12/13.
//  Copyright (c) 2013 Coco. All rights reserved.
//

#import "HKViewController.h"
#import "HKDrawView.h"

@interface HKViewController ()

@end

@implementation HKViewController

- (void)setupScrollView {
    [scrollView setContentSize:self.drawView.frame.size];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.drawView setupWithRowCount:16 columnCount:16 sideLength:32.0 mineCount:40];
    [self setupScrollView];
    
    // 让scollView和边有20像素的距离
    [scrollView setContentInset:UIEdgeInsetsMake(20, 20, 20, 20)];

}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.drawView resize];
}

- (IBAction)restartDrawView:(id)sender {
    [self.drawView setupWithRowCount:16 columnCount:16 sideLength:32.0 mineCount:40];
    [self setupScrollView];
    
    // 让scollView和边有20像素的距离
    [scrollView setContentInset:UIEdgeInsetsMake(20, 20, 20, 20)];
    self.drawView.userInteractionEnabled = YES;
}
@end
