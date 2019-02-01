//
//  M6PanDeltaOffsetYScrollObserver.h
//  M6ScrollObserver
//
//  Created by Chen,Meisong on 2019/1/28.
//  Copyright © 2019年 xyz.chenms. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface M6PanDeltaOffsetYScrollObserver : NSObject
@property (nonatomic, copy) void (^callback)(CGFloat deltaY);
- (void)attachToScrollView:(UIScrollView * _Nullable)scrollView;
- (void)detach;
@end

NS_ASSUME_NONNULL_END
