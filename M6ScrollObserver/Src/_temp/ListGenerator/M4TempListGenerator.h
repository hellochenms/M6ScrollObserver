//
//  M2TempDataGenerator.h
//  M4TempTools
//
//  Created by Chen,Meisong on 2019/1/9.
//  Copyright © 2019年 xyz.chenms. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface M4TempListGenerator : NSObject
+ (NSArray<NSString *> *)indexArrayForCount:(NSInteger)count;
+ (NSArray<NSString *> *)textArrayForCount:(NSInteger)count;
+ (NSArray<NSString *> *)sameRandomNumberTextArrayForCount:(NSInteger)count;
@end
