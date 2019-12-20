//
//  ViewController.m
//  AttributedString
//
//  Created by Hertz Goo on 2019/11/30.
//  Copyright © 2019 Hertz Goo. All rights reserved.
//

#import "ViewController.h"
#import "YMAttributeTextView.h"

#define YMScreenWidth [UIScreen mainScreen].bounds.size.width
#define YMScreenHeight [UIScreen mainScreen].bounds.size.height
#define YMContentSize 18
#define isIphoneX ([[UIApplication sharedApplication] statusBarFrame].size.height == 44)
#define YMTabbarHeight (isIphoneX ? (49.f+34.f) : 49.f)

@interface ViewController ()

@property (nonatomic ,weak)UIButton *agreeBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"用户协议";
    
    [self setupTextViewUI];
    
    [self setupYesOrNoUI];
}

#pragma mark ----------------- 初始化 YMAttributeTextView UI -----------------
- (void)setupTextViewUI {
    
    CGFloat onelineStr_H = [@"道" boundingRectWithSize:CGSizeMake(YMScreenWidth-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:YMContentSize]} context:nil].size.height;
    NSString *agreementText = @"    同意《用户协议》和《隐私政策》和《用户协议》和《隐私政策》";
    CGFloat agreementStr_H = [agreementText boundingRectWithSize:CGSizeMake(YMScreenWidth-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:YMContentSize]} context:nil].size.height + onelineStr_H;
    YMAttributeTextView *agreementTextView = [[YMAttributeTextView alloc] initWithFrame:CGRectMake(12, 200, YMScreenWidth-24, agreementStr_H)];
    agreementTextView.clickTextArr = @[@"《用户协议》",@"《隐私政策》"]; // 设置"需要点击的文字"数组，只需agreementText中包含文字即可
    agreementTextView.textColor = [UIColor grayColor]; // 设置整体文字颜色
    agreementTextView.clickTextColor = [UIColor redColor]; // 设置"需要点击的文字"颜色
    agreementTextView.fontSize = YMContentSize; // 设置整体文字大小
    agreementTextView.isSetUnderline = YES; // 是否设置"需要点击的文字"下划线
    agreementTextView.isShowLeftAgreeBtn = NO; // 是否显示文字左侧勾选按钮
    agreementTextView.isAddOnlyLastOneLink = NO; // 当内容中"需要点击的文字"有多个重复字段时,是否只添加最后一个字段超链接
    agreementTextView.lineSpacing = 2.0; // 设置行间距
    agreementTextView.agreeBtnNormalImageName = @"ic_compared_checkbox_normal"; // 设置左侧勾选按钮常规状态图片
    agreementTextView.agreeBtnSelectedImageName = @"ic_compared_checkbox_selected"; // 设置左侧勾选按钮选中状态图片
    agreementTextView.contentText = agreementText; // 设置文字内容
    [self.view addSubview:agreementTextView];
    __weak typeof(self) weakself = self;
    agreementTextView.clickTextDidClickBlock = ^(NSString * _Nonnull clickText) { // "需要点击的文字" 点击回调
        NSLog(@"clickText===%@", clickText);
    };
    agreementTextView.agreeBtnClickBlock = ^(UIButton * _Nonnull button) { // 左侧勾选按钮选中与否回调
        NSLog(@"leftAgreeBtn.selected===%d", button.selected);
        weakself.agreeBtn = button;
    };
}

#pragma mark ----------------- 初始化底部 "同意" "不同意" 按钮 -----------------
// 这个不重要
- (void)setupYesOrNoUI {
    
    CGFloat btn_H = isIphoneX?(49.f+34.f) : 49.f;
    UIView *btnBackView = [[UIView alloc] initWithFrame:CGRectMake(0, YMScreenHeight-btn_H, YMScreenWidth, btn_H)];
    [self.view addSubview:btnBackView];
    UIButton *cancelBtn = [self ym_buttonWithFrame:CGRectMake(0, 0, YMScreenWidth*0.5, 44) title:@"不同意" fontSize:17.0 fontColor:[UIColor blackColor] target:self action:@selector(agreementCancelClick)];
    [btnBackView addSubview:cancelBtn];
    [self setBorderWithView:cancelBtn top:YES left:NO bottom:NO right:YES borderColor:[UIColor lightGrayColor] borderWidth:1];
    
    UIButton *sureBtn = [self ym_buttonWithFrame:CGRectMake(YMScreenWidth*0.5, 0, YMScreenWidth*0.5, 44) title:@"同意" fontSize:17.0 fontColor:[UIColor blackColor] target:self action:@selector(agreementSureClick)];
    [btnBackView addSubview:sureBtn];
    [self setBorderWithView:sureBtn top:YES left:NO bottom:NO right:YES borderColor:[UIColor lightGrayColor] borderWidth:1];
}

#pragma mark ----------------- 点击方法 -----------------
- (void)agreementCancelClick { // 不同意
    
    // 调用代码使APP进入后台，达到点击Home键的效果
    [[UIApplication sharedApplication] performSelector:@selector(suspend)];
}

- (void)agreementSureClick { // 同意
    
    if (self.agreeBtn.selected == 1) {
        NSLog(@"已勾选同意, 进入下一步");
    } else {
        NSLog(@"请勾选同意, 才能进入下一步");
    }
}

#pragma mark ----------------- 公用工具方法 -----------------
- (UIButton *)ym_buttonWithFrame: (CGRect)frame title: (NSString *)title fontSize: (CGFloat)size fontColor: (UIColor *)color  target:(nullable id)target action:(nonnull SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame.size.height?frame:CGRectZero;
    [button setTitle:title?title:@"按钮名字" forState:UIControlStateNormal];
    button.titleLabel.font = size?[UIFont systemFontOfSize:size]:[UIFont systemFontOfSize:YMContentSize];
    [button setTitleColor:color?color:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, view.frame.size.height - width, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(view.frame.size.width - width, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
}

@end
