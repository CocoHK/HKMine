//
//  HKBoardView.m
//  DrawPractice
//
//  Created by Coco on 15/12/13.
//  Copyright (c) 2013 Coco. All rights reserved.
//

#import "HKBoardView.h"
#import "HKModels.h"
#import <QuartzCore/QuartzCore.h>
#import "HKDataMgr.h"

#define kNeedSound @"kNeedSound"
#define kNeedVibration @"kNeedVibration"

@implementation SoundEffect
- (id)initWithSoundNamed:(NSString *)filename type:(NSString *)typeName{
    if (self = [super init]) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:typeName];
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        if (fileURL != nil) {
            SystemSoundID theSoundID;
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &theSoundID);
            if (error == kAudioServicesNoError) {
                soundId = theSoundID;
            }
        }
    }
    return self;
}

- (void)dealloc {
    AudioServicesDisposeSystemSoundID(soundId);
}

- (void)play {
    AudioServicesPlaySystemSound(soundId);
}

@end

typedef NS_ENUM(NSUInteger, StateType) {
    StateTypeDefault = 0,
    StateTypeMine,
    StateTypeNumber,
    StateTypeEmpty,
    StateTypeMarked,
};



@implementation HKBoardView {
    int noMineCellNumber;
    NSInteger mineNumber;
    BOOL isNewGame;
}

- (void)awakeFromNib {
    HKDataMgr *dataMgr = [HKDataMgr shared];
    self.soundMark = [[SoundEffect alloc] initWithSoundNamed:@"soundMarked" type:@"wav"];
    self.soundClick = [[SoundEffect alloc] initWithSoundNamed:@"soundClick" type:@"wav"];
    self.soundBomb = [[SoundEffect alloc] initWithSoundNamed:@"soundBomb" type:@"wav"];
    [dataMgr addObserver:self forKeyPath:kNeedSound options:0 context:NULL];
    [dataMgr addObserver:self forKeyPath:kNeedVibration options:0 context:NULL];
    ifNeedSound = [dataMgr boolForKey:kNeedSound];
    ifNeedVibration = [dataMgr boolForKey:kNeedVibration];
    NSLog(@"needSound is %@ need Shake is %@",ifNeedSound?@"Yes":@"no",ifNeedVibration?@"Yes":@"no");
}

- (void)dealloc {
    HKDataMgr *dataMgr = [HKDataMgr shared];
    [dataMgr removeObserver:self forKeyPath:kNeedSound];
    [dataMgr removeObserver:self forKeyPath:kNeedVibration];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:kNeedSound]) {
        ifNeedSound = [[HKDataMgr shared] boolForKey:kNeedSound];
    }
    if ([keyPath isEqualToString:kNeedVibration]) {
        ifNeedVibration = [[HKDataMgr shared] boolForKey:kNeedVibration];
    }
}

- (void)setupWithRowCount:(NSUInteger)rowCount
              columnCount:(NSUInteger)columnCount
               sideLength:(CGFloat)sideLength
                mineCount:(NSInteger)mineCount{
    noMineCellNumber = 0;
    self.markedNumber = 0;
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
    srand((int)time(0)); // 用当前时间设置rand()的种子
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
    rectanglePath.lineWidth = 1.7;
    [[UIColor blackColor] setStroke];
    switch (state) {
        default:
        case StateTypeDefault:
        case StateTypeMarked:
            [[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]] setFill];
            break;
        case StateTypeMine:
        case StateTypeNumber:
        case StateTypeEmpty:
            [[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgPress.png"]] setFill];
            break;
    }
    [rectanglePath fill];
    [rectanglePath stroke];
    if (state == StateTypeMine) {
        int margin = 4;
        UIImage *mineImage = [UIImage imageNamed:@"mine gray.png"];
        [mineImage drawInRect:CGRectInset(bounds, margin, margin)];
    }
    else if (state == StateTypeMarked) {
        int margin = 7;
        UIImage *mineImage = [UIImage imageNamed:@"59-flag.png"];
        [mineImage drawInRect:CGRectInset(bounds, margin, margin)];
    }
    else if (state == StateTypeNumber) {
        UIColor *numberColor;
        switch (cellNumber) {
            default:
            case 1:
                numberColor = [UIColor colorWithRed:28/255.0f green:71/255.0f blue:179/255.0f alpha:1];
                break;
            case 2:
                numberColor = [UIColor colorWithRed:27/255.0f green:80/255.0f blue:0/255.0f alpha:1];

                break;
            case 3:
                numberColor = [UIColor colorWithRed:166/255.0f green:0/255.0f blue:0/255.0f alpha:1];
                break;
            case 4:
                numberColor = [UIColor colorWithRed:0/255.0f green:21/255.0f blue:110/255.0f alpha:1];
                break;
            case 5:
                numberColor = [UIColor colorWithRed:107/255.0f green:0/255.0f blue:0/255.0f alpha:1];
                break;
            case 6:
                numberColor = [UIColor colorWithRed:0/255.0f green:104/255.0f blue:113/255.0f alpha:1];
                break;
            case 7:
                numberColor = [UIColor colorWithRed:94/255.0f green:3/255.0f blue:13/255.0f alpha:1];
                break;
            case 8:
                numberColor = [UIColor colorWithRed:50/255.0f green:6/255.0f blue:49/255.0f alpha:1];
                break;
        }
        int margin = 5;
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:MAX(8, self.sideLength - margin *2.5)];

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
    NSInteger index = self.columnCount * rowIdx + columnIdx;
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
        ++ self.markedNumber;
        -- mineNumber;
        NSLog(@"markedNumber is %lu",(unsigned long)self.markedNumber);
        [self redrawCellAtRowIndex:rowIdx columnIndex:columnIdx];
        if (ifNeedSound == YES) {
            [self.soundMark play];
        }
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
            if (ifNeedSound == YES) {
            [self.soundBomb play];
            }
            if (ifNeedVibration == YES) {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            }
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
//        [self.soundClick play];

        
        if (cellState.number >= 0) {
            ++noMineCellNumber;
            if (ifNeedSound == YES) {
                [self.soundClick play];
            }
        }
    }

    

        }
    //want to cancel mark
    else if (cellState.CellAttribute == 2){
        if (atrribute == 0) {
            cellState.CellAttribute = 0;
            -- self.markedNumber;
            ++ mineNumber;
//            NSLog(@"markedNumber is %lu",(unsigned long)self.markedNumber);
            if (ifNeedSound == YES) {
            [self.soundMark play];
            }
            [self redrawCellAtRowIndex:rowIdx columnIndex:columnIdx];
        }
    }
    if (noMineCellNumber == self.rowCount * self.columnCount - mineNumber - self.markedNumber) {
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
