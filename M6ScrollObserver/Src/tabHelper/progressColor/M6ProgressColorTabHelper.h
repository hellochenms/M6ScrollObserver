//
//  M6ProgressColorTabHelper.h
//  M6ScrollObserver
//
//  Created by Chen,Meisong on 2019/1/21.
//  Copyright © 2019年 xyz.chenms. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class M6CurrentColors;

@interface M6ProgressColorTabHelper : NSObject
- (void)updateNormalColor:(UIColor *)normalColor
            selectedColor:(UIColor *)selectedColor;
- (M6CurrentColors *)currentColorsWithProgress:(CGFloat)progress;
@end

@interface M6CurrentColors : NSObject
@property (nonatomic) UIColor *currentFromColor;
@property (nonatomic) UIColor *currentToColor;
@end

NS_ASSUME_NONNULL_END
