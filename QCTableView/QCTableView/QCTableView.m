//
//  QCTableView.m
//  QCTableView
//
//  Created by 钱城 on 2018/6/28.
//  Copyright © 2018年 钱城. All rights reserved.
//

#import "QCTableView.h"
#import "UIScrollView+EmptyDataSet.h"
#import "MJRefresh.h"
@interface QCTableView()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,assign) QCTableViewState state;

@property (nonatomic,strong) QCTableViewModel *emptyModel;

@property (nonatomic,strong) QCTableViewModel *loadingModel;

@property (nonatomic,strong) QCTableViewModel *errorModel;

@property (nonatomic,strong,readonly) QCTableViewModel *currentModel;

@end

@implementation QCTableView

#pragma 懒加载
-(NSArray *)datalist
{
    if (!_datalist) {
        self.datalist = [NSArray array];
    }
    return _datalist;
}

-(QCTableViewModel *)emptyModel
{
    if (!_emptyModel) {
        self.emptyModel = [[QCTableViewModel alloc]init];
        self.emptyModel.title = [QCTableViewUtil getAttribute:@"暂无数据" font:[UIFont systemFontOfSize:16.0] textColor:[QCTableViewUtil colorWithHex:@"b9b9b9"] lineSpacing:1.0];
        self.emptyModel.image = [UIImage imageNamed:@"QCTableView.bundle/empty"];
        self.emptyModel.spaceHeight = 0.0;
        self.emptyModel.verticalOffset = -100.0;
        self.emptyModel.shouldDisplay = YES;
        self.emptyModel.shouldAllowTouch = YES;
        self.emptyModel.shouldAllowScroll = YES;
        self.emptyModel.shouldAnimateImage = NO;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
        animation.duration = 0.25;
        animation.cumulative = YES;
        animation.repeatCount = MAXFLOAT;
        self.emptyModel.imageAnimation = animation;
    }
    return _emptyModel;
}

-(QCTableViewModel *)loadingModel
{
    if (!_loadingModel) {
        self.loadingModel = [[QCTableViewModel alloc]init];
        self.loadingModel.backgroundColor = [QCTableViewUtil colorWithHex:@"f5f5f5"];
        self.loadingModel.image = [UIImage imageNamed:@"QCTableView.bundle/empty"];
        self.loadingModel.spaceHeight = 0.0;
        self.loadingModel.verticalOffset = -100.0;
        self.loadingModel.shouldDisplay = NO;
        self.loadingModel.shouldAllowTouch = YES;
        self.loadingModel.shouldAllowScroll = YES;
        self.loadingModel.shouldAnimateImage = NO;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
        animation.duration = 0.25;
        animation.cumulative = YES;
        animation.repeatCount = MAXFLOAT;
        self.loadingModel.imageAnimation = animation;
    }
    return _loadingModel;
}

-(QCTableViewModel *)errorModel
{
    if (!_errorModel) {
        self.errorModel = [[QCTableViewModel alloc]init];
        self.errorModel.title = [QCTableViewUtil getAttribute:@"加载失败" font:[UIFont systemFontOfSize:16.0] textColor:[QCTableViewUtil colorWithHex:@"b9b9b9"] lineSpacing:1.0];
        self.errorModel.image = [UIImage imageNamed:@"QCTableView.bundle/empty"];
        self.errorModel.spaceHeight = 0.0;
        self.errorModel.verticalOffset = -100.0;
        self.errorModel.shouldDisplay = YES;
        self.errorModel.shouldAllowTouch = YES;
        self.errorModel.shouldAllowScroll = YES;
        self.errorModel.shouldAnimateImage = NO;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
        animation.duration = 0.25;
        animation.cumulative = YES;
        animation.repeatCount = MAXFLOAT;
        self.errorModel.imageAnimation = animation;
    }
    return _errorModel;
}

