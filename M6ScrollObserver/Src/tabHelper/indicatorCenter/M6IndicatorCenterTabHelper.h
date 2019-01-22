//
//  M6IndicatorCenterTabHelper.h
//  M6ScrollObserver
//
//  Created by Chen,Meisong on 2019/1/21.
//  Copyright © 2019年 xyz.chenms. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class M6IndicatorInfo;

@interface M6IndicatorCenterTabHelper : NSObject
- (M6IndicatorInfo *)indicatorInfoWithSmallIndexProgress:(CGFloat)smallIndexProgress
                                       smallIndexCenterX:(CGFloat)smallIndexCenterX
                                         bigIndexCenterX:(CGFloat)bigIndexCenterX
                                          indicatorWidth:(CGFloat)indicatorWidth;
@end

@interface M6IndicatorInfo : NSObject
@property (nonatomic) CGFloat currentCenterX;
@property (nonatomic) CGFloat currentExtraWidth;
@end

NS_ASSUME_NONNULL_END
