//
//  QCEmptyDataSouece.m
//  QCTableView
//
//  Created by 钱城 on 2019/1/31.
//  Copyright © 2019 钱城. All rights reserved.
//

#import "QCEmptySource.h"
#import "DGActivityIndicatorView.h"

#define kDefaultTinColor [UIColor colorWithRed:255 / 255.0 green:89 / 255.0 blue:51 / 255.0 alpha:1.0]
#define kDefaultMessageColor [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1.0]

@interface QCEmptySource()
    
@property (nonatomic,strong) QCEmptyModel *currentModel;
    

@end

@implementation QCEmptySource
    
- (instancetype)init{
    self = [super init];
    if (self) {
        [self qc_reloadEmptyDataWithLoading:nil];
    }
    return self;
}

-(UIView *)getLoadingView{
    UIView *loadingView = [[[NSBundle mainBundle] loadNibNamed:@"QCEmptyLoading" owner:self options:nil] firstObject];
    loadingView.backgroundColor = [UIColor clearColor];
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:loadingView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:140];
    [loadingView addConstraint:heightConstraint];
    
    UIView *contentView = [loadingView viewWithTag:101];
    DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallSpinFadeLoader tintColor:self.currentModel.loadingTintColor size:70];
    activityIndicatorView.frame = CGRectMake(15, 0,70,70);
    [contentView addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(activityIndicatorView.frame) + self.currentModel.spaceHeight, 100, 21)];
    label.attributedText = self.currentModel.title;
    [label setFont:[UIFont fontWithName:@"ArialMT" size:16.0]];
    [label setTextColor:self.currentModel.loadingTextColor];
    label.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:label];
    return loadingView;
}

- (void)qc_reloadEmptyDataWithEmpty:(NSString *)empty{
    if (empty.length == 0) {
        empty = @"暂无数据";
    }
    self.currentModel = [[QCEmptyModel alloc]init];
    self.currentModel.state = QCEmptySourceStateEmpty;
    self.currentModel.title = [QCEmptyModelUtil getAttribute:empty font:[UIFont systemFontOfSize:16.0] textColor:[QCEmptyModelUtil colorWithHex:@"b9b9b9"] lineSpacing:1.0];
    self.currentModel.image = [UIImage imageNamed:@"QCEmptySource.bundle/empty"];
    self.currentModel.spaceHeight = 15.0;
    self.currentModel.verticalOffset = -170.0;
    self.currentModel.shouldDisplay = YES;
    self.currentModel.shouldAllowTouch = YES;
    self.currentModel.shouldAllowScroll = NO;
    self.currentModel.shouldAnimateImage = NO;
    
    if (self.emptyDataSetForEmpty) {
        self.emptyDataSetForEmpty(self.currentModel);
    }
}
    
- (void)qc_reloadEmptyDataWithError:(NSString *)error{
    if (error.length == 0) {
        error = @"加载失败";
    }
    self.currentModel = [[QCEmptyModel alloc]init];
    self.currentModel.state = QCEmptySourceStateError;
    self.currentModel.title = [QCEmptyModelUtil getAttribute:error font:[UIFont systemFontOfSize:16.0] textColor:[QCEmptyModelUtil colorWithHex:@"b9b9b9"] lineSpacing:1.0];
    self.currentModel.image = [UIImage imageNamed:@"QCEmptySource.bundle/fail@2x"];
    self.currentModel.spaceHeight = 15;
    self.currentModel.verticalOffset = -170.0;
    self.currentModel.shouldDisplay = YES;
    self.currentModel.shouldAllowTouch = YES;
    self.currentModel.shouldAllowScroll = NO;
    self.currentModel.shouldAnimateImage = NO;
    
    if (self.emptyDataSetForError) {
        self.emptyDataSetForError(self.currentModel);
    }
}
    
- (void)qc_reloadEmptyDataWithLoading:(NSString *)msg{

    if (msg.length == 0) {
        msg = @"加载中";
    }
    
    self.currentModel = [[QCEmptyModel alloc]init];
    self.currentModel.title = [QCEmptyModelUtil getAttribute:msg font:[UIFont systemFontOfSize:16.0] textColor:[QCEmptyModelUtil colorWithHex:@"b9b9b9"] lineSpacing:1.0];
    self.currentModel.image = [UIImage imageNamed:@"QCEmptySource.bundle/fail@2x"];
    
    self.currentModel.spaceHeight = 20.0;
    self.currentModel.verticalOffset = -200.0;
    self.currentModel.shouldDisplay = YES;
    self.currentModel.shouldAllowTouch = YES;
    self.currentModel.shouldAllowScroll = NO;
    self.currentModel.shouldAnimateImage = NO;
    
    self.currentModel.state = QCEmptySourceStateLoading;
    self.currentModel.loadingTintColor = kDefaultTinColor;
    self.currentModel.loadingTextColor = kDefaultMessageColor;
    
    if (self.emptyDataSetForLoading) {
        self.emptyDataSetForLoading(self.currentModel);
    }
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
    return self.currentModel ? self.currentModel.verticalOffset : 0.0;
}
    
-(CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    return self.currentModel ? self.currentModel.spaceHeight : 0.0;
}
    
-(BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView{
    return self.currentModel ? self.currentModel.shouldAllowTouch : NO;
}
    
-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    return self.currentModel ? self.currentModel.shouldDisplay : YES;
}
    
-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return self.currentModel ? self.currentModel.shouldAllowScroll : NO;
}
    
-(BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView{
    return self.currentModel ? self.currentModel.shouldAnimateImage : NO;
}
    
-(void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button{
    if (self.emptyDataSetDidTapButton) {
        self.emptyDataSetDidTapButton(scrollView, button);
    }
}

-(void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    if (self.emptyDataSetDidTapView) {
        self.emptyDataSetDidTapView(scrollView, view);
    }
}
    
-(UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    if (self.currentModel.state == QCEmptySourceStateLoading) {
        return [self getLoadingView];
    }
    return nil;
}
@end

@implementation QCEmptyModel
    
@end

@implementation QCEmptyModelUtil
    
#pragma mark 自定义方法
+ (NSAttributedString *)getAttribute:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor lineSpacing:(CGFloat)lineSpacing{
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    paragraph.lineSpacing = lineSpacing;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    [attributes setObject:font forKey:NSFontAttributeName];
    [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title attributes:attributes];
    return attributedString;
}
    
+ (UIColor *)colorWithHex:(NSString *)string{
    NSString *cleanString = [string stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}
@end
