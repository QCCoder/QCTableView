//
//  QCListModel.h
//  QCTableView
//
//  Created by 钱城 on 2018/6/29.
//  Copyright © 2018年 钱城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QCAbnormalModel : NSObject

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

@end
