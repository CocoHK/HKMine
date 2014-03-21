//
//  HKBoardView.h
//  DrawPractice
//
//  Created by Coco on 15/12/13.
//  Copyright (c) 2013 Coco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@protocol HKBoardViewDelegate <NSObject>
- (void)gameStart;
- (void)gameOver;
- (void)gameWin;
//- (void)mineNumberDidChanged:(NSInteger)mineNumber;

@end

@interface SoundEffect : NSObject {
    SystemSoundID soundId;
}
- (id)initWithSoundNamed:(NSString *)filename type:(NSString *)typeName;
- (void)play;

@end

#pragma mark - 

@interface HKBoardView : UIView <UIGestureRecognizerDelegate> {
    BOOL ifNeedSound;
    BOOL ifNeedVibration;
}

@property (nonatomic,retain) SoundEffect *soundClick;
@property (nonatomic,retain) SoundEffect *soundMark;
@property (nonatomic,retain) SoundEffect *soundBomb;

@property (nonatomic, assign) NSUInteger rowCount, columnCount, markedNumber;

@property (nonatomic, assign) CGFloat sideLength;
@property (nonatomic, strong) NSMutableArray *cellsStates;

@property (nonatomic, assign) id<HKBoardViewDelegate> boardViewDelegate;

- (void)resize;
- (void)setupWithRowCount:(NSUInteger)rowCount
              columnCount:(NSUInteger)columnCount
               sideLength:(CGFloat)sideLength
                mineCount:(NSInteger)mineCount;
@end

