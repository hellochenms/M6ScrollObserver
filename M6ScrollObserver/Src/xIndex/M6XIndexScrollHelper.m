//
//  M6XIndexScrollHelper.m
//  M6ScrollObserver
//
//  Created by Chen,Meisong on 2019/1/25.
//  Copyright © 2019年 xyz.chenms. All rights reserved.
//

#import "M6XIndexScrollHelper.h"

@implementation M6XIndexScrollHelper
- (NSInteger)indexWithOffsetX:(CGFloat)offsetX {
    if (self.pageWidth <= 0) {
        return 0;
    }
    
    NSInteger index = (NSInteger)(round(offsetX / self.pageWidth));
    
    return index;
}

@end
