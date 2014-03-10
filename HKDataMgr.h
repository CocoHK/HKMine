//
//  HKDataMgr.h
//  HKMine
//
//  Created by Coco on 04/03/14.
//  Copyright (c) 2014 Coco. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kBestTime @"kBestTime"
#define kGamePlayed @"kGamePlayed"
#define kGameWon @"kGameWon"
#define kPercentage @"kPercentage"
#define kLWinStreak @"kLWinStreak"
#define kLLoseStreak @"kLLoseStreak"
#define kCurrentStreak @"kCurrentStreak"

@interface HKDataMgr : NSObject

+ (instancetype)shared;

- (void)setInteger:(NSInteger)value forKey:(NSString *)key;
- (void)setDouble:(double)value forKey:(NSString *)key;
- (void)setBool:(BOOL)value forKey:(NSString *)key;
- (void)setObject:(id)value forKey:(NSString *)key;

- (NSInteger)integerForKey:(NSString *)key;
- (double)doubleForKey:(NSString *)key;
- (BOOL)boolForKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;

- (NSDictionary *)statisticsForLevel:(int)level;
- (NSDictionary *)resetDict:(int)level;

@end
