//
//  YMAttributeTextView.m
//  AttributedString
//
//  Created by Hertz Goo on 2019/11/30.
//  Copyright © 2019 Hertz Goo. All rights reserved.
//

#import "YMAttributeTextView.h"

#define YMScreenWidth [UIScreen mainScreen].bounds.size.width
#define YMScreenHeight [UIScreen mainScreen].bounds.size.height
#define YMContentSize 14

@interface YMAttributeTextView()<UITextViewDelegate>

@property (nonatomic ,assign)CGRect viewframe;
@property (nonatomic ,weak)UITextView *contentTextView;
@property (nonatomic ,weak)UIButton *leftAgreeBtn;

@end

@implementation YMAttributeTextView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self = [super initWithFrame:frame];
        if (self) {
            
            _viewframe = frame;
            [self setupUI];
        }
    }
    return self;
}

- (void)setupUI {
    
    //内容文本
    UITextView *contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, _viewframe.size.width, _viewframe.size.height)];
    self.contentTextView = contentTextView;
    contentTextView.textAlignment = NSTextAlignmentLeft;
    contentTextView.delegate = self;
    contentTextView.editable = NO;        //必须禁止输入，否则点击将弹出输入键盘
    contentTextView.scrollEnabled = NO;
    [self addSubview:contentTextView];
    
    // 左侧是否选中按钮
    UIButton *leftAgreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftAgreeBtn = leftAgreeBtn;
    leftAgreeBtn.frame = CGRectMake(0, 6, 24, 24);
    [leftAgreeBtn setImage:[UIImage imageNamed:@"icon_address_ic_address_notselected"] forState:UIControlStateNormal];
    [leftAgreeBtn setImage:[UIImage imageNamed:@"icon_address_ic_address_selected"] forState:UIControlStateSelected];
    leftAgreeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:leftAgreeBtn];
    [leftAgreeBtn addTarget:self action:@selector(leftAgreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark ----------------- 设置可点击的文字 -----------------
- (void)setContentText:(NSString *)contentText
{
    _contentText = contentText;
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:_contentText attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_fontSize],NSForegroundColorAttributeName:_textColor}];
    
    // 遍历"点击文字"为Link链接, 以及其他需要设置的属性
    for (int i = 0; i < _clickTextArr.count; i++) {
        
        NSString *clickText = _clickTextArr[i];
        NSString *clickText1 = [_contentText componentsSeparatedByString:clickText].lastObject;
        NSString *linkValueStr = [NSString stringWithFormat:@"clickText%d://",i];
        NSRange clickTextRange = NSMakeRange(_contentText.length-clickText1.length-clickText.length, clickText.length);
        
        [attrStr addAttribute:NSLinkAttributeName value:linkValueStr range:clickTextRange]; // 设置"点击文字"为Link链接
        if (_isSetUnderline == YES) {
            [attrStr addAttribute:NSUnderlineStyleAttributeName value: [NSNumber numberWithInteger:NSUnderlineStyleSingle] range:clickTextRange]; // 下划线
        }
        if (_clickTextColor != nil) {
            // 设置"点击文字"颜色的,好像设置了NSLinkAttributeName属性后, 设置"点击文字"颜色就不生效了
            [attrStr addAttribute:NSForegroundColorAttributeName value:_clickTextColor range:clickTextRange];
        }
    }
    self.contentTextView.attributedText = attrStr;
}

- (void)setClickTextArr:(NSArray *)clickTextArr {
    _clickTextArr = clickTextArr;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
}

- (void)setClickTextColor:(UIColor *)clickTextColor {
    _clickTextColor = clickTextColor;
}

- (void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
}

- (void)setIsSetUnderline:(BOOL)isSetUnderline {
    _isSetUnderline = isSetUnderline;
}

#pragma mark ----------------- UITextViewDelegate -----------------
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    
    // 点击文字触发
    NSString *clickText = [textView.text substringWithRange:characterRange];
    for (int i = 0; i < _clickTextArr.count; i++) {
        if ([clickText isEqualToString:_clickTextArr[i]]) {
            if ([[URL scheme] isEqualToString:[NSString stringWithFormat:@"clickText%d",i]]) {
                if (self.clickTextDidClickBlock) {
                    self.clickTextDidClickBlock(clickText);
                }
                return NO;
            }
        }
    }
    return YES;
}

// 按钮点击事件
- (void)leftAgreeBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (self.agreeBtnClickBlock) {
        self.agreeBtnClickBlock(sender);
    }
}

@end
