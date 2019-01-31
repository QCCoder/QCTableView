//
//  UIScrollView+QCDataSource.h
//  QCTableView
//
//  Created by 钱城 on 2019/1/30.
//  Copyright © 2019 钱城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCDataSource.h"
#import "QCEmptySource.h"

typedef enum : NSUInteger {
    QCRefreshTypeRefresh,     //刷新数据
    QCRefreshTypeLoadNewData, //下啦刷新
    QCRefreshTypeLoadMore     //加载更多
} QCRefreshType;

typedef enum : NSUInteger {
    QCViewStateNormal = 0,   //正常
    QCViewStateLoading,  //加载中
    QCViewStateError,    //报错页
    QCViewStateEmpty     //空数据
} QCViewState;

@interface UIScrollView (QCDataSource)

@property (nonatomic,strong) QCDataSource *qc_dataSource;
    
@property (nonatomic,strong) QCEmptySource *qc_emptySource;

- (void)qc_addDataSourceAndEmptySourceWithIdentifier:(NSString *)identifier cellConfig:(QCCellForRowAtIndexPath)cellConfig didSelect:(QCDidSelectRowAtIndexPath)didSelect;
    
- (void)qc_reloadDataWithError:(NSString *)error;
- (void)qc_reloadDataWithEmpty:(NSString *)empty;
- (void)qc_reloadDataWithList:(NSArray *)data type:(QCRefreshType)type;
    
//下拉刷新
@property (nonatomic, copy) void (^qc_headerRefresh)(id view);
- (void)qc_loadData;
- (void)qc_loadDataWithAnimation;

//上拉加载更多，默认10，若不是10的倍数则会显示“没有更多数据”
@property (nonatomic,assign) NSInteger countPerPage;
@property (nonatomic, copy) void (^qc_footerRefresh)(id view);
- (void)qc_loadMoreData;
    
@property (nonatomic,copy) NSInteger (^qc_numberOfRowsInSection)(id view,NSInteger section,id model);
@property (nonatomic,copy) NSInteger (^qc_numberOfSectionsInView)(id view);

@property (nonatomic,copy) NSString *(^qc_titleForHeaderInSection)(id view,NSInteger section,id model);
@property (nonatomic,copy) NSString *(^qc_titleForFooterInSection)(id view,NSInteger section,id model);

@property (nonatomic,copy) BOOL (^qc_canEditRowAtIndexPath)(id view,NSIndexPath *indexPath);

@property (nonatomic,copy) CGFloat (^qc_heightForRowAtIndexPath)(id view,NSIndexPath *indexPath,id model);
@property (nonatomic,copy) CGFloat (^qc_heightForHeaderInSection)(id view,NSInteger section,id model);
@property (nonatomic,copy) CGFloat (^qc_heightForFooterInSection)(id view,NSInteger section,id model);

@property (nonatomic,copy) UIView *(^qc_viewForHeaderInSection)(id view,NSInteger section,id model);
@property (nonatomic,copy) UIView *(^qc_viewForFooterInSection)(id view,NSInteger section,id model);

@property (nonatomic,copy) void (^qc_emptyDataSetDidTapButton)(UIScrollView *scrollView,UIButton *button);
@property (nonatomic,copy) void (^qc_emptyDataSetDidTapView)(UIScrollView *scrollView,UIView *view);
    
@property (nonatomic,copy) QCEmptyModel *(^qc_emptyDataSetForLoading)(QCEmptyModel *model);
@property (nonatomic,copy) QCEmptyModel *(^qc_emptyDataSetForEmpty)(QCEmptyModel *model);
@property (nonatomic,copy) QCEmptyModel *(^qc_emptyDataSetForError)(QCEmptyModel *model);
    
@end
