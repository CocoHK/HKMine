//
//  CEDrawView.m
//  DrawPractice
//
//  Created by Coco on 15/12/13.
//  Copyright (c) 2013 Coco. All rights reserved.
//

#import "HKDrawView.h"
#import "HKModels.h"

typedef NS_ENUM(NSUInteger, StateType) {
    StateTypeDefault = 0,
    StateTypeMine,
    StateTypeNumber,
    StateTypeEmpty,
};

@implementation HKDrawView

- (void)setupWithRowCount:(NSUInteger)rowCount
              columnCount:(NSUInteger)columnCount
               sideLength:(CGFloat)sideLength
                mineCount:(NSInteger)mineCount{
    self.rowCount = rowCount;
    self.columnCount = columnCount;
    self.sideLength = sideLength;
    [self resize];
    if (!self.cellsStates) {
        self.cellsStates = [NSMutableArray new];
    }
    else {
        [self.cellsStates removeAllObjects];
    }
    for (int i = 0; i < self.rowCount * self.columnCount; ++i) {
        HKCellState *cellState = [HKCellState new];
        [self.cellsStates addObject:cellState];
    }
    
    // random mines
    int addedMineCount = 0;
    while (addedMineCount < mineCount) {
        int randIndex = rand() % (self.rowCount * self.columnCount);
        HKCellState * mineCellState = self.cellsStates[randIndex];
        if (mineCellState.number != -1) {
            mineCellState.number = -1;
            ++ addedMineCount;
        }
    }
    
    for (int rowIndex = 0; rowIndex < self.rowCount; ++rowIndex) {
        for (int columnIndex = 0; columnIndex < self.columnCount; ++columnIndex) {
            HKCellState *cell = self.cellsStates[rowIndex * self.columnCount + columnIndex];
            if (cell.number != -1) {
                for (int rowOffset = -1; rowOffset <= 1; ++rowOffset) {
                    for (int columnOffset = -1; columnOffset <= 1; ++columnOffset) {
                        int nbRowIndex = rowOffset + rowIndex;
                        int nbColumnIndex = columnOffset + columnIndex;
                        
                        if (nbRowIndex >= 0 && nbRowIndex < self.rowCount &&
                            nbColumnIndex >= 0 && nbColumnIndex < self.columnCount) {
                            HKCellState *nbCellState = self.cellsStates[nbRowIndex * self.columnCount + nbColumnIndex];
                            if (nbCellState.number == -1) {
                                cell.number ++;
                            }
                        }
                    }
                }
            }
        }
    }
    
}

- (void)resize {
    CGRect newFrame = CGRectMake(0, 0, self.sideLength * self.columnCount , self.sideLength * self.rowCount);
    [self setFrame:newFrame];
    [self setNeedsDisplay];
}

- (void)drawSquare:(CGRect)bounds state:(StateType)state {
    UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRect:bounds];
    [[UIColor blackColor] setStroke];
    switch (state) {
        default:
        case StateTypeDefault:
            [[UIColor lightGrayColor] setFill];
            break;
        case StateTypeMine:
            [[UIColor redColor] setFill];
            break;
        case StateTypeNumber:
            [[UIColor greenColor] setFill];
            break;
        case StateTypeEmpty:
            [[UIColor whiteColor] setFill];
            break;
    }
    [rectanglePath fill];
    [rectanglePath stroke];
}

- (void)drawCellAtRowIndex:(NSUInteger)rowIndex columnIndex:(NSUInteger)columnIndex {
    StateType state;
    HKCellState *cellState = self.cellsStates[self.columnCount * rowIndex  + columnIndex];
    if (!cellState.hasPressed) {
        state = StateTypeDefault;
    }
    else {
        if (cellState.number == -1) {
            state = StateTypeMine;
        }
        else if (cellState.number == 0) {
            state = StateTypeEmpty;
        }
        else
            state = StateTypeNumber;
    }
    [self drawSquare:CGRectMake(self.sideLength * columnIndex,self.sideLength * rowIndex , self.sideLength, self.sideLength)
               state:state];
}

- (void)drawAllSquares {
    for (int i = 0; i < self.rowCount; ++i) {
        for (int j = 0; j < self.columnCount; ++j) {
            [self drawCellAtRowIndex:i columnIndex:j];
        }
    }
}


- (void)drawRect:(CGRect)rect {
    // for one cell
    if (CGSizeEqualToSize(CGSizeMake(self.sideLength, self.sideLength), rect.size)) {
        [self drawCellAtRowIndex:(rect.origin.y / self.sideLength) columnIndex:(rect.origin.x / self.sideLength)];
    }
    else {
        [self drawAllSquares];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches count] > 0) {
        UITouch *touch = [[touches allObjects] objectAtIndex:0];
        CGPoint location = [touch locationInView:self];
        CGFloat rowIdx = floor(location.y / self.sideLength);
        CGFloat columnIdx = floor(location.x / self.sideLength);

        if (rowIdx >= 0 && rowIdx < self.rowCount &&
            columnIdx >= 0 && columnIdx < self.columnCount) {
            //修改对应格子属性
            int index = self.columnCount * rowIdx + columnIdx;
            HKCellState *cellState = self.cellsStates[index];
            cellState.hasPressed = YES;
            
            [self setNeedsDisplayInRect:CGRectMake(self.sideLength * columnIdx, self.sideLength * rowIdx, self.sideLength, self.sideLength)];
        }
    }
}

@end
