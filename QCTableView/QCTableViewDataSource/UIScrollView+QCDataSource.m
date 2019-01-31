//
//  UIScrollView+QCDataSource.m
//  QCTableView
//
//  Created by 钱城 on 2019/1/30.
//  Copyright © 2019 钱城. All rights reserved.
//

#import "UIScrollView+QCDataSource.h"
#import "QCDataSource.h"
#import <objc/runtime.h>
#import "MJRefresh.h"

@interface UIScrollView ()

@property (nonatomic,assign) QCViewState state;

@end

@implementation UIScrollView (QCDataSource)


- (void)qc_addDataSourceAndEmptySourceWithIdentifier:(NSString *)identifier cellConfig:(QCCellForRowAtIndexPath)cellConfig didSelect:(QCDidSelectRowAtIndexPath)didSelect{
    
    self.qc_dataSource = [[QCDataSource alloc] initWithIdentifier:identifier cellConfig:cellConfig didSelect:didSelect];
    self.countPerPage = 10;
    
    self.state = QCViewStateLoading;

    [self configBlock];
    
    if ([self respondsToSelector:@selector(setDataSource:)]) {
        [self setValue:self.qc_dataSource forKey:@"delegate"];
    }
    if ([self respondsToSelector:@selector(setDataSource:)]) {
        [self setValue:self.qc_dataSource forKey:@"dataSource"];
    }
    
    self.emptyDataSetSource = self.qc_emptySource;
    self.emptyDataSetDelegate = self.qc_emptySource;
    
    [self reloadEmptyDataSet];
}
    
- (void)configBlock{
    self.qc_dataSource.numberOfRowsInSection = self.qc_numberOfRowsInSection;
    self.qc_dataSource.numberOfSectionsInView = self.qc_numberOfSectionsInView;
    self.qc_dataSource.titleForHeaderInSection = self.qc_titleForHeaderInSection;
    self.qc_dataSource.titleForFooterInSection = self.qc_titleForFooterInSection;
    self.qc_dataSource.canEditRowAtIndexPath = self.qc_canEditRowAtIndexPath;
    self.qc_dataSource.heightForRowAtIndexPath = self.qc_heightForRowAtIndexPath;
    self.qc_dataSource.heightForHeaderInSection = self.qc_heightForHeaderInSection;
    self.qc_dataSource.heightForFooterInSection = self.qc_heightForFooterInSection;
    self.qc_dataSource.viewForFooterInSection = self.qc_viewForFooterInSection;
    self.qc_dataSource.viewForHeaderInSection = self.qc_viewForHeaderInSection;
    
    self.qc_emptySource.emptyDataSetForLoading = self.qc_emptyDataSetForLoading;
    self.qc_emptySource.emptyDataSetForError = self.qc_emptyDataSetForError;
    self.qc_emptySource.emptyDataSetForEmpty = self.qc_emptyDataSetForEmpty;
    
    if (self.qc_emptyDataSetDidTapView) {
        self.qc_emptySource.emptyDataSetDidTapView = self.qc_emptyDataSetDidTapView;
    }else{
        __weak __typeof__(self) weakSelf = self;
        self.qc_emptySource.emptyDataSetDidTapView = ^(UIScrollView *scrollView, UIView *view) {
            [weakSelf qc_loadData];
        };
    }
    if (self.qc_emptyDataSetDidTapButton) {
        self.qc_emptySource.emptyDataSetDidTapButton = self.qc_emptyDataSetDidTapButton;
    }else{
        __weak __typeof__(self) weakSelf = self;
        self.qc_emptySource.emptyDataSetDidTapButton = ^(UIScrollView *scrollView, UIButton *button) {
            [weakSelf qc_loadData];
        };
    }
}

- (void)qc_reloadData:(NSString *)msg{
    [self refreshHeader];
    [self refreshFooter];
    
    if (self.state == QCViewStateLoading) {
        [self.qc_emptySource qc_reloadEmptyDataWithLoading:msg];
    }else if (self.state == QCViewStateEmpty) {
        [self.qc_emptySource qc_reloadEmptyDataWithEmpty:msg];
    }else if (self.state == QCViewStateError) {
        [self.qc_emptySource qc_reloadEmptyDataWithError:msg];

    }
    
    if (self.state == QCViewStateNormal && [self respondsToSelector:NSSelectorFromString(@"reloadData")]) {
        [self performSelector:NSSelectorFromString(@"reloadData") withObject:nil];
    }else{
        [self.qc_dataSource reloadDataWithList:nil];
        [self reloadEmptyDataSet];
    }
}

