//
//  QCTableViewDataSource.m
//  QCTableView
//
//  Created by 钱城 on 2019/1/29.
//  Copyright © 2019 钱城. All rights reserved.
//

#import "QCDataSource.h"

@interface QCDataSource()

//sb
@property (nonatomic, copy) NSString *cellIdentifier;

@property (nonatomic, copy) QCCellForRowAtIndexPath cellConfig;

@property (nonatomic, copy) QCDidSelectRowAtIndexPath didSelect;

@end

@implementation QCDataSource

#pragma 懒加载
-(NSArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSArray array];
    }
    return _dataArray;
}

-(void)reloadDataWithList:(NSArray *)data{
    self.dataArray = data;
}

- (instancetype)initWithIdentifier:(NSString *)identifier cellConfig:(QCCellForRowAtIndexPath)cellConfig didSelect:(QCDidSelectRowAtIndexPath)didSelect{
    if (self = [super init]) {
        self.cellIdentifier = identifier;
        self.cellConfig = cellConfig;
        self.didSelect = didSelect;
    }
    return self;
}

- (id)sectionModelAtSection:(NSInteger)section {
    return self.dataArray.count > section ? self.dataArray[section] : nil;
}

- (id)sectionModelAtIndexPath:(NSIndexPath *)indexPath {
    return [self sectionModelAtSection:indexPath.section];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.numberOfSectionsInView) {
        return self.numberOfSectionsInView(tableView);
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.numberOfRowsInSection) {
        return self.numberOfRowsInSection(tableView,section,[self sectionModelAtSection:section]);
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    if(self.cellConfig) {
        self.cellConfig(cell,indexPath,[self sectionModelAtIndexPath:indexPath]);
    }
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.titleForHeaderInSection) {
        return self.titleForHeaderInSection(tableView,section,[self sectionModelAtSection:section]);
    }
    return nil;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (self.titleForFooterInSection) {
        return self.titleForFooterInSection(tableView,section,[self sectionModelAtSection:section]);
    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.canEditRowAtIndexPath) {
        return self.canEditRowAtIndexPath(tableView,indexPath);
    }
    return NO;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.heightForRowAtIndexPath) {
        return self.heightForRowAtIndexPath(tableView,indexPath,[self sectionModelAtIndexPath:indexPath]);
    }
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.heightForHeaderInSection) {
        return self.heightForHeaderInSection(tableView,section,[self sectionModelAtSection:section]);
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.heightForFooterInSection) {
        return self.heightForFooterInSection(tableView,section,[self sectionModelAtSection:section]);
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.viewForHeaderInSection) {
        return self.viewForHeaderInSection(tableView,section,[self sectionModelAtSection:section]);
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.viewForFooterInSection) {
        return self.viewForFooterInSection(tableView,section,[self sectionModelAtSection:section]);
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.didSelect) {
        self.didSelect(tableView,indexPath,[self sectionModelAtIndexPath:indexPath]);
    }
}

#pragma mark UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    if(self.cellConfig) {
        self.cellConfig(cell,indexPath,[self sectionModelAtIndexPath:indexPath]);
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.numberOfRowsInSection) {
        return self.numberOfRowsInSection(collectionView,section,[self sectionModelAtSection:section]);
    }
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.numberOfSectionsInView) {
        return self.numberOfSectionsInView(collectionView);
    }
    return 1;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.didSelect) {
        self.didSelect(collectionView, indexPath, [self sectionModelAtIndexPath:indexPath]);
    }
}

@end
