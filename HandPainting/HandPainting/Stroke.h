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
 笔划样式

 - StrokeStylePen: 画笔
 - StrokeStyleEraser: 橡皮
 */
typedef NS_ENUM(NSInteger, StrokeStyle) {
    StrokeStylePen = 0,
    StrokeStyleEraser
};

/**
 笔划
 */
@interface Stroke : NSObject

/** 颜色 */
@property (nonatomic, strong) UIColor *color;
/** 笔划样式 */
@property (nonatomic, assign) StrokeStyle style;
/** 线条宽度 */
@property (nonatomic, assign) CGFloat lineWidth;
/** 笔划经过的点的集合 */
@property (nonatomic, strong, readonly) NSMutableArray<NSValue *> *points;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithStyle:(StrokeStyle)style lineWidth:(CGFloat)lineWidth;

/**
 笔划经过了点
 
 @param point 点
 */
- (void)passPoint:(CGPoint)point;

/**
 绘画
 */
- (void)draw;

@end
