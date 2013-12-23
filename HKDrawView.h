//
//  CEDrawView.h
//  DrawPractice
//
//  Created by Coco on 15/12/13.
//  Copyright (c) 2013 Coco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKDrawView : UIView

@property (nonatomic, assign) NSUInteger rowCount, columnCount;
@property (nonatomic, assign) CGFloat sideLength;

- (CGSize)resize;

@end
