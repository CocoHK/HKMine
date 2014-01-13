//
//  HKBoardView.m
//  DrawPractice
//
//  Created by Coco on 15/12/13.
//  Copyright (c) 2013 Coco. All rights reserved.
//

#import "HKBoardView.h"
#import "HKModels.h"

typedef NS_ENUM(NSUInteger, StateType) {
    StateTypeDefault = 0,
    StateTypeMine,
    StateTypeNumber,
    StateTypeEmpty,
};

@implementation HKBoardView

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
    srand(time(0)); // 用当前时间设置rand()的种子
    while (addedMineCount < mineCount) {
        int randIndex = rand() % (self.rowCount * self.columnCount);
        HKCellState * mineCellState = self.cellsStates[randIndex];
        if (mineCellState.number != -1) {
            mineCellState.number = -1;
            ++ addedMineCount;
        }
    }
    
    // count cell number
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

- (void)drawSquare:(CGRect)bounds state:(StateType)state cellNumber:(NSUInteger)cellNumber {
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
        case StateTypeEmpty:
            [[UIColor whiteColor] setFill];
            break;
    }
    [rectanglePath fill];
    [rectanglePath stroke];
    
    if (state == StateTypeNumber) {
        UIColor *numberColor;
        switch (cellNumber) {
            default:
            case 1:
                numberColor = [UIColor colorWithRed:44/255.0f green:69/255.0f blue:174/255.0f alpha:1];
                break;
            case 2:
                numberColor = [UIColor colorWithRed:49/255.0f green:87/255.0f blue:13/255.0f alpha:1];

                break;
            case 3:
                numberColor = [UIColor colorWithRed:137/255.0f green:27/255.0f blue:27/255.0f alpha:1];
                break;
            case 4:
                numberColor = [UIColor colorWithRed:0/255.0f green:18/255.0f blue:108/255.0f alpha:1];
                break;
            case 5:
                numberColor = [UIColor colorWithRed:110/255.0f green:40/255.0f blue:42/255.0f alpha:1];
                break;
            case 6:
                numberColor = [UIColor colorWithRed:78/255.0f green:20/255.0f blue:84/255.0f alpha:1];
                break;
            case 7:
                numberColor = [UIColor colorWithRed:49/255.0f green:112/255.0f blue:81/255.0f alpha:1];
                break;
            case 8:
                numberColor = [UIColor colorWithRed:80/255.0f green:38/255.0f blue:16/255.0f alpha:1];
                break;
        }
        int margin = 5;
        UIFont *font = [UIFont fontWithName:@"Apple SD Gothic Neo" size:MAX(8, self.sideLength - margin - margin)];
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        NSDictionary *attributes = @{ NSFontAttributeName: font,
                                      NSParagraphStyleAttributeName: paragraphStyle,
                                      NSForegroundColorAttributeName:numberColor};
        [[@(cellNumber) stringValue] drawInRect:CGRectInset(bounds, margin, margin) withAttributes:attributes];
    }
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
        else {
            state = StateTypeNumber;
        }
    }
    [self drawSquare:CGRectMake(self.sideLength * columnIndex,self.sideLength * rowIndex , self.sideLength, self.sideLength)
               state:state cellNumber:cellState.number];
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

#pragma mark - touch events

- (void)redrawCellAtRowIndex:(NSUInteger)rowIndex columnIndex:(NSUInteger)columnIndex {
    [self setNeedsDisplayInRect:CGRectMake(self.sideLength * columnIndex, self.sideLength * rowIndex, self.sideLength, self.sideLength)];
}

- (void)cellDidPressAtRowIdx:(int)rowIdx columnIdx:(int)columnIdx {
    //修改对应格子属性
    int index = self.columnCount * rowIdx + columnIdx;
    HKCellState *cellState = self.cellsStates[index];
    if (cellState.hasPressed == NO) {
        cellState.hasPressed = YES;
        [self redrawCellAtRowIndex:rowIdx columnIndex:columnIdx];
        
        // cell has a mine
        if (cellState.number == -1) {
            // display all the mines
            for(int mineRowIndex = 0; mineRowIndex < self.rowCount; ++mineRowIndex) {
                for (int mineColumnIndex = 0; mineColumnIndex <self.columnCount; ++mineColumnIndex) {
                    HKCellState *mineCell = self.cellsStates[mineRowIndex * self.columnCount + mineColumnIndex];
                    if (mineCell.number == -1) {
                        mineCell.hasPressed = YES;
                        rowIdx = mineRowIndex;
                        columnIdx = mineColumnIndex;
                        [self redrawCellAtRowIndex:rowIdx columnIndex:columnIdx];
                    }
                }
            }
            // disable touch
            self.userInteractionEnabled = NO;
            if ([self.delegate respondsToSelector:@selector(mineDidPressed)]) {
                [self.delegate mineDidPressed];
            }

        }
        
        // cell is empty
        else if (cellState.number == 0) {
            for (int nbRowIdx = rowIdx - 1; nbRowIdx <= rowIdx + 1; ++nbRowIdx) {
                for (int nbColumnIdx = columnIdx - 1; nbColumnIdx <= columnIdx + 1; ++nbColumnIdx) {
                    if (nbRowIdx >= 0 && nbRowIdx < self.rowCount &&
                        nbColumnIdx >= 0 && nbColumnIdx < self.columnCount) {
                        if (nbRowIdx != rowIdx || nbColumnIdx != columnIdx) {
                            [self cellDidPressAtRowIdx:nbRowIdx columnIdx:nbColumnIdx];
                        }
                    }
                }
            }
        }
    }
    
    
    
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches count] > 0) {
        UITouch *touch = [[touches allObjects] objectAtIndex:0];
        CGPoint location = [touch locationInView:self];
        int rowIdx = (int)floor(location.y / self.sideLength);
        int columnIdx = (int)floor(location.x / self.sideLength);

        if (rowIdx >= 0 && rowIdx < self.rowCount &&
            columnIdx >= 0 && columnIdx < self.columnCount) {
            [self cellDidPressAtRowIdx:rowIdx columnIdx:columnIdx];
        }
    }
}

- (void)win {
    
        <#statements#>
    }
}
@end
