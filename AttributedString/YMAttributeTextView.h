//
//  YMAttributeTextView.h
//  AttributedString
//
//  Created by Hertz Goo on 2019/11/30.
//  Copyright © 2019 Hertz Goo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMAttributeTextView : UIView

@property (nonatomic ,strong)NSString *contentText; // 设置内容
@property (nonatomic ,strong)NSArray *clickTextArr; // 设置"需要点击的文字"数组
@property (nonatomic ,strong)UIColor *textColor; // 设置文字颜色 默认值[UIColor darkGrayColor]
@property (nonatomic ,strong)UIColor *clickTextColor; // 设置"需要点击的文字"颜色 默认值[UIColor darkGrayColor]
@property (nonatomic ,assign)CGFloat fontSize; // 设置文字大小 默认值14
@property (nonatomic ,assign)CGFloat lineSpacing; // 设置行间距 默认值1.5
@property (nonatomic ,strong)NSString *agreeBtnNormalImageName; // 设置左侧勾选按钮图片
@property (nonatomic ,strong)NSString *agreeBtnSelectedImageName; // 设置左侧勾选按钮选中图片
@property (nonatomic ,assign)BOOL isSetUnderline; // 是否设置下划线 默认值false
@property (nonatomic ,assign)BOOL isShowLeftAgreeBtn; // 是否显示勾选按钮 默认值false

@property(nonatomic, copy) void (^clickTextDidClickBlock)(NSString *clickText); // "需要点击的文字" 点击回调
@property(nonatomic, copy) void (^agreeBtnClickBlock)(UIButton *button); // 左侧勾选按钮选中与否回调

@end

NS_ASSUME_NONNULL_END
