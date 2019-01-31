//
//  ViewController.m
//  QCTableView
//
//  Created by 钱城 on 2018/6/28.
//  Copyright © 2018年 钱城. All rights reserved.
//

#import "ViewController.h"
#import "DGActivityIndicatorView.h"
#import "UITableView+QCDataSource.h"
@interface ViewController ()

//@property (weak, nonatomic) QCTableView *tableVIew;
@property (weak, nonatomic) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"QCTableViewCell"];
    self.tableView = tableView;

    [tableView qc_addDataSourceAndEmptySourceWithIdentifier:@"QCTableViewCell" cellConfig:^(UITableViewCell *cell, NSIndexPath *indexPath, id sectionModel) {
        cell.textLabel.text = [NSString stringWithFormat:@"第%ld行 第%ld列",indexPath.section,indexPath.row];
    } didSelect:^(id view, NSIndexPath *indexPath, id sectionModel) {
        NSLog(@"didSelect");
        if (indexPath.row == 0) {
            [tableView qc_reloadDataWithList:@[@"列表",@"失败",@"空白页",@"加载动画"] type:QCRefreshTypeRefresh];
        }else if (indexPath.row == 1) {
            [tableView qc_reloadDataWithError:@"请求失败"];
        }else if (indexPath.row == 2) {
            [tableView qc_reloadDataWithList:@[] type:QCRefreshTypeRefresh];
        }else{
            [tableView qc_loadDataWithAnimation];
        }
    }];

//    tableView.qc_emptyDataSetForError = ^QCEmptyModel *(QCEmptyModel *model) {
//        model.spaceHeight = 100;
//        return model;
//    };
//    tableView.qc_emptyDataSetForLoading = ^QCEmptyModel *(QCEmptyModel *model) {
//        model.spaceHeight = 100;
//        return model;
//    };
//    tableView.qc_emptyDataSetForEmpty = ^QCEmptyModel *(QCEmptyModel *model) {
//        model.spaceHeight = 100;
//        return model;
//    };
    
    tableView.qc_headerRefresh = ^(UITableView *tableView) {
        [tableView qc_reloadDataWithList:@[@"列表",@"失败",@"空白页",@"加载动画"] type:QCRefreshTypeRefresh];
    };
    [tableView qc_loadData];
    
//    tableView.qc_emptyDataSetDidTapView = ^(UIScrollView *scrollView, UIView *view) {
//        NSLog(@"空白页点击");
//    };
}

@end
