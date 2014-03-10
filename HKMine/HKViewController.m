//
//  CEViewController.m
//  DrawPractice
//
//  Created by Coco on 15/12/13.
//  Copyright (c) 2013 Coco. All rights reserved.
//

#import "HKViewController.h"
#import "HKBoardView.h"
#import "HKSettingViewController.h"
#import "HKDataMgr.h"

#define kCustomLevelWidth @"kCustomLevelWidth"
#define kCustomLevelHeight @"kCustomLevelHeight"
#define kCustomLevelMine @"kCustomLevelMine"
#define kLevel @"kLevel"

#define kBestTime @"kBestTime"
#define kGamePlayed @"kGamePlayed"
#define kGameWon @"kGameWon"
#define kLWinStreak @"kLWinStreak"
#define kLLoseStreak @"kLLoseStreak"
#define kCurrentStreak @"kCurrentStreak"

@interface HKViewController ()

@end

@implementation HKViewController{
    double gameTime;
    NSString *gameTimeStr;
    NSTimer *gameTimer;
    HKDataMgr *dataMgr;
    BOOL lastGameWin;
//    BOOL mLastGameWin;
//    BOOL hLastGameWin;
    int crtStreak;
//    int mCrtStreak;
//    int hCrtStreak;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    dataMgr = [HKDataMgr shared];
    //和边框有15像素的距离
    [scrollView setContentInset:UIEdgeInsetsMake(15, 15, 15, 15)];
    self.boardView.boardViewDelegate = self;
    gameTime = 0;
    countTimeLabel.text = @"000";
    [self startNewGame];
}

- (void)startTimer {
    [self stopTimer];
    gameTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
}

- (void)stopTimer {
    if (gameTimer) {
        [gameTimer invalidate];
        gameTimer = nil;
    }
}

- (void)updateTime:(NSTimer *)timer {
    gameTime ++;
    [countTimeLabel setText:[NSString stringWithFormat:@"%003.0f",gameTime / 10]];
}

#pragma mark - Scroll View Manipulation

- (void)scrollViewSetup {
    scrollView.delegate = self;
    [scrollView setContentSize:self.boardView.frame.size];
    [self scrollViewUpdateMinZoomScale];
    scrollView.zoomScale = scrollView.minimumZoomScale;
}

- (void)scrollViewUpdateMinZoomScale {
    UIEdgeInsets contentInset = scrollView.contentInset;
    CGFloat minWidthScale = (CGRectGetWidth(scrollView.bounds) - contentInset.left - contentInset.right) / CGRectGetWidth(self.boardView.frame);
    CGFloat minHeightScale = (CGRectGetHeight(scrollView.bounds) - contentInset.bottom - contentInset.top) / CGRectGetHeight(self.boardView.frame);
    scrollView.minimumZoomScale = MIN(1, MIN(minWidthScale, minHeightScale));
}

- (void)scrollViewCenterContent {
    CGPoint newCenter;
    UIEdgeInsets contentInset = scrollView.contentInset;
    newCenter.x = MAX(CGRectGetWidth(self.boardView.frame), CGRectGetWidth(scrollView.frame) - contentInset.left - contentInset.right) / 2.0f;
    newCenter.y = MAX(CGRectGetHeight(self.boardView.frame), CGRectGetHeight(scrollView.frame) - contentInset.bottom - contentInset.top) / 2.0f;
    self.boardView.center = newCenter;
}

#pragma mark - Game Control

- (void)startNewGame {
    scrollView.zoomScale = 1;
    [self.boardView setupWithRowCount:[[NSUserDefaults standardUserDefaults]integerForKey:kCustomLevelHeight]
                          columnCount:[[NSUserDefaults standardUserDefaults]integerForKey:kCustomLevelWidth]
                           sideLength:32
                            mineCount:[[NSUserDefaults standardUserDefaults]integerForKey:kCustomLevelMine]];
    [self scrollViewSetup];
    self.boardView.userInteractionEnabled = YES;
    NSLog(@"current level is %d",[dataMgr integerForKey:kLevel]);
}

#pragma mark - UIViewController

- (void)viewWillLayoutSubviews {
    [self scrollViewCenterContent];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.boardView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self scrollViewCenterContent];
}

#pragma mark - Actions

- (IBAction)startNewGame:(id)sender {
    [self startNewGame];
}


#pragma mark - HKBoardViewDelegate
- (void)gameStart {
    gameTime = 0;
    countTimeLabel.text = [NSString stringWithFormat:@"%03.0f",gameTime / 10];
    [self startTimer];
}

