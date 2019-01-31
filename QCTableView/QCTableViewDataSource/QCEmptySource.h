//
//  QCEmptyDataSouece.h
//  QCTableView
//
//  Created by 钱城 on 2019/1/31.
//  Copyright © 2019 钱城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIScrollView+EmptyDataSet.h"

typedef enum : NSUInteger {
    QCEmptySourceStateLoading,  //加载中
    QCEmptySourceStateError,    //报错页
    QCEmptySourceStateEmpty     //空数据
} QCEmptySourceState;

@class QCEmptyModel;
@interface QCEmptySource : NSObject<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

- (void)qc_reloadEmptyDataWithError:(NSString *)error;
- (void)qc_reloadEmptyDataWithEmpty:(NSString *)empty;
- (void)qc_reloadEmptyDataWithLoading:(NSString *)msg;
    
@property (nonatomic,copy) void (^emptyDataSetDidTapButton)(UIScrollView *scrollView,UIButton *button);
@property (nonatomic,copy) void (^emptyDataSetDidTapView)(UIScrollView *scrollView,UIView *view);
    
@property (nonatomic,strong) QCEmptyModel *(^emptyDataSetForLoading)(QCEmptyModel *model);
@property (nonatomic,strong) QCEmptyModel *(^emptyDataSetForEmpty)(QCEmptyModel *model);
@property (nonatomic,strong) QCEmptyModel *(^emptyDataSetForError)(QCEmptyModel *model);
    
@end

@interface QCEmptyModel : NSObject
    
@property (nonatomic,strong) NSAttributedString *title;
@property (nonatomic,strong) NSAttributedString *desc;

//图片
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) UIColor *imageTintColor;
@property (nonatomic,strong) CAAnimation *imageAnimation;

//按钮
@property (nonatomic,strong) NSAttributedString *buttonTitle;
@property (nonatomic,strong) UIImage *buttonImage;
@property (nonatomic,strong) UIImage *buttonBackgroundImage;

//contentView
@property (nonatomic,strong) UIColor *backgroundColor;
@property (nonatomic,assign) CGFloat verticalOffset;
@property (nonatomic,assign) CGFloat spaceHeight;

@property (nonatomic,assign) BOOL shouldAllowTouch;
@property (nonatomic,assign) BOOL shouldDisplay;
@property (nonatomic,assign) BOOL shouldAllowScroll;
@property (nonatomic,assign) BOOL shouldAnimateImage;
    
@property (nonatomic,assign) QCEmptySourceState state;
@property (nonatomic,strong) UIColor *loadingTintColor;
@property (nonatomic,strong) UIColor *loadingTextColor;
    
@end

@interface QCEmptyModelUtil : NSObject
    
+ (UIColor *)colorWithHex:(NSString *)string;
    
+ (NSAttributedString *)getAttribute:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor lineSpacing:(CGFloat)lineSpacing;

@end
