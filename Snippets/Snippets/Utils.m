//
//  Utils.m
//  Snippets
//
//  Created by 刘永峰 on 2017/6/6.
//  Copyright © 2017年 Witgo. All rights reserved.
//

#import "Utils.h"

void skipAnimation(void (^completion)()) {
    [CATransaction begin];
    nob_defer(^{
        [CATransaction commit];
    });
    [CATransaction setDisableActions:true];
    if (completion) {
        completion();
    }
}
