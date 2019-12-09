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

@interface ViewController ()

@property (nonatomic ,weak)UIButton *agreeBtn;

@end

@implementation ViewController

#pragma mark ----------------- 初始化UI -----------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"用户须知";
    
    // 上半部分是协议描述
    NSString *desText = @"欢迎您来到超级悟道！超级悟道是每个行业从业人员终身学习与成长的平台，可以通过《超级悟道用户协议》和《超级悟道隐私政策》帮助您了解我们收集、使用、存储和共享个人信息的情况，以及您所享有的相关权利。\n\n请您阅读完整版《超级悟道用户协议》和《超级悟道隐私政策》。\n\n若您同意，请勾选下面“同意”开始接受我们的服务。";
    CGFloat onelineStr_H = [@"道" boundingRectWithSize:CGSizeMake(YMScreenWidth-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:YMContentSize]} context:nil].size.height;
    CGFloat desText_H = [desText boundingRectWithSize:CGSizeMake(YMScreenWidth-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:YMContentSize]} context:nil].size.height + onelineStr_H;
    UITextView *desTextView = [[UITextView alloc] initWithFrame:CGRectMake(12, 100, YMScreenWidth-24, desText_H)];
    desTextView.text = desText;
    desTextView.font = [UIFont systemFontOfSize:YMContentSize];
    desTextView.textColor = [UIColor blackColor];
    desTextView.textAlignment = NSTextAlignmentLeft;
    desTextView.editable = NO;
    desTextView.scrollEnabled = NO;
    [self.view addSubview:desTextView];
    
    // 下半部分是协议查看和协议勾选, 为本demo的主要功能部分
    NSString *agreementText = @"    同意《超级悟道用户协议》和《超级悟道隐私政策》";
    CGFloat agreementStr_H = [agreementText boundingRectWithSize:CGSizeMake(YMScreenWidth-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:YMContentSize]} context:nil].size.height + onelineStr_H;
    YMAttributeTextView *agreementTextView = [[YMAttributeTextView alloc] initWithFrame:CGRectMake(12, desTextView.frame.origin.y+desText_H, YMScreenWidth-24, agreementStr_H)];
    agreementTextView.clickTextArr = @[@"《超级悟道用户协议》",@"《超级悟道隐私政策》"];
    agreementTextView.textColor = [UIColor blackColor];
    agreementTextView.clickTextColor = [UIColor redColor];
    agreementTextView.fontSize = YMContentSize;
    agreementTextView.isSetUnderline = false;
    agreementTextView.contentText = agreementText;
    [self.view addSubview:agreementTextView];
    __weak typeof(self) weakself = self;
    agreementTextView.clickTextDidClickBlock = ^(NSString * _Nonnull clickText) {
        NSLog(@"clickText===%@", clickText);
    };
    agreementTextView.agreeBtnClickBlock = ^(UIButton * _Nonnull button) {
        NSLog(@"clickText===%d", button.selected);
        weakself.agreeBtn = button;
    };
    
    // 底部是同意和不同意的选择
    BOOL isIphoneX = [[UIApplication sharedApplication] statusBarFrame].size.height == 44;
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
