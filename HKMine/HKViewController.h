//
//  CEViewController.h
//  DrawPractice
//
//  Created by Coco on 15/12/13.
//  Copyright (c) 2013 Coco. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKDrawView;

@interface HKViewController : UIViewController {
    IBOutlet UIScrollView *scrollView;
}

@property (nonatomic, assign) IBOutlet HKDrawView *drawView;

@end