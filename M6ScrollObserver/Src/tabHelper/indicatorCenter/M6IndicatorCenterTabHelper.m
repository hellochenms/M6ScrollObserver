//
//  M6IndicatorCenterTabHelper.m
//  M6ScrollObserver
//
//  Created by Chen,Meisong on 2019/1/21.
//  Copyright © 2019年 xyz.chenms. All rights reserved.
//

#import "M6IndicatorCenterTabHelper.h"

@implementation M6IndicatorCenterTabHelper

- (M6IndicatorInfo *)indicatorInfoWithSmallIndexProgress:(CGFloat)smallIndexProgress
                                       smallIndexCenterX:(CGFloat)smallIndexCenterX
                                         bigIndexCenterX:(CGFloat)bigIndexCenterX
                                          indicatorWidth:(CGFloat)indicatorWidth {
    CGFloat distance = bigIndexCenterX - smallIndexCenterX;
    CGFloat indicatorCenterX = smallIndexCenterX + distance * smallIndexProgress;
    
    // 黏性
    CGFloat extraWidth = distance - indicatorWidth;
    CGFloat curExtraWidth = 0;
    if (smallIndexProgress <= 0.5) {
        curExtraWidth = extraWidth * smallIndexProgress;
    } else {
        curExtraWidth = extraWidth * (1 - smallIndexProgress);
    }
    
    // Output
    M6IndicatorInfo *info = [M6IndicatorInfo new];
    info.currentCenterX = indicatorCenterX;
    info.currentExtraWidth = curExtraWidth;
    
    return info;
}
@end

@implementation M6IndicatorInfo
@end
