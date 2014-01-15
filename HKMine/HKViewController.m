//
//  CEViewController.m
//  DrawPractice
//
//  Created by Coco on 15/12/13.
//  Copyright (c) 2013 Coco. All rights reserved.
//

#import "HKViewController.h"
#import "HKBoardView.h"

@interface HKViewController ()

@end

@implementation HKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //和边框有15像素的距离
    [scrollView setContentInset:UIEdgeInsetsMake(15, 15, 15, 15)];
    self.boardView.delegate = self;
    [self startNewGame];
}

#pragma mark - Scroll View Manipulation

- (void)scrollViewSetup {
    scrollView.delegate = self;
    [scrollView setContentSize:self.boardView.frame.size];
    [self scrollViewUpdateMinZoomScale];
    scrollView.zoomScale = scrollView.minimumZoomScale;
}

- (void)scrollViewUpdateMinZoomScale {
    UIEdgeInsets contentInset = scrollView.contentInset;
    CGFloat minWidthScale = (CGRectGetWidth(scrollView.bounds) - contentInset.left - contentInset.right) / CGRectGetWidth(self.boardView.frame);
    CGFloat minHeightScale = (CGRectGetHeight(scrollView.bounds) - contentInset.bottom - contentInset.top) / CGRectGetHeight(self.boardView.frame);
    scrollView.minimumZoomScale = MIN(1, MIN(minWidthScale, minHeightScale));
}

- (void)scrollViewCenterContent {
    CGPoint newCenter;
    UIEdgeInsets contentInset = scrollView.contentInset;
    newCenter.x = MAX(CGRectGetWidth(self.boardView.frame), CGRectGetWidth(scrollView.frame) - contentInset.left - contentInset.right) / 2.0f;
    newCenter.y = MAX(CGRectGetHeight(self.boardView.frame), CGRectGetHeight(scrollView.frame) - contentInset.bottom - contentInset.top) / 2.0f;
    self.boardView.center = newCenter;
}

#pragma mark - Game Control

- (void)startNewGame {
    scrollView.zoomScale = 1;
    [self.boardView setupWithRowCount:9
                          columnCount:9
                           sideLength:32
                            mineCount:10];
    [self scrollViewSetup];
    self.boardView.userInteractionEnabled = YES;
}

#pragma mark - UIViewController

- (void)viewWillLayoutSubviews {
    [self scrollViewCenterContent];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.boardView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self scrollViewCenterContent];
}

#pragma mark - Actions

- (IBAction)startNewGame:(id)sender {
    [self startNewGame];
}

#pragma mark - HKBoardViewDelegate

- (void)mineDidPressed {
    scrollView.zoomScale = scrollView.minimumZoomScale;
}

- (void)win {
    UIAlertView *alertWin = [[UIAlertView alloc]initWithTitle:@"You win!" message:@"" delegate:self cancelButtonTitle:@"new game" otherButtonTitles:@"OK",nil];
    [alertWin show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self startNewGame];
    }
}
@end
