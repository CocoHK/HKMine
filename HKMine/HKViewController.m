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

#define easyBestTime @"easyBestTime"
#define mediumBestTime @"mediumBestTime"
#define hardBestTime @"hardBestTime"
#define easyGamePlayed @"easyGamePlayed"
#define mediumGamePlayed @"mediumGamePlayed"
#define hardGamePlayed @"hardGamePlayed"
#define easyGameWon @"easyGameWon"
#define mediumGameWon @"mediumGameWon"
#define hardGameWon @"hardGameWon"

@interface HKViewController ()

@end

@implementation HKViewController{
    double gameTime;
    NSString *gameTimeStr;
    NSTimer *gameTimer;
    HKDataMgr *dataMgr;
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
    int currentLevel = [dataMgr integerForKey:kLevel];;
    int gamePlayed;
    switch (currentLevel) {
        case 0:
            gamePlayed = [dataMgr integerForKey:easyGamePlayed];
            [dataMgr setInteger:gamePlayed + 1 forKey:easyGamePlayed];
            break;
        case 1:
            gamePlayed = [dataMgr integerForKey:mediumGamePlayed];
            [dataMgr setInteger:gamePlayed + 1 forKey:mediumGamePlayed];
            break;
        case 2:
            gamePlayed = [dataMgr integerForKey:hardGamePlayed];
            [dataMgr setInteger:gamePlayed + 1 forKey:hardGamePlayed];
            break;
        default:
            break;
    }
    [self stopTimer];
    scrollView.zoomScale = scrollView.minimumZoomScale;
}

- (void)gameWin {
    int gamePlayed;
    int gameWon;
    int currentLevel = [dataMgr integerForKey:kLevel];
    double currentBestTime = 0;
    NSString *alertMessage;
    switch (currentLevel) {
        case 0:
            currentBestTime = [dataMgr doubleForKey:easyBestTime];
            gamePlayed = [dataMgr integerForKey:easyGamePlayed];
            gameWon = [dataMgr integerForKey:easyGameWon];
            [dataMgr setInteger:gamePlayed + 1 forKey:easyGamePlayed];
            [dataMgr setInteger:gameWon + 1 forKey:easyGameWon];
            break;
        case 1:
            currentBestTime = [dataMgr doubleForKey:mediumBestTime];
            gamePlayed = [dataMgr integerForKey:mediumGamePlayed];
            gameWon = [dataMgr integerForKey:mediumGameWon];
            [dataMgr setInteger:gamePlayed + 1 forKey:mediumGamePlayed];
            [dataMgr setInteger:gameWon + 1 forKey:mediumGameWon];
            break;
        case 2:
            currentBestTime = [dataMgr doubleForKey:hardBestTime];
            gamePlayed = [dataMgr integerForKey:hardGamePlayed];
            gameWon = [dataMgr integerForKey:hardGameWon];
            [dataMgr setInteger:gamePlayed + 1 forKey:hardGamePlayed];
            [dataMgr setInteger:gameWon + 1 forKey:hardGameWon];
            break;
        default:
            break;
    }
    
  //got new record
    if (currentBestTime == 0 || gameTime < currentBestTime) {
        switch (currentLevel) {
            case 0:
                [dataMgr setDouble:gameTime forKey:easyBestTime];
                break;
            case 1:
                [dataMgr setDouble:gameTime forKey:mediumBestTime];
                break;
            case 2:
                [dataMgr setDouble:gameTime forKey:hardBestTime];
                break;
            default:
                break;
        }
        alertMessage = [NSString stringWithFormat:@"The shortest time in this level!\nBest time: %.1f seconds\nGames played: %d\nGames won: %d\nPercentage: %@",gameTime/10,gamePlayed + 1,gameWon + 1,[NSString stringWithFormat:@"%.2f%%",( (gameWon+1) / (float)(gamePlayed+1)) * 100]];
    }
    //didn't get new record
    else {
        alertMessage = [NSString stringWithFormat:@"Time: %.1f seconds\nGames played: %d\nGames won: %d\nPercentage: %@",gameTime / 10,gamePlayed + 1,gameWon + 1,[NSString stringWithFormat:@"%.2f%%",( (gameWon+1) / (float)(gamePlayed+1)) * 100]];
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
