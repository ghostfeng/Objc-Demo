//
//  Stroke.m
//  HandPainting
//
//  Created by 刘永峰 on 2017/6/5.
//  Copyright © 2017年 Witgo. All rights reserved.
//

#import "Stroke.h"

@interface Stroke() {
    NSMutableArray<NSValue *> *_points;
    // 最小的绘画移动单位，当移动大于该长度的时候则进行记录
    CGFloat DD;
}
/** 缓存的创建好的贝塞尔曲线 */
@property (nonatomic, strong) UIBezierPath *path;
/** 线条宽度 */
@property (nonatomic, assign) CGFloat lineWidth;

@end

@implementation Stroke

#pragma mark - getter/setter
- (instancetype)initWithColor:(UIColor *)color lineWidth:(CGFloat)lineWidth {
    if (self = [super init]) {
        self.color = color;
        self.lineWidth = lineWidth;
        DD = 3.0 / UIScreen.mainScreen.scale;
    }
    return self;
}

- (NSMutableArray<NSValue *> *)points {
    if (!_points) {
        _points = [[NSMutableArray alloc]init];
    }
    return _points;
}

- (UIBezierPath *)path {
    if (!_path) {
        _path = [[UIBezierPath alloc]init];
        _path.lineCapStyle = kCGLineCapRound;
        _path.lineJoinStyle = kCGLineJoinRound;
    }
    return _path;
}

/**
 笔划经过了点

 @param point 点
 */
- (void)passPoint:(CGPoint)point {
    if (!self.points.count) {
        self.path.lineWidth = self.lineWidth;
        [self.path moveToPoint:point];
        [self.path addLineToPoint:point];
        [self.points addObject:[NSValue valueWithCGPoint:point]];
    }
    CGPoint lastPoint = self.points.lastObject.CGPointValue;
    CGFloat dx = ABS(point.x - lastPoint.x);
    CGFloat dy = ABS(point.y - lastPoint.y);
    if (dx >= DD || dy >= DD) {
        [self.path addQuadCurveToPoint:CGPointMake((point.x + lastPoint.x) / 2.0, (point.y + lastPoint.y) / 2.0) controlPoint:lastPoint];
        [self.points addObject:[NSValue valueWithCGPoint:point]];
    }
}

/**
 绘画
 */
- (void)draw {
    if (self.path) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        if (context) {
            CGContextSetStrokeColorWithColor(context, self.color.CGColor);
        }
        [self.path stroke];
    }
}

@end
