//
//  QCTableViewDataSource.h
//  QCTableView
//
//  Created by 钱城 on 2019/1/29.
//  Copyright © 2019 钱城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^QCCellForRowAtIndexPath)(id cell,NSIndexPath * indexPath, id sectionModel);
typedef void (^QCDidSelectRowAtIndexPath)(id view,NSIndexPath * indexPath, id sectionModel);

@interface QCDataSource : NSObject<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *dataArray;

- (instancetype)initWithIdentifier:(NSString *)identifier cellConfig:(QCCellForRowAtIndexPath)cellConfig didSelect:(QCDidSelectRowAtIndexPath)didSelect;

@property (nonatomic,copy) NSInteger (^numberOfRowsInSection)(id view,NSInteger section,id model);
@property (nonatomic,copy) NSInteger (^numberOfSectionsInView)(id view);

@property (nonatomic,copy) NSString *(^titleForHeaderInSection)(id view,NSInteger section,id model);
@property (nonatomic,copy) NSString *(^titleForFooterInSection)(id view,NSInteger section,id model);

@property (nonatomic,copy) BOOL (^canEditRowAtIndexPath)(id view,NSIndexPath *indexPath);

@property (nonatomic,copy) CGFloat (^heightForRowAtIndexPath)(id view,NSIndexPath *indexPath,id model);
@property (nonatomic,copy) CGFloat (^heightForHeaderInSection)(id view,NSInteger section,id model);
@property (nonatomic,copy) CGFloat (^heightForFooterInSection)(id view,NSInteger section,id model);

@property (nonatomic,copy) UIView *(^viewForHeaderInSection)(id view,NSInteger section,id model);
@property (nonatomic,copy) UIView *(^viewForFooterInSection)(id view,NSInteger section,id model);

- (void)reloadDataWithList:(NSArray *)data;

@end
