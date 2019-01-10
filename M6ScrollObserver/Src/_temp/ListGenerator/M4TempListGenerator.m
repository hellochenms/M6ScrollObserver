//
//  M2TempDataGenerator.m
//  M4TempTools
//
//  Created by Chen,Meisong on 2019/1/9.
//  Copyright © 2019年 xyz.chenms. All rights reserved.
//

#import "M4TempListGenerator.h"

static NSInteger const kCount = 20;

@implementation M4TempListGenerator

+ (NSArray<NSString *> *)indexArrayForCount:(NSInteger)count {
    // guard
    if (count <= 0) {
        count = kCount;
    }

    // datas
    NSMutableArray *datas = [NSMutableArray array];
    
    for (NSInteger i = 0; i < count; i++) {
        NSString *text = [NSString stringWithFormat:@"%ld", i];
        [datas addObject:[text copy]];
    }
    
    return [datas copy];
}

#pragma mark - text array
+ (NSArray<NSString *> *)textArrayForCount:(NSInteger)count {
    // guard
    if (count <= 0) {
        count = kCount;
    }
    
    // datas
    NSMutableArray *datas = [NSMutableArray array];
    
    for (NSInteger i = 0; i < count; i++) {
        NSMutableString *text = [NSMutableString stringWithString:@"^"];
        NSInteger count = arc4random() % 10 + 1;
        for (NSInteger i = 0; i < count; i++) {
            [text appendString:@"ABCDefg0123你好世界"];
        }
        [text appendString:@"$"];
        [datas addObject:[text copy]];
    }
    
    return [datas copy];
}

+ (NSArray<NSString *> *)sameRandomNumberTextArrayForCount:(NSInteger)count {
    if (count <= 0) {
        count = kCount;
    }
    
    // datas
    NSMutableArray *datas = [NSMutableArray array];
    NSInteger number = arc4random() % 10;
    
    for (NSInteger i = 0; i < count; i++) {
        NSMutableString *text = [NSMutableString stringWithString:@"^"];
        NSInteger count = arc4random() % 100;
        for (NSInteger i = 0; i < count; i++) {
            [text appendFormat:@"%ld", number];
        }
        [text appendString:@"$"];
        [datas addObject:[text copy]];
    }
    
    return [datas copy];
}

@end