#pragma mark 重写方法
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark 自定义方法
- (void)setup {
    self.state = QCTableViewStateLoading;
    self.delegate = self;
    self.dataSource = self;
    self.emptyDataSetSource = self;
    self.emptyDataSetDelegate = self;
    self.countPerPage = 10;
    [self reloadAbnormalView];
}

- (void)reloadData {
    [self refreshHeader];
    [self refreshFooter];
    [super reloadData];
}

- (void)loadFooterData{
    [self loadMoreData];
}

- (void)loadHeaderData{
    [self loadNewData];
}

- (void)refreshHeader {
//    switch (self.state) {
//        case QCTableViewStateLoading: //加载错误，无数据状态，移除header和footer
//        case QCTableViewStateEmpty:
//        case QCTableViewStateError:
//            break;
//        case QCTableViewStateNormal: {
//            [self setupHeaderRefresh];
//            [self setupFooterRefresh];
//            break;
//        }
//        default:
//            break;
//    }
    
    if (self.mj_header && self.state != QCTableViewStateLoading) {
        [self.mj_header endRefreshing];
    }
}

- (void)refreshFooter {
    
    if (self.mj_footer) {
        [self.mj_footer endRefreshing];
    }
    
    if (self.datalist.count % self.countPerPage == 0 && self.datalist.count > 0) { //还有更多有数据
        [self.mj_footer resetNoMoreData];
    } else { //没有更多内容
        [self.mj_footer endRefreshingWithNoMoreData];
    }
}

-(void)registerNibName:(NSString *)nibName identifier:(NSString *)identifier{
    [self registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:identifier];
}

-(void)registerClassName:(NSString *)className identifier:(NSString *)identifier{
    [self registerClass:NSClassFromString(className) forCellReuseIdentifier:identifier];
}

#pragma mark 下拉刷新
- (void)setupHeaderRefresh {
    __weak __typeof(self) weakSelf = self;
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
}

-(void)setHeaderRefresh:(void (^)(QCTableView *))headerRefresh{
    _headerRefresh = headerRefresh;
    [self setupHeaderRefresh];
}

- (void)loadNewData {
    if (self.headerRefresh != nil) {
        self.headerRefresh(self);
    }
}

- (void)loadHeaderDataWithAnimation{
    if (self.mj_header != nil) {
        [self.mj_header beginRefreshing];
    }
}

- (void)loadMoreData {
    if (self.footerRefresh) {
        self.footerRefresh(self);
    }
}

-(void)removeFooterRefreshView{
    self.mj_footer = nil;
}

#pragma mark 上拉加载更多
- (void)setupFooterRefresh {
    if (!self.mj_footer && self.footerRefresh) {
        __weak __typeof(self) weakSelf = self;
        self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadMoreData];
        }];
    }
}

-(void)removeHeaderRefreshView{
    self.mj_header = nil;
}

#pragma mark 刷新数据
- (void)refreshWithError:(NSString *)error{
    self.state = QCTableViewStateError;
    if (error.length > 0) {
        self.errorModel.title = [QCTableViewUtil getAttribute:error font:[UIFont systemFontOfSize:16.0] textColor:[QCTableViewUtil colorWithHex:@"b9b9b9"] lineSpacing:1.0];
    }
    self.datalist = [NSArray array];
    [self reloadAbnormalView];
}

- (void)refreshWithList:(NSArray *)data refreshType:(QCRefreshType)type{
    if (!data) {
        data = [NSArray array];
    }
    
    NSMutableArray *datalist = [NSMutableArray arrayWithArray:self.datalist];
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
    self.datalist = datalist;
    
    if (self.datalist.count == 0) {
        self.state = QCTableViewStateEmpty;
        [self reloadAbnormalView];
    }else{
        self.state = QCTableViewStateNormal;
        [self reloadData];
    }
}

- (void)reloadAbnormalView{
    if([self.qcAbnormalDelegate respondsToSelector:@selector(qcTableView:modelForAbnormalView:state:)]) {
        QCTableViewModel *model = [self.qcAbnormalDelegate qcTableView:self modelForAbnormalView:self.emptyModel state:self.state];
        if (self.state == QCTableViewStateEmpty) {
            self.emptyModel = model;
        }else if (self.state == QCTableViewStateError) {
            self.errorModel = model;
        }
    }
    [self reloadData];
    [self reloadEmptyDataSet];
}

