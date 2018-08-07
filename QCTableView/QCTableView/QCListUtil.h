//
//  QCTableViewUtil.h
//  QCTableView
//
//  Created by 钱城 on 2018/6/29.
//  Copyright © 2018年 钱城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QCListUtil : NSObject

+ (UIColor *)colorWithHex:(NSString *)string;

+ (NSAttributedString *)getAttribute:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor lineSpacing:(CGFloat)lineSpacing;

@end
