//
//  HKDataMgr.m
//  HKMine
//
//  Created by Coco on 04/03/14.
//  Copyright (c) 2014 Coco. All rights reserved.
//

#import "HKDataMgr.h"

@implementation HKDataMgr

+ (instancetype)shared {
    static id __sharedInstance = nil;
    if (__sharedInstance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            __sharedInstance = [[[self class] alloc] init];
        });
    }
    return __sharedInstance;
}

- (void)setInteger:(NSInteger)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setDouble:(double)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setBool:(BOOL)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setObject:(id)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)integerForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

- (double)doubleForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] doubleForKey:key];
}

- (BOOL)boolForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

- (id)objectForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (NSDictionary *)statisticsForLevel:(int)level {
    NSString *currentLevelInfoKey = [NSString stringWithFormat:@"DictInfoLevel%d",level];
    NSDictionary *infoDict = [self objectForKey:currentLevelInfoKey];
    if (!infoDict) {
        infoDict = [self resetDict:level];
    }
    NSLog(@" statistics level is %d dict is %@",level,infoDict);
    return infoDict;
}

- (NSDictionary *)resetDict:(int)level {
    NSString *currentLevelInfoKey = [NSString stringWithFormat:@"DictInfoLevel%d",level];
    
 NSDictionary *infoDict= @{kBestTime: @(0),
                kGamePlayed:@(0),
                kGameWon:@(0),
                kPercentage:@"0%",
                kLWinStreak:@(0),
                kLLoseStreak:@(0),
                kCurrentStreak:@(0),
                };
    NSLog(@"reset level is %d dict is %@",level,infoDict);

    [self setObject:infoDict forKey:currentLevelInfoKey];
    return infoDict;
}

@end
