//
//  M6XIndexScrollObserver.h
//  M6ScrollObserver
//
//  Created by Chen,Meisong on 2019/1/11.
//  Copyright © 2019年 xyz.chenms. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface M6XIndexScrollObserver : NSObject
@property (nonatomic) CGFloat pageWidth;
@property (nonatomic, copy) void (^callback)(NSInteger index);
- (void)attachToScrollView:(UIScrollView * _Nullable)scrollView;
- (void)detach;
@end

NS_ASSUME_NONNULL_END
