//
//  M6XFromToIndexScrollObserver.m
//  M6ScrollObserver
//
//  Created by Chen,Meisong on 2019/1/18.
//  Copyright © 2019年 xyz.chenms. All rights reserved.
//

#import "M6XFromToIndexScrollObserver.h"

static NSString * const kKeyPathContentOffset = @"contentOffset";
static NSString * const kKeyPathPanState = @"state";

typedef NS_ENUM(NSUInteger, M6XFromToIndexODirection) {
    M6XFromToIndexODirectionFingerToLeft = 0,
    M6XFromToIndexODirectionFingerToRight,
};

@interface M6XFromToIndexScrollObserver ()
@property (nonatomic) UIScrollView *scrollView;
// pan：暂时无法确定系统释放时机，可能导致KVO问题，故用strong变量维护
@property (nonatomic) UIPanGestureRecognizer *pan;
@property (nonatomic) NSInteger curIndex;
@property (nonatomic) CGFloat lastOffsetX;
@end

@implementation M6XFromToIndexScrollObserver

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
        CGFloat curOffsetX = offset.x;
        if (curOffsetX >= 0
            && curOffsetX <= (self.scrollView.contentSize.width - self.scrollView.bounds.size.width)) {
            [self processWithCurOffsetX:curOffsetX
                            lastOffsetX:self.lastOffsetX
                              pageWidth:self.pageWidth];
            self.lastOffsetX = offset.x;
        }
    } else if ([keyPath isEqualToString:kKeyPathPanState]) {
        if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
            self.lastOffsetX = self.scrollView.contentOffset.x;
        }
    }
}

#pragma mark - Processor
- (void)processWithCurOffsetX:(CGFloat)curOffsetX
                  lastOffsetX:(CGFloat)lastOffsetX
                    pageWidth:(CGFloat)pageWidth {
    CGFloat curFloatIndex = [self curFloatIndexWithCurOffsetX:curOffsetX
                                                    pageWidth:pageWidth];
//    NSLog(@"【m2】lastOffsetX:%.2f curOffsetX:%.2f", lastOffsetX, curOffsetX);
    M6XFromToIndexODirection direction = [self directionWithLastOffsetX:lastOffsetX
                                                             curOffsetX:curOffsetX];
    NSInteger fromIndex = -1;
    NSInteger toIndex = -1;
    [self fromIndex:&fromIndex
            toIndex:&toIndex
  withCurFloatIndex:curFloatIndex
          direction:direction];
    if (fromIndex >= 0
        && toIndex >= 0) {
//        NSLog(@"【m2】curFloatIndex:%.2f direction:%ld fromIndex:%ld", curFloatIndex, direction, fromIndex);
        CGFloat progress = [self progressWithCurFloatIndex:curFloatIndex
                                                 direction:direction
                                                 fromIndex:fromIndex];
        if (self.callback) {
            self.callback(fromIndex, toIndex, progress);
        }
    }
}

- (NSInteger)curIndexWithCurOffsetX:(CGFloat)curOffsetX
                       pageWidth:(CGFloat)pageWidth {
    if (pageWidth <= 0) {
        return 0;
    }
    
    NSInteger index = (NSInteger)(round(curOffsetX / pageWidth));
    
    return index;
}

- (CGFloat)curFloatIndexWithCurOffsetX:(CGFloat)curOffsetX
                             pageWidth:(CGFloat)pageWidth {
    if (pageWidth <= 0) {
        return 0;
    }
    
    CGFloat curFloatIndex = curOffsetX / pageWidth;
    
    return curFloatIndex;
}

- (M6XFromToIndexODirection)directionWithLastOffsetX:(CGFloat)lastOffsetX
                                   curOffsetX:(CGFloat)curOffsetX {
    M6XFromToIndexODirection direction = (curOffsetX >= lastOffsetX ? M6XFromToIndexODirectionFingerToLeft : M6XFromToIndexODirectionFingerToRight);
    
    return direction;
}

- (void)fromIndex:(NSInteger *)outFromIndex
          toIndex:(NSInteger *)outToIndex
withCurFloatIndex:(CGFloat)curFloatIndex
        direction:(M6XFromToIndexODirection)direction {
    NSInteger fromIndex = 0;
    NSInteger toIndex = 0;
    if (direction == M6XFromToIndexODirectionFingerToLeft) {
        fromIndex = (NSInteger)(floor(curFloatIndex));
        toIndex = (NSInteger)(ceil(curFloatIndex));
    } else {
        fromIndex = (NSInteger)(ceil(curFloatIndex));
        toIndex = (NSInteger)(floor(curFloatIndex));
    }
    
    if (fromIndex != toIndex) {
        if (outFromIndex) {
            *outFromIndex = fromIndex;
        }
        if (outToIndex) {
            *outToIndex = toIndex;
        }
    }
}

- (CGFloat)progressWithCurFloatIndex:(CGFloat)curFloatIndex
                           direction:(M6XFromToIndexODirection)direction
                           fromIndex:(NSInteger)fromIndex {
    CGFloat progress = 0;
    if (direction == M6XFromToIndexODirectionFingerToLeft) {
        progress = curFloatIndex - fromIndex;
    } else {
        progress = fromIndex - curFloatIndex;
    }
    
    return progress;
}

@end
