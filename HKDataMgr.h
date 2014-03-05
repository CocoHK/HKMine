//
//  HKDataMgr.h
//  HKMine
//
//  Created by Coco on 04/03/14.
//  Copyright (c) 2014 Coco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKDataMgr : NSObject

+ (instancetype)shared;

- (void)setInteger:(NSInteger)value forKey:(NSString *)key;
- (void)setFloat:(float)value forKey:(NSString *)key;
- (void)setDouble:(double)value forKey:(NSString *)key;
- (void)setBool:(BOOL)value forKey:(NSString *)key;

- (NSInteger)integerForKey:(NSString *)key;
- (float)floatForKey:(NSString *)key;
- (double)doubleForKey:(NSString *)key;
- (BOOL)boolForKey:(NSString *)key;

@end
