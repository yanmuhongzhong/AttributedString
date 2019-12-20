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

@property (nonatomic ,weak)UITextView *contentTextView;
@property (nonatomic ,weak)UIButton *leftAgreeBtn;
@property (nonatomic ,weak)UIImageView *checkImg;
@property (nonatomic ,strong)NSMutableArray *lastlyTextArr;

@end

@implementation YMAttributeTextView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self = [super initWithFrame:frame];
        if (self) {
            
            // 设置属性默认值
            _textColor = [UIColor darkGrayColor];
            _clickTextColor = [UIColor darkGrayColor];
            _fontSize = 14;
            _lineSpacing = 1.5;
            _isSetUnderline = NO;
            _isShowLeftAgreeBtn = NO;
            _isAddOnlyLastOneLink = YES;
            
            self.lastlyTextArr = [NSMutableArray array];
            
            [self setupUI];
        }
    }
    return self;
}

- (void)setupUI {
    
    //内容文本
    UITextView *contentTextView = [[UITextView alloc] initWithFrame:self.bounds];
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
    [leftAgreeBtn addTarget:self action:@selector(leftAgreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    leftAgreeBtn.hidden = YES;
    [self addSubview:leftAgreeBtn];
    
    UIImageView *checkImg = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 16, 16)];
    self.checkImg = checkImg;
    checkImg.image = [UIImage imageNamed:@""];
    [leftAgreeBtn addSubview:checkImg];
}

#pragma mark ----------------- 设置可点击的文字 -----------------
- (void)setContentText:(NSString *)contentText
{
    _contentText = contentText;
    
    // 设置行间距
    NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = self.lineSpacing?self.lineSpacing:2;
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self.contentText attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.fontSize],NSForegroundColorAttributeName:self.textColor,NSParagraphStyleAttributeName:paragraph}];
    
    // 遍历"点击文字"为Link链接, 以及其他需要设置的属性
    if (self.isAddOnlyLastOneLink == YES) {
        [self addOnlyLastOneLink:attrStr];
    } else {
        [self addAllLink:attrStr];
    }
    if (self.clickTextColor != nil) {
        self.contentTextView.linkTextAttributes = @{NSForegroundColorAttributeName:self.clickTextColor};
    }
    self.contentTextView.attributedText = attrStr;
}

- (void)addOnlyLastOneLink:(NSMutableAttributedString *)attrStr {
    
    for (int i = 0; i < self.clickTextArr.count; i++) {
        
        NSString *clickText = self.clickTextArr[i];
        NSArray *separatedArr = [self.contentText componentsSeparatedByString:clickText];
        NSString *unclickText = separatedArr.lastObject;
        NSString *linkValueStr = [NSString stringWithFormat:@"clickText%d://",i];
        NSUInteger location = self.contentText.length-unclickText.length-clickText.length;
        NSUInteger length = clickText.length;
        NSRange clickTextRange = NSMakeRange(location, length);
        
        [attrStr addAttribute:NSLinkAttributeName value:linkValueStr range:clickTextRange]; // 设置"点击文字"为Link链接
        if (self.isSetUnderline == YES) {
            [attrStr addAttribute:NSUnderlineStyleAttributeName value: [NSNumber numberWithInteger:NSUnderlineStyleSingle] range:clickTextRange]; // 下划线
        }
//        if (_clickTextColor != nil) {
//            // 设置"点击文字"颜色的, 设置了NSLinkAttributeName属性后, 再设置此属性无效
//            [attrStr addAttribute:NSForegroundColorAttributeName value:_clickTextColor range:clickTextRange];
//        }
        [self.lastlyTextArr addObject:clickText];
    }
}

- (void)addAllLink:(NSMutableAttributedString *)attrStr {
    
    int linkTag = 0;
    for (int i = 0; i < _clickTextArr.count; i++) {
        NSString *clickText = self.clickTextArr[i];
        NSArray *separatedArr = [self.contentText componentsSeparatedByString:clickText];
        int jj = 0;
        for (int j = (int)separatedArr.count - 2; j >= 0; j--) {
            NSInteger unclickText_length = 0;
            for (int k = (int)separatedArr.count - 1; k > j; k--) {
                NSString *unclickText = separatedArr[k];
                unclickText_length = unclickText_length + unclickText.length;
            }
            NSInteger clickText_length = (int)clickText.length;
            unclickText_length = (jj+1) * clickText_length + unclickText_length;
            jj = jj + 1;
            NSString *linkValueStr = [NSString stringWithFormat:@"clickText%d://",linkTag];
            linkTag = linkTag+1;
            NSUInteger location = self.contentText.length-unclickText_length;
            NSUInteger length = clickText.length;
            if (location + length > self.contentText.length) {
                length = 0;
            }
            NSRange clickTextRange = NSMakeRange(location, length);
            
            [attrStr addAttribute:NSLinkAttributeName value:linkValueStr range:clickTextRange]; // 设置"点击文字"为Link链接
            if (self.isSetUnderline == YES) {
                [attrStr addAttribute:NSUnderlineStyleAttributeName value: [NSNumber numberWithInteger:NSUnderlineStyleSingle] range:clickTextRange]; // 下划线
            }
            [self.lastlyTextArr addObject:clickText];
        }
    }
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

- (void)setLineSpacing:(CGFloat)lineSpacing {
    _lineSpacing = lineSpacing;
}

- (void)setAgreeBtnNormalImageName:(NSString *)agreeBtnNormalImageName {
    _agreeBtnNormalImageName = agreeBtnNormalImageName;
    self.checkImg.image = [UIImage imageNamed:agreeBtnNormalImageName];
}

- (void)setAgreeBtnSelectedImageName:(NSString *)agreeBtnSelectedImageName {
    _agreeBtnSelectedImageName = agreeBtnSelectedImageName;
}

- (void)setIsSetUnderline:(BOOL)isSetUnderline {
    _isSetUnderline = isSetUnderline;
}

- (void)setIsShowLeftAgreeBtn:(BOOL)isShowLeftAgreeBtn {
    _isShowLeftAgreeBtn = isShowLeftAgreeBtn;
    self.leftAgreeBtn.hidden = isShowLeftAgreeBtn;
}

- (void)setIsAddOnlyLastOneLink:(BOOL)isAddOnlyLastOneLink {
    _isAddOnlyLastOneLink = isAddOnlyLastOneLink;
}

#pragma mark ----------------- UITextViewDelegate -----------------
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    // 点击文字触发
    NSString *clickText = [textView.text substringWithRange:characterRange];
    for (int i = 0; i < self.lastlyTextArr.count; i++) {
        if ([clickText isEqualToString:self.lastlyTextArr[i]]) {
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
    if (sender.selected) {
        self.checkImg.image = [UIImage imageNamed:self.agreeBtnSelectedImageName];
    } else {
        self.checkImg.image = [UIImage imageNamed:self.agreeBtnNormalImageName];
    }
    if (self.agreeBtnClickBlock) {
        self.agreeBtnClickBlock(sender);
    }
}

@end
