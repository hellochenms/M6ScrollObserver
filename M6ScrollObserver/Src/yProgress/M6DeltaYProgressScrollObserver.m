//
//  M6DeltaYProgressScrollObserver.m
//  M6ScrollObserver
//
//  Created by Chen,Meisong on 2019/1/31.
//  Copyright © 2019年 xyz.chenms. All rights reserved.
//

#import "M6DeltaYProgressScrollObserver.h"

static NSString * const kKeyPathContentOffset = @"contentOffset";
static NSString * const kKeyPathPanState = @"state";

@interface M6DeltaYProgressScrollObserver ()
@property (nonatomic) UIScrollView *scrollView;
// pan：暂时无法确定系统释放时机，可能导致KVO问题，故用strong变量维护
@property (nonatomic) UIPanGestureRecognizer *pan;
@property (nonatomic) CGFloat lastOffsetY;
@property (nonatomic) CGFloat offsetY;
@end

@implementation M6DeltaYProgressScrollObserver
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
        
        if (offset.y >= self.progress1OffsetY
            && self.offsetY >= self.progress1OffsetY) {
            return;
        }
        if (offset.y <= self.progress0OffsetY
            && self.offsetY <= self.progress0OffsetY) {
            return;
        }
        
        CGFloat deltaOffsetY = offset.y - self.lastOffsetY;
        self.offsetY += deltaOffsetY;
        
        if (self.offsetY > self.progress1OffsetY) {
            self.offsetY = self.progress1OffsetY;
        } else if (self.offsetY < self.progress0OffsetY) {
            self.offsetY = self.progress0OffsetY;
        } else {}
        
        CGFloat progress = (self.offsetY - self.progress0OffsetY) / (self.progress1OffsetY - self.progress0OffsetY);
        
        if (self.callback) {
            self.callback(progress, self.offsetY);
        }
        self.lastOffsetY = self.scrollView.contentOffset.y;
    } else if ([keyPath isEqualToString:kKeyPathPanState]) {
        NSInteger state = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        if (state == UIGestureRecognizerStateBegan) {
            self.lastOffsetY = self.scrollView.contentOffset.y;
        }
    }
}

- (CGFloat)progressWithOffsetY:(CGFloat)offsetY {
    CGFloat progress = 0;
    if (offsetY < self.progress0OffsetY) {
        progress = 0;
    } else if (offsetY > self.progress1OffsetY) {
        progress = 1.0;
    } else {
        progress = (offsetY - self.progress0OffsetY) / (self.progress1OffsetY - self.progress0OffsetY);
    }
    
    return progress;
}

@end
