//
//  HKModel.h
//  DrawPractice
//
//  Created by Coco on 27/12/13.
//  Copyright (c) 2013 Coco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKCellState : NSObject

typedef NS_ENUM(int, CellAttribute) {
    CellCovered = 0,
    CellStateDigged,
    CellStateMarked,
};

@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) int CellAttribute;

@end
