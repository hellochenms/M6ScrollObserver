//
//  M6YProgressScrollObserver.m
//  M6ScrollObserver
//
//  Created by Chen,Meisong on 2019/1/10.
//  Copyright © 2019年 xyz.chenms. All rights reserved.
//

#import "M6YProgressScrollObserver.h"

static NSString * const kKeyPathContentOffset = @"contentOffset";

@interface M6YProgressScrollObserver ()
@property (nonatomic) UIScrollView *scrollView;
@end

@implementation M6YProgressScrollObserver
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
}

- (void)removeKVO {
    [self.scrollView removeObserver:self forKeyPath:kKeyPathContentOffset];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:kKeyPathContentOffset]) {
        CGPoint offset = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
        CGFloat progress = [self progressWithOffsetY:offset.y];
        if (self.callback) {
            self.callback(progress);
        }
    }
}

- (CGFloat)progressWithOffsetY:(CGFloat)offsetY {
    NSLog(@"【m2】offsetY:%.1f  %s", offsetY, __func__);
    NSLog(@"【m2】self.progress0OffsetY:%.1f  %s", self.progress0OffsetY, __func__);
    NSLog(@"【m2】self.progress1OffsetY:%.1f  %s", self.progress1OffsetY, __func__);
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
