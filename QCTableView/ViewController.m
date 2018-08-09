//
//  ViewController.m
//  QCTableView
//
//  Created by 钱城 on 2018/6/28.
//  Copyright © 2018年 钱城. All rights reserved.
//

#import "ViewController.h"
#import "QCTableView.h"
#import "DGActivityIndicatorView.h"
#import "Masonry.h"

@interface ViewController ()<QCTableViewDelegate,QCTableViewDataSource,QCTableViewAbnormalDelegate>

@property (weak, nonatomic) QCTableView *tableVIew;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    QCTableView *tableView = [[QCTableView alloc] initWithFrame:CGRectMake(0, 0, 375, 667) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.qcDataSource = self;
    tableView.qcDelegate = self;
    tableView.qcAbnormalDelegate = self;
    __weak __typeof__(self) weakSelf = self;
    tableView.headerRefresh = ^(QCTableView *tableView) {
        [weakSelf loadData];
    };
    [tableView loadHeaderDataWithAnimation];
    self.tableVIew = tableView;
}

- (void)loadData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableVIew refreshWithError:@"加载错误"];
//        [self.tableVIew refreshWithList:@[@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1"] refreshType:QCRefreshTypeRefresh];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)qcTableView:(QCTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UITableViewCell new];
}

//-(UIView *)qcTableView:(QCTableView *)tableView customViewForAbnormalView:(QCTableViewState)state{
//    if (state == QCTableViewStateLoading) {
//        CGSize size = [[UIScreen mainScreen] bounds].size;
//
//        UIView *purpleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 200)];
//        purpleView.backgroundColor = [UIColor purpleColor];
//
//        CGFloat width = size.width  / 3.0f;
//        CGFloat height = size.height / 5.0f;
//
//        DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallSpinFadeLoader tintColor:[UIColor redColor] size:70];
//        activityIndicatorView.frame = CGRectMake(305 * 0.5, 0, 70, 70);
//        [purpleView addSubview:activityIndicatorView];
//
//        return purpleView;
//    }
//
//    return nil;
//}


@end