- (void)gameOver {
    int currentLevel = [dataMgr integerForKey:kLevel];
    if (currentLevel < 3) {
        NSString *currentLevelInfoKey = [NSString stringWithFormat:@"DictInfoLevel%d",currentLevel];
        NSMutableDictionary *infoDict = [[dataMgr objectForKey:currentLevelInfoKey] mutableCopy];
        if (!infoDict) {
            infoDict = [NSMutableDictionary dictionary];
        }
        
        NSNumber *gamePlayed = [infoDict objectForKey:kGamePlayed];
        [infoDict setObject:[NSNumber numberWithInt:([gamePlayed integerValue] + 1)] forKey:kGamePlayed];
        if (lastGameWin) {
            lastGameWin = NO;
            crtStreak = 1;
        }
        else {
            crtStreak += 1;
        }
        if (crtStreak > [infoDict[kLLoseStreak] integerValue]) {
            infoDict[kLLoseStreak] = @(crtStreak);
        }
        if (crtStreak > [infoDict[kCurrentStreak] integerValue] ) {
            infoDict[kCurrentStreak] = @(crtStreak);
        }
        NSLog(@"crtStreak is %i, LonggestLoseStreak is %i,LonggestCrtStreak is %i",crtStreak,[infoDict[kLLoseStreak] integerValue],[infoDict[kCurrentStreak] integerValue]);
        [dataMgr setObject:infoDict forKey:currentLevelInfoKey];
    }

    [self stopTimer];
    scrollView.zoomScale = scrollView.minimumZoomScale;
}

- (void)gameWin {
    int currentLevel = [dataMgr integerForKey:kLevel];
    NSString *alertMessage;

    if (currentLevel < 3) {
        NSString *currentLevelInfoKey = [NSString stringWithFormat:@"DictInfoLevel%d",currentLevel];
        NSMutableDictionary *infoDict = [[dataMgr objectForKey:currentLevelInfoKey] mutableCopy];
        if (!infoDict) {
            infoDict = [NSMutableDictionary dictionary];
        }
        int gamePlayed = [infoDict[kGamePlayed] integerValue];
        int gameWon = [infoDict[kGameWon] integerValue];
        //    float gamePercentage = (gameWon + 1) / (float)(gamePlayed + 1) * 100;
        NSString *gamePercentageStr = [NSString stringWithFormat:@"%.2f %%",(gameWon + 1) / (float)(gamePlayed + 1) * 100];
        infoDict[kGamePlayed] = @(gamePlayed + 1);
        infoDict[kGameWon] = @(gameWon + 1);
        infoDict[kPercentage] = gamePercentageStr;
        if (lastGameWin == NO) {
            crtStreak = 1;
            lastGameWin = YES;
        }
        else {
            crtStreak += 1;
        }
        if (crtStreak > [infoDict[kLWinStreak] integerValue]) {
            infoDict[kLWinStreak] = @(crtStreak);
        }
        if (crtStreak > [infoDict[kCurrentStreak] integerValue]) {
            infoDict[kCurrentStreak] = @(crtStreak);
        }
        
        //got new record
        double currentBestTime = [infoDict[kBestTime] doubleValue];
        
        if (currentBestTime == 0 || gameTime < currentBestTime) {
            infoDict[kBestTime] = @(gameTime);
            
            alertMessage = [NSString stringWithFormat:@"The shortest time in this level!\nBest time : %.1f s\nGames played : %d\nGames won : %d\nPercentage : %@",gameTime / 10,gamePlayed + 1,gameWon + 1,gamePercentageStr];
        }
        //didn't get new record
        else {
            alertMessage = [NSString stringWithFormat:@"Time : %.1f s\nGames played : %d\nGames won : %d\nPercentage : %@",gameTime / 10,gamePlayed + 1,gameWon + 1,gamePercentageStr];
        }
        NSLog(@"crtStreak is %i, LonggestWinStreak is %i,LonggestCrtStreak is %i",crtStreak,[infoDict[kLWinStreak] integerValue],[infoDict[kCurrentStreak] integerValue]);
        
        [dataMgr setObject:infoDict forKey:currentLevelInfoKey];

    }
    else {
        alertMessage = @"";
    }
    [self stopTimer];
    UIAlertView *alertWin = [[UIAlertView alloc]initWithTitle:@"You win!" message:alertMessage delegate:self cancelButtonTitle:@"new game" otherButtonTitles:@"OK",nil];
    [alertWin show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self startNewGame];
    }
}
@end
