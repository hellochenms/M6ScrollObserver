//
//  M6RisePercentScrollObserver.m
//  M6ScrollObserver
//
//  Created by Chen,Meisong on 2019/1/11.
//  Copyright © 2019年 xyz.chenms. All rights reserved.
//

#import "M6RisePercentScrollObserver.h"

static NSString * const kKeyPathContentOffset = @"contentOffset";
static NSString * const kKeyPathPanState = @"state";

@interface M6RisePercentScrollObserver ()
@property (nonatomic) UIScrollView *scrollView;
// pan：暂时无法确定系统释放时机，可能导致KVO问题，故用strong变量维护
@property (nonatomic) UIPanGestureRecognizer *pan;
@property (nonatomic) CGFloat lastOffsetY;
@end

@implementation M6RisePercentScrollObserver
- (void)attachToScrollView:(UIScrollView * _Nullable)scrollView {
    // detach
    if (self.scrollView) {
        [self removeKVO];
    }
    
    // attach
    self.scrollView = scrollView;
    if (self.scrollView) {
        [self addKVO];
    }
}

- (void)detach {
    if (self.scrollView) {
        [self removeKVO];
    }
    self.scrollView = nil;
}

#pragma mark - KVO
- (void)addKVO {
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew;
    [self.scrollView addObserver:self forKeyPath:kKeyPathContentOffset options:options context:nil];
    self.pan = self.scrollView.panGestureRecognizer;
    [self.pan addObserver:self forKeyPath:kKeyPathPanState options:options context:nil];
}

- (void)removeKVO {
    [self.scrollView removeObserver:self forKeyPath:kKeyPathContentOffset];
    [self.pan removeObserver:self forKeyPath:kKeyPathPanState];
    self.pan = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (self.distance <= 0) {
        return;
    }
    if ([keyPath isEqualToString:kKeyPathContentOffset]) {
        CGPoint offset = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
        CGFloat risePercent = [self risePercentWithOffsetY:offset.y];
        if (offset.y >= 0 || !self.notCallbackWhenOffsetYNegative) {
            if (self.callback) {
                self.callback(risePercent);
            }
            self.lastOffsetY = self.scrollView.contentOffset.y;
        }
    } else if ([keyPath isEqualToString:kKeyPathPanState]) {
        if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
            self.lastOffsetY = self.scrollView.contentOffset.y;
        }
    }
}

- (CGFloat)risePercentWithOffsetY:(CGFloat)offsetY {
    if (self.distance <= 0) {
        return 0;
    }
    
    CGFloat risePercent = (offsetY - self.lastOffsetY) / self.distance;
    
    return risePercent;
}

@end
