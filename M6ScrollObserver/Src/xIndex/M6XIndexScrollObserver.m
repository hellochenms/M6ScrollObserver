//
//  M6XIndexScrollObserver.m
//  M6ScrollObserver
//
//  Created by Chen,Meisong on 2019/1/11.
//  Copyright © 2019年 xyz.chenms. All rights reserved.
//

#import "M6XIndexScrollObserver.h"

static NSString * const kKeyPathContentOffset = @"contentOffset";

@interface M6XIndexScrollObserver ()
@property (nonatomic) UIScrollView *scrollView;
@end

@implementation M6XIndexScrollObserver

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
        NSInteger index = [self indexWithOffsetX:offset.x];
        if (self.callback) {
            self.callback(index);
        }
    }
}

- (NSInteger)indexWithOffsetX:(CGFloat)offsetX {
    if (self.pageWidth <= 0) {
        return 0;
    }
    
    NSInteger index = (NSInteger)(round(offsetX / self.pageWidth));
    
    return index;
}


@end
