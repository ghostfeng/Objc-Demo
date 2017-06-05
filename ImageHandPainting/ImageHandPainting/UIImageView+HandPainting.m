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

@interface PanWithStartGestureRecognizer : UIPanGestureRecognizer
@property (nonatomic) CGPoint start;
@property (nonatomic) CGPoint point;
@end

@implementation PanWithStartGestureRecognizer

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.start = [self locationInView:self.view];
    self.point = self.start;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.point = [self locationInView:self.view];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

@end


@interface TapWithStartGestureRecognizer : UITapGestureRecognizer
@property (nonatomic) CGPoint start;
@end

@implementation TapWithStartGestureRecognizer

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.start = [self locationInView:self.view];
}

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
- (void)panning:(PanWithStartGestureRecognizer *)pan {
    switch (pan.state) {
        case UIGestureRecognizerStateChanged:
            
            break;
            
        default:
            break;
    }
}

- (void)tapping:(TapWithStartGestureRecognizer *)tap {
    
}

#pragma mark - getter/setter

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

@implementation UIImageView (HandPainting)

- (HandPainting *)hp {
    return  (HandPainting *)objc_getAssociatedObject(self, @selector(hp));
}

- (void)setHp:(HandPainting *)hp {
    objc_setAssociatedObject(self, @selector(hp), hp, OBJC_ASSOCIATION_RETAIN);
}

@end