-(QCTableViewModel *)currentModel{
    if (self.state == QCTableViewStateError) {
        return self.errorModel;
    }else if (self.state == QCTableViewStateLoading) {
        return self.loadingModel;
    }else{
        return self.emptyModel;
    }
}

#pragma mark 代理
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.qcDelegate respondsToSelector:@selector(qcTableView:heightForRowAtIndexPath:)]) {
        return [self.qcDelegate qcTableView:self heightForRowAtIndexPath:indexPath];
    }
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([self.qcDelegate respondsToSelector:@selector(qcTableView:heightForHeaderInSection:)]){
        return [self.qcDelegate qcTableView:self heightForHeaderInSection:section];
    }
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([self.qcDelegate respondsToSelector:@selector(qcTableView:viewForHeaderInSection:)]){
        return [self.qcDelegate qcTableView:self viewForHeaderInSection:section];
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([self.qcDelegate respondsToSelector:@selector(qcTableView:heightForFooterInSection:)]){
        return [self.qcDelegate qcTableView:self heightForFooterInSection:section];
    }
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if ([self.qcDelegate respondsToSelector:@selector(qcTableView:viewForFooterInSection:)]){
        return [self.qcDelegate qcTableView:self viewForFooterInSection:section];
    }
    return [UIView new];
}

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.qcDataSource respondsToSelector:@selector(numberOfSectionsInQcTableView:)]) {
        return [self.qcDataSource numberOfSectionsInQcTableView:self];
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.qcDataSource respondsToSelector:@selector(qcTableView:numberOfRowsInSection:) ]) {
        return [self.qcDataSource qcTableView:self numberOfRowsInSection:section];
    }
    return self.datalist.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.qcDataSource qcTableView:self cellForRowAtIndexPath:indexPath];
}

#pragma mark - DZNEmptyDataSetSource
-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    return self.currentModel.title;
}

-(NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    return self.currentModel.desc;
}

-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return self.currentModel.image;
}

-(UIColor *)imageTintColorForEmptyDataSet:(UIScrollView *)scrollView{
    return self.currentModel.imageTintColor;
}

- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView{
    return self.currentModel.imageAnimation;
}

-(NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    return self.currentModel.buttonTitle;
}

- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    return self.currentModel.buttonImage;
}

-(UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    return self.currentModel.buttonBackgroundImage;
}

-(UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView{
    return self.currentModel.backgroundColor;
}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return self.currentModel.verticalOffset;
}

-(CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    return self.currentModel.spaceHeight;
}

-(BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView{
    return self.currentModel.shouldAllowTouch;
}

-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    return self.currentModel.shouldDisplay;
}

-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return self.currentModel.shouldAllowScroll;
}

-(BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView{
    return self.currentModel.shouldAnimateImage;
}

-(UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    UIView *view = nil;
    if ([self.qcAbnormalDelegate respondsToSelector:@selector(qcTableView:customViewForAbnormalView:)]) {
        view = [self.qcAbnormalDelegate qcTableView:self customViewForAbnormalView:self.state];
    }
    return view;
}

-(void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button{
    if ([self.qcAbnormalDelegate respondsToSelector:@selector(qcTableView:didTapButtonForAbnormalView:)]) {
        [self.qcAbnormalDelegate qcTableView:self didTapButtonForAbnormalView:self.state];
    }
}

-(void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    if ([self.qcAbnormalDelegate respondsToSelector:@selector(qcTableView:didTapViewForAbnormalView:state:)]) {
        [self.qcAbnormalDelegate qcTableView:self didTapViewForAbnormalView:view state:self.state];
    }else{
        self.state = QCTableViewStateLoading;
        [self reloadAbnormalView];
        [self loadHeaderDataWithAnimation];
    }
}

@end

