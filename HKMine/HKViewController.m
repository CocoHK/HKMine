//
//  CEViewController.m
//  DrawPractice
//
//  Created by Coco on 15/12/13.
//  Copyright (c) 2013 Coco. All rights reserved.
//

#import "HKViewController.h"
#import "HKBoardView.h"
#import "HKDataMgr.h"
#import "HKSettingViewController.h"
#import "HKStatisticsViewController.h"
#import "HKMoreViewController.h"
#import <QuartzCore/QuartzCore.h>

#define kCustomLevelWidth @"kCustomLevelWidth"
#define kCustomLevelHeight @"kCustomLevelHeight"
#define kCustomLevelMine @"kCustomLevelMine"
#define kLevel @"kLevel"
#define markedNumber @"markedNumber"

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
    int crtStreak;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img_bg"]];
    
    dataMgr = [HKDataMgr shared];
    //margin 15
    [scrollView setContentInset:UIEdgeInsetsMake(15, 15, 15, 15)];
    self.boardView.boardViewDelegate = self;
    gameTime = 0;
    countTimeLabel.text = @"0";
    countTimeLabel.textAlignment = NSTextAlignmentCenter;
    countTimeLabel.font = [UIFont fontWithName:@"digital-7" size:19.0f];
    showMineLabel.font = [UIFont fontWithName:@"digital-7" size:19.0f];
    showMineLabel.text = @"0";
    [self startNewGame];
    adView.delegate = self;
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
    [countTimeLabel setText:[NSString stringWithFormat:@"%.0f",gameTime / 10]];
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
    restartBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img_happyface"]];
    scrollView.zoomScale = 1;
    [self.boardView setupWithRowCount:[dataMgr integerForKey:kCustomLevelHeight]
                          columnCount:[dataMgr integerForKey:kCustomLevelWidth]
                           sideLength:32
                            mineCount:[dataMgr integerForKey:kCustomLevelMine]];
    [self.boardView setBackgroundColor:[UIColor clearColor]];
    [self scrollViewSetup];
    [self scrollViewCenterContent];
    showMineLabel.text = [NSString stringWithFormat:@"%ld",(long)[dataMgr integerForKey:kCustomLevelMine]] ;
    NSLog(@"showMineLabel is %@",showMineLabel.text);
    self.boardView.userInteractionEnabled = YES;
    NSLog(@"current level is %ld",(long)[dataMgr integerForKey:kLevel]);
    
    [self.boardView addObserver:self forKeyPath:markedNumber options:(NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld) context:NULL];
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
    countTimeLabel.text = @"0";
    [self stopTimer];
    [self startNewGame];
}

- (IBAction)clickOptionBtn:(id)sender {
    
    MZRSlideInMenu *menu = [[MZRSlideInMenu alloc] init];
    [menu setDelegate:self];
    [menu addMenuItemWithTitle:@"Settings"];
    [menu addMenuItemWithTitle:@"Statistics"];
    [menu addMenuItemWithTitle:@"More"];
    [menu showMenuFromLeft];
}

- (void)slideInMenu:(MZRSlideInMenu *)menuView didSelectAtIndex:(NSUInteger)index
{
    if (index == 0) {
        HKSettingViewController *settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HKSettingViewController"];
        [self.navigationController pushViewController:settingsViewController animated:YES];
    }
    else if (index == 1) {
        HKStatisticsViewController *statisticsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HKStatisticsViewController"];
        [self.navigationController pushViewController:statisticsViewController animated:YES];
    }
    else {
        HKMoreViewController *moreViewController = [HKMoreViewController new];
        [self.navigationController pushViewController:moreViewController animated:YES];
    }
}

#pragma mark - HKBoardViewDelegate
- (void)gameStart {
    gameTime = 0;
    countTimeLabel.text = [NSString stringWithFormat:@"%.0f",gameTime / 10];
    [self startTimer];
}

