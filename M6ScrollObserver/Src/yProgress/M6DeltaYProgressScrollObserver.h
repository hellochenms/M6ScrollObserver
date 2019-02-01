//
//  M6DeltaYProgressScrollObserver.h
//  M6ScrollObserver
//
//  Created by Chen,Meisong on 2019/1/31.
//  Copyright © 2019年 xyz.chenms. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface M6DeltaYProgressScrollObserver : NSObject
@property (nonatomic) CGFloat progress0OffsetY;
@property (nonatomic) CGFloat progress1OffsetY;
@property (nonatomic, copy) void (^callback)(CGFloat progress, CGFloat offsetY);
- (void)attachToScrollView:( UIScrollView * _Nullable)scrollView;
- (void)detach;
@end

NS_ASSUME_NONNULL_END
