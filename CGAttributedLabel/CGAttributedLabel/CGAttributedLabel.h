//
//  CGAttributedLabel.h
//  CGAttributedLabel
//
//  Created by xiao li on 2017/8/31.
//  Copyright © 2017年 xiao li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineModel :NSObject
@property (nonatomic ,assign) NSRange range ;
@property (nonatomic ,strong) UIColor *lineColor ;
@property (nonatomic ,assign) CGRect delegateBounds ;
@property (nonatomic ,assign) CGRect bgrunbouns ;
@property (nonatomic ,assign) NSString *idfanier ;
@end

#define WXTEXTFONT [UIFont systemFontOfSize:20]
#define RUNATTRIBUTE_BOTTOM_LINE_KEY @"RUNATTRIBUTE_BOTTOM_LINE"
#define RUNATTRIBUTE_DELETE_LINE_KEY @"RUNATTRIBUTE_DELETE_LINE"

#define RUNATTRIBUTE_BOTTOM_LINE_VALUE @"RUNATTRIBUTE_BOTTOM_LINE_VALUE"
#define RUNATTRIBUTE_DELETE_LINE_VALUE @"RUNATTRIBUTE_DELETE_LINE_VALUE"

#define RUNATTRIBUTE_YESORNO_KEY @"RUNATTRIBUTE_YESORNO_KEY"

@class CGAttributedLabel ;
@protocol CGAttributedLabelDelegate <NSObject>
@optional

/**
 设置替换self.tagString标签的数据源代理
 */
- (id)replaceCharactersInWXAttributedLabel:(CGAttributedLabel *)attributedLabel index:(NSInteger)index ;

@end

@interface CGAttributedLabel : UILabel
/**
 标识字符
 */
@property (nonatomic ,assign) NSString * tagString ;
@property (nonatomic ,strong) NSString * textString ;
/**
 下划线的颜色 默认蓝色
 */
@property (nonatomic ,strong) UIColor * bottomLineColor ;
/**
 下划线的线宽,默认1
 */
@property (nonatomic ,assign) CGFloat bottomLineWith ;
/**
 删除线的颜色
 */
@property (nonatomic ,strong) UIColor * deleteLineColor ;
/**
 删除线的线宽，默认1
 */
@property (nonatomic ,assign) CGFloat deleteLineWith ;
/**
 下划线距离文字的间距
 */
@property (nonatomic ,assign) NSInteger lineSpacinge ;

@property (nonatomic, assign) id<CGAttributedLabelDelegate>     delegate;

@end
