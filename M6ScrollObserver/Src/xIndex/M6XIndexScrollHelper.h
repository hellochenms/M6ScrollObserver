//
//  M6XIndexScrollHelper.h
//  M6ScrollObserver
//
//  Created by Chen,Meisong on 2019/1/25.
//  Copyright © 2019年 xyz.chenms. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface M6XIndexScrollHelper : NSObject
@property (nonatomic) CGFloat pageWidth;
- (NSInteger)indexWithOffsetX:(CGFloat)offsetX;
@end

NS_ASSUME_NONNULL_END
