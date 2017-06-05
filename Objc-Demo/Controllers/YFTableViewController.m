//
//  YFTableViewController.m
//  Objc-Demo
//
//  Created by 刘永峰 on 2017/6/5.
//  Copyright © 2017年 Witgo. All rights reserved.
//



#import "YFTableViewController.h"

typedef NS_ENUM(NSUInteger, Moudle) {
    Module_HandPainting = 0
};

@interface YFTableViewController ()

@property (nonatomic, strong) NSArray<NSDictionary *> *dataList;

@end

@implementation YFTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 44;
}

#pragma mark - getter/setter
- (NSArray<NSDictionary *> *)dataList {
    if (!_dataList) {
        _dataList = @[@{@"module":@(Module_HandPainting),
                        @"name":@"手绘"}];
    }
    return _dataList;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [self.dataList[indexPath.row] objectForKey:@"name"];
    return cell;
}

@end
