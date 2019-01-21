//
//  M6ProgressColorTabHelper.m
//  M6ScrollObserver
//
//  Created by Chen,Meisong on 2019/1/21.
//  Copyright © 2019年 xyz.chenms. All rights reserved.
//

#import "M6ProgressColorTabHelper.h"

@interface M6ProgressColorTabHelper ()
@property (nonatomic) NSArray *normalColorRGB;
@property (nonatomic) NSArray *selectedColorRGB;
@property (nonatomic) NSArray *deltaRGB;
@end

@implementation M6ProgressColorTabHelper
- (instancetype)init {
    self = [super init];
    if (self) {
        [self updateNormalColor:[UIColor grayColor]
                  selectedColor:[UIColor blackColor]];
    }
    
    return self;
}

- (void)updateNormalColor:(UIColor *)normalColor
            selectedColor:(UIColor *)selectedColor {
    NSAssert(normalColor != nil, @"normalColor不能为空");
    NSAssert(selectedColor != nil, @"selectedColor不能为空");
    
    self.normalColorRGB = [self colorRGB:normalColor];
    self.selectedColorRGB = [self colorRGB:selectedColor];
    CGFloat deltaR = [self.selectedColorRGB[0] floatValue] - [self.normalColorRGB[0] floatValue];
    CGFloat deltaG = [self.selectedColorRGB[1] floatValue] - [self.normalColorRGB[1] floatValue];
    CGFloat deltaB = [self.selectedColorRGB[2] floatValue] - [self.normalColorRGB[2] floatValue];
    self.deltaRGB = [NSArray arrayWithObjects:@(deltaR), @(deltaG), @(deltaB), nil];
}

- (M6CurrentColors *)currentColorsWithProgress:(CGFloat)progress {
    UIColor *fromColor = [UIColor colorWithRed:[self.normalColorRGB[0] floatValue] + [self.deltaRGB[0] floatValue] * (1 - progress)
                                         green:[self.normalColorRGB[1] floatValue] + [self.deltaRGB[1] floatValue] * (1 - progress)
                                          blue:[self.normalColorRGB[2] floatValue] + [self.deltaRGB[2] floatValue] * (1 - progress)
                                         alpha:1];
    
    UIColor *toColor = [UIColor colorWithRed:[self.normalColorRGB[0] floatValue] + [self.deltaRGB[0] floatValue] * progress
                                       green:[self.normalColorRGB[1] floatValue] + [self.deltaRGB[1] floatValue] * progress
                                        blue:[self.normalColorRGB[2] floatValue] + [self.deltaRGB[2] floatValue] * progress
                                       alpha:1];
    
    M6CurrentColors *currentColors = [M6CurrentColors new];
    currentColors.currentFromColor = fromColor;
    currentColors.currentToColor = toColor;
    
    return currentColors;
}

#pragma mark - Tools
- (NSArray *)colorRGB:(UIColor *)color {
    size_t count = CGColorGetNumberOfComponents(color.CGColor);
    NSArray *colorRGB = nil;
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    if (count == 4) {
        colorRGB = [NSArray arrayWithObjects:@(components[0]), @(components[1]), @(components[2]), nil];
    } else if (count == 2) {
        colorRGB = [NSArray arrayWithObjects:@(components[0]), @(components[0]), @(components[0]), nil];
    } else {}
    
    return colorRGB;
}

@end

@implementation M6CurrentColors
@end
