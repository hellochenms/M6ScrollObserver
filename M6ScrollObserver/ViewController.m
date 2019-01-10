//
//  ViewController.m
//  M6ScrollObserver
//
//  Created by Chen,Meisong on 2019/1/10.
//  Copyright © 2019年 xyz.chenms. All rights reserved.
//

#import "ViewController.h"
#import "M4TempListGenerator.h"
#import "M6OffsetScrollObserver.h"
#import "M6YProgressScrollObserver.h"

static NSString * const kCellIdentifier = @"kCellIdentifier";

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray<NSString *> *datas;
@property (nonatomic) M6OffsetScrollObserver *offsetScrollObserver;
@property (nonatomic) M6YProgressScrollObserver * yProgressScrollObserver;
@property (nonatomic) UIView *someView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.tableView];
    [self.yProgressScrollObserver attachToScrollView:self.tableView];
    
    [self.view addSubview:self.someView];
}

- (void)viewDidLayoutSubviews {
    NSLog(@"【m2】  %s", __func__);
    self.tableView.frame = self.view.bounds;
    self.someView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 60);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.datas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    NSString *data = self.datas[indexPath.row];
    cell.textLabel.text = data;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

#pragma mark - Life Cycle
- (void)dealloc {
    [self.yProgressScrollObserver detach];
}

#pragma mark - Getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    }
    return _tableView;
}

- (NSArray<NSString *> *)datas {
    if(!_datas){
        _datas = [M4TempListGenerator indexArrayForCount:40];
    }

    return _datas;
}

- (M6OffsetScrollObserver *)offsetScrollObserver {
    if(!_offsetScrollObserver){
        _offsetScrollObserver = [M6OffsetScrollObserver new];
        __weak typeof(self) weakSelf = self;
        _offsetScrollObserver.callback = ^(CGPoint offset) {
//            NSLog(@"【m2】offset:%@  %s", NSStringFromCGPoint(offset), __func__);
            CGRect someViewFrame = weakSelf.someView.frame;
            someViewFrame.origin.y = offset.y;
            weakSelf.someView.frame = someViewFrame;
        };
    }

    return _offsetScrollObserver;
}

- (UIView *)someView{
    if(!_someView){
        _someView = [[UIView alloc] init];
        _someView.backgroundColor = [UIColor blueColor];
    }
    return _someView;
}

- (M6YProgressScrollObserver *)yProgressScrollObserver {
    if(!_yProgressScrollObserver){
        _yProgressScrollObserver = [M6YProgressScrollObserver new];
        _yProgressScrollObserver.progress0OffsetY = 0;
        _yProgressScrollObserver.progress1OffsetY = 200;
        __weak typeof(self) weakSelf = self;
        _yProgressScrollObserver.callback = ^(CGFloat progress) {
//            NSLog(@"【m2】progress:%.1f  %s", progress, __func__);
            CGRect someViewFrame = weakSelf.someView.frame;
            someViewFrame.origin.y = 0 + 200 * progress;
            weakSelf.someView.frame = someViewFrame;
        };
    }

    return _yProgressScrollObserver;
}
@end
