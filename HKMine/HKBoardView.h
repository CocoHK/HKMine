//
//  HKBoardView.h
//  DrawPractice
//
//  Created by Coco on 15/12/13.
//  Copyright (c) 2013 Coco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKBoardView : UIView

@property (nonatomic, assign) NSUInteger rowCount, columnCount;
@property (nonatomic, assign) CGFloat sideLength;
@property (nonatomic, strong) NSMutableArray *cellsStates;

- (void)resize;
- (void)setupWithRowCount:(NSUInteger)rowCount
              columnCount:(NSUInteger)columnCount
               sideLength:(CGFloat)sideLength
                mineCount:(NSInteger)mineCount;
@end
