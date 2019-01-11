//
//  M6RisePercentScrollObserver.h
//  M6ScrollObserver
//
//  Created by Chen,Meisong on 2019/1/11.
//  Copyright © 2019年 xyz.chenms. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface M6RisePercentScrollObserver : NSObject
@property (nonatomic) CGFloat distance;
@property (nonatomic) BOOL notCallbackWhenOffsetYNegative;
@property (nonatomic, copy) void (^callback)(CGFloat risePercent);
- (void)attachToScrollView:( UIScrollView * _Nullable)scrollView;
- (void)detach;
@end

NS_ASSUME_NONNULL_END