- (void)qc_reloadDataWithList:(NSArray *)data type:(QCRefreshType)type{
    if (!data) {
        data = [NSArray array];
    }
    
    NSMutableArray *datalist = [NSMutableArray arrayWithArray:self.qc_dataSource.dataArray];
    switch (type) {
        case QCRefreshTypeRefresh:
            datalist = [NSMutableArray arrayWithArray:data];
            break;
        case QCRefreshTypeLoadNewData:{
            NSRange range = NSMakeRange(0, data.count);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [datalist insertObjects:data atIndexes:indexSet];
            break;
        }
        case QCRefreshTypeLoadMore:
            [datalist addObjectsFromArray:data];
            break;
        default:
            break;
    }
    
    [self.qc_dataSource reloadDataWithList:datalist];
    if (self.qc_dataSource.dataArray.count == 0) {
        self.state = QCViewStateEmpty;
    }else{
        self.state = QCViewStateNormal;
    }
    [self qc_reloadData:nil];
}
    
- (void)refreshHeader {
    if (self.mj_header && self.state != QCViewStateLoading) {
        [self.mj_header endRefreshing];
    }
}
- (void)refreshFooter {
    if (self.mj_footer) {
        [self.mj_footer endRefreshing];
    }
    
    if (self.qc_dataSource.dataArray.count % self.countPerPage == 0 && self.qc_dataSource.dataArray.count > 0) { //还有更多有数据
        [self.mj_footer resetNoMoreData];
    } else { //没有更多内容
        [self.mj_footer endRefreshingWithNoMoreData];
    }
}
- (void)qc_loadData{
    if (self.qc_headerRefresh != nil) {
        self.qc_headerRefresh(self);
    }
}

-(void)qc_loadDataWithAnimation{
    self.state = QCViewStateLoading;
    [self qc_reloadData:@"加载中"];
    [self qc_loadData];
}
    
-(void)qc_reloadDataWithError:(NSString *)error{
    self.state = QCViewStateError;
    [self qc_reloadData:error];
}
    
-(void)qc_reloadDataWithEmpty:(NSString *)empty{
    self.state = QCViewStateError;
    [self qc_reloadData:empty];
}
    
- (void)qc_loadMoreData {
    if (self.qc_footerRefresh) {
        self.qc_footerRefresh(self);
    }
}
    
#pragma mark get & set
- (id)getAssociatedObject:(const void * _Nonnull )key{
    return objc_getAssociatedObject(self,key);
}
- (void)setAssociatedObject:(const void * _Nonnull )key value:(id _Nullable)value policy:(objc_AssociationPolicy)policy{
    objc_setAssociatedObject(self,key, value, policy);
    [self configBlock];
}
    
- (QCViewState)state{
    NSNumber *number = [self getAssociatedObject:@"state"];
    return [[self getAssociatedObject:@"state"] integerValue];
}
- (void)setState:(QCViewState)state{
    NSNumber *number = [NSNumber numberWithLong:state];
    [self setAssociatedObject:@"state" value:[NSNumber numberWithLong:state] policy:OBJC_ASSOCIATION_ASSIGN];
}
    
- (NSInteger (^)(id, NSInteger, id))qc_numberOfRowsInSection{
    return [self getAssociatedObject:@"qc_numberOfRowsInSection"];
}
- (void)setQc_numberOfRowsInSection:(NSInteger (^)(id, NSInteger, id))qc_numberOfRowsInSection{
    [self setAssociatedObject:"qc_numberOfRowsInSection" value:qc_numberOfRowsInSection policy:OBJC_ASSOCIATION_ASSIGN];
}
    
- (NSInteger (^)(id))qc_numberOfSectionsInView{
    return [self getAssociatedObject:"qc_numberOfSectionsInView"];
}
- (void)setQc_numberOfSectionsInView:(NSInteger (^)(id))qc_numberOfSectionsInView{
    [self setAssociatedObject:"qc_numberOfSectionsInView" value:qc_numberOfSectionsInView policy:OBJC_ASSOCIATION_ASSIGN];
}
    
