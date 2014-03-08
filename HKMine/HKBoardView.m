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
    StateTypeMarked,
};



@implementation HKBoardView {
    int noMineCellNumber;
    int markedNumber;
    NSInteger mineNumber;
    BOOL isNewGame;
}

- (void)setupWithRowCount:(NSUInteger)rowCount
              columnCount:(NSUInteger)columnCount
               sideLength:(CGFloat)sideLength
                mineCount:(NSInteger)mineCount{
    noMineCellNumber = 0;
    markedNumber = 0;
    self.rowCount = rowCount;
    self.columnCount = columnCount;
    self.sideLength = sideLength;
    mineNumber = mineCount;
    isNewGame = YES;
    
    //setup tap gesture
    UITapGestureRecognizer * tapPressGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapPressGesture.numberOfTapsRequired = 1;
    tapPressGesture.numberOfTouchesRequired = 1;
//    tapPressGesture.delegate = self;
    [self addGestureRecognizer:tapPressGesture];
    
    //setup long press gesture
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongGesture:)];
    longPressGesture.numberOfTapsRequired = 0;
    longPressGesture.numberOfTouchesRequired = 1;
    longPressGesture.minimumPressDuration = 0.3;
//    longPressGesture.delegate = self;
    [self addGestureRecognizer:longPressGesture];
    [longPressGesture requireGestureRecognizerToFail:tapPressGesture];
    
    
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
    while (addedMineCount < mineNumber) {
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
    rectanglePath.lineWidth = 2;
    [[UIColor blackColor] setStroke];
    switch (state) {
        default:
        case StateTypeDefault:
            [[UIColor lightGrayColor] setFill];
            break;
        case StateTypeMine:
            [[UIColor blackColor] setFill];
            break;
        case StateTypeNumber:
        case StateTypeEmpty:
            [[UIColor whiteColor] setFill];
            break;
        case StateTypeMarked:
            [[UIColor redColor] setFill];

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
    if (cellState.CellAttribute == 0) {
        state = StateTypeDefault;
    }
    else if (cellState.CellAttribute == 2)
        state = StateTypeMarked;

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

- (void)cellDidPressAtRowIdx:(int)rowIdx columnIdx:(int)columnIdx cellAtrribute:(int)atrribute{
    //修改对应格子属性
    int index = self.columnCount * rowIdx + columnIdx;
    HKCellState *cellState = self.cellsStates[index];
    [self redrawCellAtRowIndex:rowIdx columnIndex:columnIdx];
    if (isNewGame == YES) {
        if ([self.boardViewDelegate respondsToSelector:@selector(gameStart)]) {
            [self.boardViewDelegate gameStart];
    }
        isNewGame = NO;
    }
    if (cellState.CellAttribute == 0) {
        
    //want to mark this cell
    if (atrribute == 2) {
        cellState.CellAttribute = 2;
        ++ markedNumber;
        -- mineNumber;
        NSLog(@"markedNumber is %d",markedNumber);
        [self redrawCellAtRowIndex:rowIdx columnIndex:columnIdx];
    }
    
    //if this cell is digged
    else if (atrribute == 1) {
        cellState.CellAttribute = 1;

        // cell has a mine
        if (cellState.number == -1) {
            // display all the mines
            for(int mineRowIndex = 0; mineRowIndex < self.rowCount; ++mineRowIndex) {
                for (int mineColumnIndex = 0; mineColumnIndex <self.columnCount; ++mineColumnIndex) {
                    HKCellState *mineCell = self.cellsStates[mineRowIndex * self.columnCount + mineColumnIndex];
                    if (mineCell.number == -1) {
                        mineCell.CellAttribute = 1;
                        rowIdx = mineRowIndex;
                        columnIdx = mineColumnIndex;
                        [self redrawCellAtRowIndex:rowIdx columnIndex:columnIdx];
                        
                    }
                }
            }
            // disable touch
            self.userInteractionEnabled = NO;
            if ([self.boardViewDelegate respondsToSelector:@selector(gameOver)]) {
                [self.boardViewDelegate gameOver];
            }
            
        }
        // cell is empty
        else if (cellState.number == 0) {
            for (int nbRowIdx = rowIdx - 1; nbRowIdx <= rowIdx + 1; ++nbRowIdx) {
                for (int nbColumnIdx = columnIdx - 1; nbColumnIdx <= columnIdx + 1; ++nbColumnIdx) {
                    if (nbRowIdx >= 0 && nbRowIdx < self.rowCount &&
                        nbColumnIdx >= 0 && nbColumnIdx < self.columnCount) {
                        if (nbRowIdx != rowIdx || nbColumnIdx != columnIdx) {
                            [self cellDidPressAtRowIdx:nbRowIdx columnIdx:nbColumnIdx cellAtrribute:1];
                        }
                    }
                }
            }
        }
        
        if (cellState.number >= 0) {
            ++noMineCellNumber;
        }
//        NSLog(@"noMineCellNumber is %d",noMineCellNumber);
    }

    

        }
    //want to cancel mark
    else if (cellState.CellAttribute == 2){
        if (atrribute == 0) {
            cellState.CellAttribute = 0;
            -- markedNumber;
            ++ mineNumber;
            NSLog(@"markedNumber is %d",markedNumber);
            [self redrawCellAtRowIndex:rowIdx columnIndex:columnIdx];
        }
    }
    if (noMineCellNumber == self.rowCount * self.columnCount - mineNumber - markedNumber) {
        //detact if boardViewDelegate works
        if ([self.boardViewDelegate respondsToSelector:@selector(gameWin)]) {
            [self.boardViewDelegate gameWin];
        }
    }
    
    
}

- (void)handleLongGesture:(UILongPressGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:self];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        int rowIdx = (int)floor(location.y / self.sideLength);
        int columnIdx = (int)floor(location.x / self.sideLength);
        
        if (rowIdx >= 0 && rowIdx < self.rowCount &&
            columnIdx >= 0 && columnIdx < self.columnCount) {
            HKCellState *cell = self.cellsStates[rowIdx * self.columnCount + columnIdx];
            if (cell.CellAttribute == 0) {
//                cell.CellAttribute = 2;
                NSLog(@"this cell is long pressed");
                [self cellDidPressAtRowIdx:rowIdx columnIdx:columnIdx cellAtrribute:2];
            }
            else if (cell.CellAttribute == 2) {
                NSLog(@"1er CellAttribute is %d",cell.CellAttribute);
                NSLog(@"this cell is long pressed");
                [self cellDidPressAtRowIdx:rowIdx columnIdx:columnIdx cellAtrribute:0];
            }
        }
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:self];
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        int rowIdx = (int)floor(location.y / self.sideLength);
        int columnIdx = (int)floor(location.x / self.sideLength);
        
        if (rowIdx >= 0 && rowIdx < self.rowCount &&
            columnIdx >= 0 && columnIdx < self.columnCount) {
            [self cellDidPressAtRowIdx:rowIdx columnIdx:columnIdx cellAtrribute:1];
        }
    }
}

@end
