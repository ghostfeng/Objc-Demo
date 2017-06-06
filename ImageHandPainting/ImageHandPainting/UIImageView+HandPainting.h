//
//  UIImageView+HandPainting.h
//  ImageHandPainting
//
//  Created by 刘永峰 on 2017/6/5.
//  Copyright © 2017年 Witgo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HandPainting;

@interface UIImageView (HandPainting)

/** 手绘操作对象 */
@property (nonatomic, strong) HandPainting *hp;

/**
 初始化绘图图层(注：在设置了Image之后，只能调用一次)
 
 @param widthInMM 标注的宽度，单位毫米
 */
- (void)hp_initWidthInMM:(CGFloat)widthInMM;

/**
 进入绘图页面时选中某种颜色
 
 @param color 颜色
 @param abstractScale 图片所在滑动视图的scale
 */
- (void)hp_chooseWithColor:(UIColor *)color abstractScale:(CGFloat)abstractScale;

/**
 离开绘图页面时取消选中某种颜色
 */
- (void)hp_unchoose;

/**
 撤销绘图
 */
- (void)hp_undo;

/**
 是否画过笔划
 
 @return 是否画过笔划
 */
- (BOOL)hp_hasStrokes;

/**
 重新计算缩放比等绘制参数
 */
- (void)hp_reset4Painting;

/**
 设置缩放比
 
 @param abstractScale 绝对的缩放比
 */
- (void)hp_setAbstractScale:(CGFloat)abstractScale;

@end