- (NSString *(^)(id, NSInteger, id))qc_titleForHeaderInSection{
    return [self getAssociatedObject:"qc_titleForHeaderInSection"];
}
- (void)setQc_titleForHeaderInSection:(NSString *(^)(id, NSInteger, id))qc_titleForHeaderInSection{
    [self setAssociatedObject:"qc_titleForHeaderInSection" value:qc_titleForHeaderInSection policy:OBJC_ASSOCIATION_COPY];
}
    
- (NSString *(^)(id, NSInteger, id))qc_titleForFooterInSection{
    return [self getAssociatedObject:"qc_titleForFooterInSection"];
}
- (void)setQc_titleForFooterInSection:(NSString *(^)(id, NSInteger, id))qc_titleForFooterInSection{
    [self setAssociatedObject:"qc_titleForFooterInSection" value:qc_titleForFooterInSection policy:OBJC_ASSOCIATION_COPY];
}
- (BOOL (^)(id, NSIndexPath *))qc_canEditRowAtIndexPath{
    return [self getAssociatedObject:"qc_canEditRowAtIndexPath"];
}
- (void)setQc_canEditRowAtIndexPath:(BOOL (^)(id, NSIndexPath *))qc_canEditRowAtIndexPath{
    [self setAssociatedObject:"qc_canEditRowAtIndexPath" value:qc_canEditRowAtIndexPath policy:OBJC_ASSOCIATION_COPY];
}
- (CGFloat (^)(id, NSIndexPath *, id))qc_heightForRowAtIndexPath{
    return [self getAssociatedObject:"qc_heightForRowAtIndexPath"];
}
-(void)setQc_heightForRowAtIndexPath:(CGFloat (^)(id, NSIndexPath *, id))qc_heightForRowAtIndexPath{
    [self setAssociatedObject:"qc_heightForRowAtIndexPath" value:qc_heightForRowAtIndexPath policy:OBJC_ASSOCIATION_ASSIGN];
}
    
-(CGFloat (^)(id, NSInteger, id))qc_heightForHeaderInSection{
    return [self getAssociatedObject:"qc_heightForHeaderInSection"];
}
-(void)setQc_heightForHeaderInSection:(CGFloat (^)(id, NSInteger, id))qc_heightForHeaderInSection{
    [self setAssociatedObject:"qc_heightForHeaderInSection" value:qc_heightForHeaderInSection policy:OBJC_ASSOCIATION_ASSIGN];
}
    
-(CGFloat (^)(id, NSInteger, id))qc_heightForFooterInSection{
    return [self getAssociatedObject:"qc_heightForFooterInSection"];
}
-(void)setQc_heightForFooterInSection:(CGFloat (^)(id, NSInteger, id))qc_heightForFooterInSection{
    [self setAssociatedObject:"qc_heightForFooterInSection" value:qc_heightForFooterInSection policy:OBJC_ASSOCIATION_ASSIGN];
}
- (UIView *(^)(id, NSInteger, id))qc_viewForFooterInSection{
    return [self getAssociatedObject:"qc_viewForFooterInSection"];
}
-(void)setQc_viewForFooterInSection:(UIView *(^)(id, NSInteger, id))qc_viewForFooterInSection{
    [self setAssociatedObject:"qc_viewForFooterInSection" value:qc_viewForFooterInSection policy:OBJC_ASSOCIATION_ASSIGN];
}
- (UIView *(^)(id, NSInteger, id))qc_viewForHeaderInSection{
    return [self getAssociatedObject:"qc_viewForHeaderInSection"];
}
-(void)setQc_viewForHeaderInSection:(UIView *(^)(id, NSInteger, id))qc_viewForHeaderInSection{
    [self setAssociatedObject:"qc_viewForHeaderInSection" value:qc_viewForHeaderInSection policy:OBJC_ASSOCIATION_ASSIGN];
}
    
-(void (^)(UIScrollView *, UIView *))qc_emptyDataSetDidTapView{
    return [self getAssociatedObject:"qc_emptyDataSetDidTapView"];
}
-(void)setQc_emptyDataSetDidTapView:(void (^)(UIScrollView *, UIView *))qc_emptyDataSetDidTapView{
    [self setAssociatedObject:"qc_emptyDataSetDidTapView" value:qc_emptyDataSetDidTapView policy:OBJC_ASSOCIATION_COPY];
}
    
