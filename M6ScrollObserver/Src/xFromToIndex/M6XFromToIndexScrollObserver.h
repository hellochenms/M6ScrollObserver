//
//  M6XFromToIndexScrollObserver.h
//  M6ScrollObserver
//
//  Created by Chen,Meisong on 2019/1/18.
//  Copyright © 2019年 xyz.chenms. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface M6XFromToIndexScrollObserver : NSObject
@property (nonatomic) CGFloat pageWidth;
@property (nonatomic, copy) void (^callback)(NSInteger fromIndex, NSInteger toIndex, CGFloat progress);
- (void)attachToScrollView:(UIScrollView * _Nullable)scrollView;
- (void)detach;
@end

NS_ASSUME_NONNULL_END
