//
//  QCTableView.h
//  QCTableView
//
//  Created by 钱城 on 2018/6/28.
//  Copyright © 2018年 钱城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "QCListUtil.h"
#import "QCAbnormalModel.h"

typedef enum : NSUInteger {
    QCRefreshTypeRefresh,     //刷新数据
    QCRefreshTypeLoadNewData, //下啦刷新
    QCRefreshTypeLoadMore     //加载更多
} QCRefreshType;

typedef enum : NSUInteger {
    QCTableViewStateNormal,   //正常
    QCTableViewStateLoading,  //加载中
    QCTableViewStateError,    //报错页
    QCTableViewStateEmpty     //空数据
} QCTableViewState;

@class QCTableView;
@protocol QCTableViewDelegate <NSObject>
@optional
// Variable height support
- (CGFloat)qcTableView:(QCTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)qcTableView:(QCTableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)qcTableView:(QCTableView *)tableView heightForFooterInSection:(NSInteger)section;

// Section header & footer information. Views are preferred over title should you decide to provide both
- (nullable UIView *)qcTableView:(QCTableView *)tableView viewForHeaderInSection:(NSInteger)section;
- (nullable UIView *)qcTableView:(QCTableView *)tableView viewForFooterInSection:(NSInteger)section;

@end

@protocol QCTableViewDataSource <NSObject>
@required

- (UITableViewCell *)qcTableView:(QCTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (NSInteger)qcTableView:(QCTableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (NSInteger)numberOfSectionsInQcTableView:(QCTableView *)tableView;

@end

@protocol QCTableViewAbnormalDelegate <NSObject>

@optional

//content
- (QCAbnormalModel *)qcTableView:(QCTableView *)tableView modelForAbnormalView:(QCAbnormalModel *)abnormalModel state:(QCTableViewState)state;
- (nullable UIView *)qcTableView:(QCTableView *)tableView customViewForAbnormalView:(QCTableViewState)state;

//tap
- (void)qcTableView:(QCTableView *)tableView didTapButtonForAbnormalView:(QCTableViewState)state;
- (void)qcTableView:(QCTableView *)tableView didTapViewForAbnormalView:(UIView *)view state:(QCTableViewState)state;

@end

@interface QCTableView : UITableView

@property (nonatomic, weak) id<QCTableViewDelegate> qcDelegate;

@property (nonatomic, weak) id<QCTableViewDataSource> qcDataSource;

@property (nonatomic, weak) id<QCTableViewAbnormalDelegate> qcAbnormalDelegate;

/**
 *  数组存放数据，若数组为空则显示无数据界面
 */
@property (nonatomic, strong) NSArray *datalist;

/**
 *  请求错误时调用,错误界面将会显示error.domain中的文字内容
 */
- (void)refreshWithError:(NSString *)error;

/**
 *  请求成功时调用，传入数组.
 *  若 data,count = 0 显示无数据界面
 */
- (void)refreshWithList:(NSArray *)data refreshType:(QCRefreshType)type;

/**
 *  获取新数据，刷新时会调用这个block
 *  当设置requestMoreData这个属性时，列表会自动加上上拉刷新
 */
@property (nonatomic, copy) void (^headerRefresh)(QCTableView *tableView);
- (void)removeHeaderRefreshView;

/**
 *  获取更多数据，上拉加载更对数据时会调用这个block
 *  当设置requestMoreData这个属性时，列表会自动加上下拉加载
 */
@property (nonatomic, copy) void (^footerRefresh)(QCTableView *tableView);
- (void)removeFooterRefreshView;

- (void)registerNibName:(NSString *)nibName identifier:(NSString *)identifier;
- (void)registerClassName:(NSString *)className identifier:(NSString *)identifier;

/**
 *  开始加载数据
 */
-(void)loadHeaderData;

/**
 *  开始加载数据
 */
-(void)loadFooterData;

//每页加载数据量，默认20
@property (nonatomic,assign) NSInteger countPerPage;

@end

