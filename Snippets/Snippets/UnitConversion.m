//
//  UnitConversion.m
//  Snippets
//
//  Created by 刘永峰 on 2017/6/5.
//  Copyright © 2017年 Witgo. All rights reserved.
//

#import "UnitConversion.h"

/// 英寸比毫米
static CGFloat MM_PER_IN = 25.4;

/// PT比英寸
static CGFloat PT_PER_IN = 72.0;

@implementation UnitConversion

/**
 毫米转PT

 @param mm mm
 @return pt
 */
+ (CGFloat)mm2pt:(CGFloat)mm {
    return mm / MM_PER_IN * PT_PER_IN;
}

/**
 PT转毫米

 @param pt pt
 @return mm
 */
+ (CGFloat)pt2mm:(CGFloat)pt {
    return pt / PT_PER_IN * MM_PER_IN;
}

/**
 毫米转PT

 @param mmPoint mmPoint
 @return ptPoint
 */
+ (CGPoint)mmPoint2ptPoint:(CGPoint)mmPoint {
    return CGPointMake([self mm2pt:mmPoint.x], [self mm2pt:mmPoint.y]);
}

/**
 PT转毫米

 @param ptPoint ptPoint
 @return mmPoint
 */
+ (CGPoint)ptPoint2mmPoint:(CGPoint)ptPoint {
    return CGPointMake([self pt2mm:ptPoint.x], [self pt2mm:ptPoint.y]);
}

/**
 毫米转PT

 @param mmPoints mmPoints
 @return ptPoints
 */
+ (NSArray<NSValue *> *)mmPoints2ptPoints:(NSArray<NSValue *> *)mmPoints {
    NSMutableArray<NSValue *> *ptPoints = [NSMutableArray arrayWithCapacity:mmPoints.count];
    for (NSValue *mmPoint in mmPoints) {
        [ptPoints addObject:[NSValue valueWithCGPoint:[self mmPoint2ptPoint:mmPoint.CGPointValue]]];
    }
    return ptPoints;
}

/**
 PT转毫米

 @param ptPoints ptPoints
 @return mmPoints
 */
+ (NSArray<NSValue *> *)ptPoints2mmPoints:(NSArray<NSValue *> *)ptPoints {
    NSMutableArray<NSValue *> *mmPoints = [NSMutableArray arrayWithCapacity:ptPoints.count];
    for (NSValue *ptPoint in ptPoints) {
        [mmPoints addObject:[NSValue valueWithCGPoint:[self ptPoint2mmPoint:ptPoint.CGPointValue]]];
    }
    return mmPoints;
}
@end
