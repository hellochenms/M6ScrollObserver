//
//  M6PanDeltaOffsetYScrollObserver.m
//  M6ScrollObserver
//
//  Created by Chen,Meisong on 2019/1/28.
//  Copyright © 2019年 xyz.chenms. All rights reserved.
//

#import "M6PanDeltaOffsetYScrollObserver.h"

static NSString * const kKeyPathContentOffset = @"contentOffset";
static NSString * const kKeyPathPanState = @"state";

@interface M6PanDeltaOffsetYScrollObserver ()
@property (nonatomic) UIScrollView *scrollView;
// pan：暂时无法确定系统释放时机，可能导致KVO问题，故用strong变量维护
@property (nonatomic) UIPanGestureRecognizer *pan;
@property (nonatomic) CGFloat lastOffsetY;
@property (nonatomic) BOOL shouldCallback;
@end

@implementation M6PanDeltaOffsetYScrollObserver
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
    if ([keyPath isEqualToString:kKeyPathContentOffset]) {
        CGPoint offset = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
        CGFloat deltaY = [self deltaYWithOffsetY:offset.y];
        if (self.callback && self.shouldCallback) {
            self.callback(deltaY);
        }
        self.lastOffsetY = self.scrollView.contentOffset.y;
    } else if ([keyPath isEqualToString:kKeyPathPanState]) {
        NSInteger state = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        if (state == UIGestureRecognizerStateBegan) {
            self.shouldCallback = YES;
            self.lastOffsetY = self.scrollView.contentOffset.y;
        } else if (state == UIGestureRecognizerStateEnded
                   || state == UIGestureRecognizerStateCancelled) {
            self.shouldCallback = NO;
        }
    }
}

- (CGFloat)deltaYWithOffsetY:(CGFloat)offsetY {
    CGFloat deltaY = offsetY - self.lastOffsetY;
    
    return deltaY;
}
@end
