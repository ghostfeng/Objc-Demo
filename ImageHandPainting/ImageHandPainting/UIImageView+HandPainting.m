//
//  UIImageView+HandPainting.m
//  ImageHandPainting
//
//  Created by 刘永峰 on 2017/6/5.
//  Copyright © 2017年 Witgo. All rights reserved.
//

#import "UIImageView+HandPainting.h"
#import "Stroke.h"
#import <objc/runtime.h>
#import <Foundation/Foundation.h>
#import <Snippets/Snippets.h>

@interface PanWithStartGestureRecognizer : UIPanGestureRecognizer
@property (nonatomic) CGPoint start;
@property (nonatomic) CGPoint point;
@end

@implementation PanWithStartGestureRecognizer

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    self.start = [self locationInView:self.view];
//}
//
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    self.point = [self locationInView:self.view];
//}
//
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    
//}

@end


@interface TapWithStartGestureRecognizer : UITapGestureRecognizer
@property (nonatomic) CGPoint start;
@end

@implementation TapWithStartGestureRecognizer

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    self.start = [self locationInView:self.view];
//}

@end

@interface HandPainting : NSObject <CALayerDelegate>

@property (nonatomic, strong) NSMutableArray<Stroke *> *redoList;
@property (nonatomic, strong) NSMutableArray<Stroke *> *strokes;
@property (nonatomic, strong) Stroke *currentStroke;
@property (nonatomic, strong) UIColor *currentColor;
@property (nonatomic, assign) CGFloat currentScale;
@property (nonatomic, assign) CGFloat abstractScale;
@property (nonatomic, weak) CALayer *drawLayer;
@property (nonatomic, strong) PanWithStartGestureRecognizer *pan;
@property (nonatomic, strong) TapWithStartGestureRecognizer *tap;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGFloat widthInMM;

@end

@implementation HandPainting
#pragma mark - 构造方法
- (instancetype)initWithImageView:(UIImageView *)imageView widthInMM:(CGFloat)widthInMM {
    if (self = [super init]) {
        self.imageView = imageView;
        self.widthInMM = widthInMM;
        
        self.currentColor = [UIColor redColor];
        self.currentScale = 1.0;
        self.abstractScale = 1.0;
    }
    return self;
}

#pragma mark - 行为识别
//画线
- (void)panning:(PanWithStartGestureRecognizer *)pan {
    switch (pan.state) {
        case UIGestureRecognizerStateChanged: {
            if (self.currentStroke.points.count == 0) {
                //画手指开始触摸的那一点
                CGPoint p = [self.drawLayer convertPoint:pan.start fromLayer:self.imageView.layer];
                // 将所画点的坐标按比例缩放
                [self.currentStroke passPoint:CGPointMake(p.x / self.currentScale, p.y / self.currentScale)];
            }
            //画手指移动的点
            CGPoint p = [self.drawLayer convertPoint:pan.point fromLayer:self.imageView.layer];
            // 将所画点的坐标按比例缩放
            [self.currentStroke passPoint:CGPointMake(p.x / self.currentScale, p.y / self.currentScale)];
            [self.drawLayer setNeedsDisplay];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            //画手指离开的点
            CGPoint p = [self.drawLayer convertPoint:pan.point fromLayer:self.imageView.layer];
            [self.currentStroke passPoint:CGPointMake(p.x / self.currentScale, p.y / self.currentScale)];
            [self.strokes addObject:self.currentStroke];
            self.currentStroke = nil;
            [self.drawLayer setNeedsDisplay];
        }
            break;
        default:
            break;
    }
}

//画点
- (void)tapping:(TapWithStartGestureRecognizer *)tap {
    switch (tap.state) {
        case UIGestureRecognizerStateEnded: {
            CGPoint p = [self.drawLayer convertPoint:tap.start fromLayer:self.imageView.layer];
            [self.currentStroke passPoint:CGPointMake(p.x / self.currentScale, p.y / self.currentScale)];
            [self.strokes addObject:self.currentStroke];
            self.currentStroke = nil;
            [self.drawLayer setNeedsDisplay];
        }
            break;
        default:
            break;
    }
}

#pragma mark - CALayerDelegate
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    UIGraphicsPushContext(ctx);
    nob_defer(^{
        UIGraphicsPopContext();
    });
    CGContextScaleCTM(ctx, self.currentScale, self.currentScale);
    
    [self drawStrokes];
}

/**
 绘制所有笔划
 */
- (void)drawStrokes {
    [self drawInit];

    for (Stroke *stroke in self.strokes) {
        [stroke draw];
    }
    if (self.currentStroke && self.currentStroke.points.count) {
        [self.currentStroke draw];
    }
}

- (void)drawInit {
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context) {
        CGContextSetAllowsAntialiasing(context, true);
        CGContextSetShouldAntialias(context, true);
        CGContextSetAllowsFontSmoothing(context, true);
        CGContextSetShouldSmoothFonts(context, true);
    }
}

/**
 重置绘画状态
 */
