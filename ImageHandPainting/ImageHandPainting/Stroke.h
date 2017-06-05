//
//  Stroke.h
//  HandPainting
//
//  Created by 刘永峰 on 2017/6/5.
//  Copyright © 2017年 Witgo. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 笔划
 */
@interface Stroke : NSObject

/** 颜色 */
@property (nonatomic, strong) UIColor *color;
/** 笔划经过的点的集合 */
@property (nonatomic, strong, readonly) NSMutableArray<NSValue *> *points;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithColor:(UIColor *)color lineWidth:(CGFloat)lineWidth;

/**
 笔划经过了点
 
 @param point 点
 */
- (void)passPoints:(CGPoint)point;

/**
 绘画
 */
- (void)draw;

@end
