//
//  UnitConversion.h
//  Snippets
//
//  Created by 刘永峰 on 2017/6/5.
//  Copyright © 2017年 Witgo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface UnitConversion : NSObject

/**
 毫米转PT
 
 @param mm mm
 @return pt
 */
+ (CGFloat)mm2pt:(CGFloat)mm;

/**
 PT转毫米
 
 @param pt pt
 @return mm
 */
+ (CGFloat)pt2mm:(CGFloat)pt;

/**
 毫米转PT
 
 @param mmPoint mmPoint
 @return ptPoint
 */
+ (CGPoint)mmPoint2ptPoint:(CGPoint)mmPoint;

/**
 PT转毫米
 
 @param ptPoint ptPoint
 @return mmPoint
 */
+ (CGPoint)ptPoint2mmPoint:(CGPoint)ptPoint;

/**
 毫米转PT
 
 @param mmPoints mmPoints
 @return ptPoints
 */
+ (NSArray<NSValue *> *)mmPoints2ptPoints:(NSArray<NSValue *> *)mmPoints;

/**
 PT转毫米
 
 @param ptPoints ptPoints
 @return mmPoints
 */
+ (NSArray<NSValue *> *)ptPoints2mmPoints:(NSArray<NSValue *> *)ptPoints;

@end
