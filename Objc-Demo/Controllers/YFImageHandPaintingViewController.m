//
//  YFImageHandPaintingViewController.m
//  Objc-Demo
//
//  Created by 刘永峰 on 2017/6/6.
//  Copyright © 2017年 Witgo. All rights reserved.
//

#import "YFImageHandPaintingViewController.h"
#import <ImageHandPainting/ImageHandPainting.h>

@interface YFImageHandPaintingViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation YFImageHandPaintingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 320, 320)];
    self.imageView.image = [UIImage imageNamed:@"1"];
    [self.view addSubview:self.imageView];
    [self.imageView hp_initWidthInMM:2.0];
    [self.imageView hp_chooseWithColor:[UIColor redColor] abstractScale:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
