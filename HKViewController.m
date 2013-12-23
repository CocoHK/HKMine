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

- (void)setupDrawView {
    self.drawView.rowCount = 16;
    self.drawView.columnCount = 16;
    self.drawView.sideLength = 32;
    [self.drawView resize];
}

- (void)setupScrollView {
    [scrollView setContentSize:self.drawView.frame.size];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDrawView];
    [self setupScrollView];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.drawView resize];
}

@end
