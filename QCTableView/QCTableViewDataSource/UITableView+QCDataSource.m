//
//  UITableView+QCDataSource.m
//  QCTableView
//
//  Created by 钱城 on 2019/1/31.
//  Copyright © 2019 钱城. All rights reserved.
//

#import "UITableView+QCDataSource.h"

@implementation UITableView (QCDataSouce)
    
- (void)qc_addDataSourceAndEmptySourceWithIdentifier:(NSString *)identifier cellConfig:(QCCellForRowAtIndexPath)cellConfig didSelect:(QCDidSelectRowAtIndexPath)didSelect{
    [super qc_addDataSourceAndEmptySourceWithIdentifier:identifier cellConfig:cellConfig didSelect:didSelect];
    
}
    
- (void)qc_reloadDataWithList:(NSArray *)data type:(QCRefreshType)type{
    [super qc_reloadDataWithList:data type:type];
    [self reloadData];
}
    
-(void)qc_reloadDataWithError:(NSString *)error{
    [super qc_reloadDataWithError:error];
    [self reloadData];
}
    
- (void)qc_reloadDataWithEmpty:(NSString *)empty{
    [super qc_reloadDataWithEmpty:empty];
    [self reloadData];
}

-(void)qc_loadDataWithAnimation{
    [super qc_loadDataWithAnimation];
    [self reloadData];
}

@end