- (void)gameOver {
    restartBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img_unhappyface"]];
    NSInteger currentLevel = [dataMgr integerForKey:kLevel];
    if (currentLevel < 3) {
        NSString *currentLevelInfoKey = [NSString stringWithFormat:@"DictInfoLevel%ld",(long)currentLevel];
        NSMutableDictionary *infoDict = [[dataMgr objectForKey:currentLevelInfoKey] mutableCopy];
        if (!infoDict) {
            infoDict = [NSMutableDictionary dictionary];
        }
        
        NSNumber *gamePlayed = [infoDict objectForKey:kGamePlayed];
        [infoDict setObject:[NSNumber numberWithInteger:([gamePlayed integerValue] + 1)] forKey:kGamePlayed];
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
        NSLog(@"crtStreak is %i, LonggestLoseStreak is %li,LonggestCrtStreak is %li",crtStreak,(long)[infoDict[kLLoseStreak] integerValue],(long)[infoDict[kCurrentStreak] integerValue]);
        [dataMgr setObject:infoDict forKey:currentLevelInfoKey];
    }
    
    [self stopTimer];
    scrollView.zoomScale = scrollView.minimumZoomScale;
}

- (void)gameWin {
    NSInteger currentLevel = [dataMgr integerForKey:kLevel];
    NSString *alertMessage;

    if (currentLevel < 3) {
        NSString *currentLevelInfoKey = [NSString stringWithFormat:@"DictInfoLevel%ld",(long)currentLevel];
        NSMutableDictionary *infoDict = [[dataMgr objectForKey:currentLevelInfoKey] mutableCopy];
        if (!infoDict) {
            infoDict = [NSMutableDictionary dictionary];
        }
        NSInteger gamePlayed = [infoDict[kGamePlayed] integerValue];
        NSInteger gameWon = [infoDict[kGameWon] integerValue];
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
            
            alertMessage = [NSString stringWithFormat:@"The shortest time in this level!\nBest time : %.1f s\nGames played : %ld\nGames won : %ld\nPercentage : %@",gameTime / 10,(long)gamePlayed+1,(long)gameWon+1,gamePercentageStr];
        }
        //didn't get new record
        else {
            alertMessage = [NSString stringWithFormat:@"Time : %.1f s\nGames played : %ld\nGames won : %ld\nPercentage : %@",gameTime / 10,(long)gamePlayed +1,(long)gameWon + 1,gamePercentageStr];
        }
        NSLog(@"crtStreak is %i, LonggestWinStreak is %li,LonggestCrtStreak is %li",crtStreak,(long)[infoDict[kLWinStreak] integerValue],(long)[infoDict[kCurrentStreak] integerValue]);
        [dataMgr setObject:infoDict forKey:currentLevelInfoKey];

    }
    else {
        alertMessage = @"";
    }
    [self stopTimer];
    UIAlertView *alertWin = [[UIAlertView alloc]initWithTitle:@"You win!" message:alertMessage delegate:self cancelButtonTitle:@"New Game" otherButtonTitles:@"OK",nil];
    [alertWin show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self startNewGame];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:markedNumber]) {
        NSInteger markedNbr = [[self.boardView valueForKey:markedNumber] integerValue];
        showMineLabel.text = [NSString stringWithFormat:@"%ld",(long)[dataMgr integerForKey:kCustomLevelMine] - markedNbr];
    }
}

#pragma mark - memory management

- (void)dealloc {
    [self.boardView removeObserver:self forKeyPath:markedNumber];
}

#pragma mark - ADBannerView
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    NSLog(@"bannerview did not receive any banner due to %@", error);}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner{NSLog(@"bannerview was selected");}
//
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    NSLog(@"Banner was clicked on; will%sleave application", willLeave ? " " : " not ");
        return YES;
}
//
- (void)bannerViewDidLoadAd:(ADBannerView *)banner {NSLog(@"banner was loaded");}

@end