- (void)reset4Painting{
    CGFloat width = self.imageView.image.size.width;
    CGFloat height = self.imageView.image.size.height;
    
    // 检测纵向填满
    CGFloat newHeight = self.imageView.layer.bounds.size.height;
    CGFloat newWidth = width * self.imageView.layer.bounds.size.height / height;
    
    if (newWidth > self.imageView.layer.bounds.size.width) {
        // 检测横向填满
        newHeight = height * self.imageView.layer.bounds.size.width / width;
        newWidth = self.imageView.layer.bounds.size.width;
    }
    self.currentScale = newWidth / width;
    
    skipAnimation(^{
        self.drawLayer.contentsScale = self.abstractScale * UIScreen.mainScreen.scale;
        self.drawLayer.position = CGPointMake(CGRectGetMidX(self.imageView.layer.bounds), CGRectGetMidY(self.imageView.layer.bounds));
        self.drawLayer.bounds = CGRectMake(0, 0, newWidth, newHeight);
        
    });
    [self.drawLayer setNeedsDisplay];
}

#pragma mark - getter/setter

- (Stroke *)currentStroke {
    if (!_currentStroke) {
        _currentStroke = [[Stroke alloc]initWithColor:self.currentColor lineWidth:[UnitConversion mm2pt:self.widthInMM] / self.currentScale/ self.abstractScale];
    }
    return _currentStroke;
}

- (NSMutableArray<Stroke *> *)redoList {
    if (!_redoList) {
        _redoList = [[NSMutableArray alloc]init];
    }
    return _redoList;
}

- (NSMutableArray<Stroke *> *)strokes {
    if (!_strokes) {
        _strokes = [[NSMutableArray alloc]init];
    }
    return _strokes;
}

- (PanWithStartGestureRecognizer *)pan {
    if (!_pan) {
        _pan = [[PanWithStartGestureRecognizer alloc]initWithTarget:self action:@selector(panning:)];
        _pan.maximumNumberOfTouches = 1;
    }
    return _pan;
}

- (TapWithStartGestureRecognizer *)tap {
    if (!_tap) {
        _tap = [[TapWithStartGestureRecognizer alloc]initWithTarget:self action:@selector(tapping:)];
        [_tap requireGestureRecognizerToFail:self.pan];
    }
    return _tap;
}

@end

@interface UIImageView()

/** 手绘操作对象 */
@property (nonatomic, strong) HandPainting *hp;

@end

@implementation UIImageView (HandPainting)

- (HandPainting *)hp {
    return  (HandPainting *)objc_getAssociatedObject(self, @selector(hp));
}

- (void)setHp:(HandPainting *)hp {
    objc_setAssociatedObject(self, @selector(hp), hp, OBJC_ASSOCIATION_RETAIN);
}

/**
 初始化绘图图层(注：在设置了Image之后，只能调用一次)

 @param widthInMM 标注的宽度，单位毫米
 */
- (void)hp_initWidthInMM:(CGFloat)widthInMM {
    self.userInteractionEnabled = true;
    self.clipsToBounds = true;
    
    self.hp = [[HandPainting alloc] initWithImageView:self widthInMM:widthInMM];
    CALayer *drawLayer = [[CALayer alloc] init];
    drawLayer.delegate = self.hp;
    self.hp.drawLayer = drawLayer;
    [self.layer addSublayer:self.hp.drawLayer];
    [self.hp reset4Painting];
}

/**
 进入绘图页面时选中某种颜色

 @param color 颜色
 @param abstractScale 图片所在滑动视图的scale
 */
- (void)hp_chooseWithColor:(UIColor *)color abstractScale:(CGFloat)abstractScale {
    if (self.hp) {
        self.hp.currentColor =  color;
        [self.hp setAbstractScale:abstractScale];
        
        [self removeGestureRecognizer:self.hp.pan];
        [self removeGestureRecognizer:self.hp.tap];
        [self addGestureRecognizer:self.hp.pan];
        [self addGestureRecognizer:self.hp.tap];
    }
}

/**
 离开绘图页面时取消选中某种颜色
 */
- (void)hp_unchoose {
    if (self.hp) {
        [self removeGestureRecognizer:self.hp.pan];
        [self removeGestureRecognizer:self.hp.tap];
    }
}

/**
 撤销绘图
 */
- (void)hp_undo {
    if (self.hp && self.hp.strokes.count > 0) {
        [self.hp.redoList addObject:self.hp.strokes.lastObject];
        [self.hp.strokes removeLastObject];
        [self.hp reset4Painting];
    }
}

/**
 是否画过笔划

 @return 是否画过笔划
 */
- (BOOL)hp_hasStrokes {
    return self.hp && self.hp.strokes.count > 0;
}

/**
 重新计算缩放比等绘制参数
 */
- (void)hp_reset4Painting{
    if (self.hp) {
        [self.hp reset4Painting];
    }
}

/**
 设置缩放比

 @param abstractScale 绝对的缩放比
 */
- (void)hp_setAbstractScale:(CGFloat)abstractScale {
    if (self.hp) {
        [self.hp setAbstractScale:abstractScale];
    }
}

#pragma mark - CALayerDelegate
/**
 布局图层

 @param layer 图层
 */
- (void)layoutSublayersOfLayer:(CALayer *)layer{
    [self hp_reset4Painting];
//    [super layoutSublayersOfLayer:layer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    self.hp.pan.start = [self.hp.pan locationInView:self];
    self.hp.pan.point = self.hp.pan.start;
    
    self.hp.tap.start = [self.hp.tap locationInView:self];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    self.hp.pan.point = [self.hp.pan locationInView:self];
}


@end
