//
//  QCTableViewUtil.m
//  QCTableView
//
//  Created by 钱城 on 2018/6/29.
//  Copyright © 2018年 钱城. All rights reserved.
//

#import "QCListUtil.h"

@implementation QCListUtil

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