-(void (^)(UIScrollView *, UIButton *))qc_emptyDataSetDidTapButton{
    return [self getAssociatedObject:"qc_emptyDataSetDidTapButton"];
}
-(void)setQc_emptyDataSetDidTapButton:(void (^)(UIScrollView *, UIButton *))qc_emptyDataSetDidTapButton{
    [self setAssociatedObject:"qc_emptyDataSetDidTapButton" value:qc_emptyDataSetDidTapButton policy:OBJC_ASSOCIATION_COPY];
}
    
-(NSInteger)countPerPage{
     return [[self getAssociatedObject:"countPerPage"] integerValue];
}
-(void)setCountPerPage:(NSInteger)countPerPage{
    [self setAssociatedObject:"countPerPage" value:[NSNumber numberWithInteger:countPerPage] policy:OBJC_ASSOCIATION_ASSIGN];
}
    
-(QCDataSource *)qc_dataSource{
    return [self getAssociatedObject:"qc_dataSource"];
}
- (void)setQc_dataSource:(QCDataSource *)qc_dataSource{
    [self setAssociatedObject:"qc_dataSource" value:qc_dataSource policy:OBJC_ASSOCIATION_RETAIN];
}
-(QCEmptySource *)qc_emptySource{
    id source = [self getAssociatedObject:"qc_emptySource"];
    if (source == nil) {
        source = [[QCEmptySource alloc] init];
        [self setQc_emptySource:source];
    }
    return source;
}
- (void)setQc_emptySource:(QCEmptySource *)qc_emptySource{
    [self setAssociatedObject:"qc_emptySource" value:qc_emptySource policy:OBJC_ASSOCIATION_RETAIN];
}
    
#pragma mark 下拉刷新
- (void (^)(id))qc_headerRefresh{
    return [self getAssociatedObject:"qc_headerRefresh"];
}
-(void)setQc_headerRefresh:(void (^)(id))qc_headerRefresh{
    [self setAssociatedObject:"qc_headerRefresh" value:qc_headerRefresh policy:OBJC_ASSOCIATION_COPY];
    __weak __typeof__(self) weakSelf = self;
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf qc_loadData];
    }];
}
    
-(void (^)(id))qc_footerRefresh{
    return [self getAssociatedObject:"qc_footerRefresh"];
}
-(void)setQc_footerRefresh:(void (^)(id))qc_footerRefresh{
    [self setAssociatedObject:"qc_footerRefresh" value:qc_footerRefresh policy:OBJC_ASSOCIATION_COPY];
    if (!self.mj_footer && self.qc_footerRefresh) {
        __weak __typeof(self) weakSelf = self;
        self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf qc_loadMoreData];
        }];
    }
}
    
-(QCEmptyModel *(^)(QCEmptyModel *))qc_emptyDataSetForEmpty{
    return [self getAssociatedObject:"qc_emptyDataSetForEmpty"];
}
-(void)setQc_emptyDataSetForEmpty:(QCEmptyModel *(^)(QCEmptyModel *))qc_emptyDataSetForEmpty{
    [self setAssociatedObject:"qc_emptyDataSetForEmpty" value:qc_emptyDataSetForEmpty policy:OBJC_ASSOCIATION_COPY];
}
    
-(QCEmptyModel *(^)(QCEmptyModel *))qc_emptyDataSetForLoading{
    return [self getAssociatedObject:"qc_emptyDataSetForLoading"];
}
-(void)setQc_emptyDataSetForLoading:(QCEmptyModel *(^)(QCEmptyModel *))qc_emptyDataSetForLoading{
    [self setAssociatedObject:"qc_emptyDataSetForLoading" value:qc_emptyDataSetForLoading policy:OBJC_ASSOCIATION_COPY];
    [self.qc_emptySource qc_reloadEmptyDataWithLoading:nil];
}
    
-(QCEmptyModel *(^)(QCEmptyModel *))qc_emptyDataSetForError{
    return [self getAssociatedObject:"qc_emptyDataSetForError"];
}
-(void)setQc_emptyDataSetForError:(QCEmptyModel *(^)(QCEmptyModel *))qc_emptyDataSetForError{
    [self setAssociatedObject:"qc_emptyDataSetForError" value:qc_emptyDataSetForError policy:OBJC_ASSOCIATION_COPY];
}

@end
