# AttributedString
富文本添加链接，一段文字上添加点击事件

有时候，在日常开发中，时长会遇到一些需求，如：在用户使用APP前，需要“用户使用协议”等可点击文本。

网上也有类似的demo实现，但本人觉得具有一定的局限性。比如有的只支持《用户协议》和《隐私政策》两处文字可点击。而我的这个demo则支持添加无限个可点击文本。

使用也简单，把需要点击的文字添加到一个数组传给YMAttributeTextView类的clickTextArr属性，再实现clickTextDidClickBlock回调即可。具体可看下面“如何使用”代码。

# 如何使用

1、下载demo，把YMAttributeTextView类拖进项目。在使用的地方#import "YMAttributeTextView.h"。

2、具体代码如下：
```
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTextViewUI];
}

- (void)setupTextViewUI {
    
    CGFloat onelineStr_H = [@"道" boundingRectWithSize:CGSizeMake(YMScreenWidth-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:YMContentSize]} context:nil].size.height;
    NSString *agreementText = @"    同意《超级悟道用户协议》和《超级悟道隐私政策》";
    CGFloat agreementStr_H = [agreementText boundingRectWithSize:CGSizeMake(YMScreenWidth-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:YMContentSize]} context:nil].size.height + onelineStr_H;
    YMAttributeTextView *agreementTextView = [[YMAttributeTextView alloc] initWithFrame:CGRectMake(12, 200, YMScreenWidth-24, agreementStr_H)];
    agreementTextView.clickTextArr = @[@"《超级悟道用户协议》",@"《超级悟道隐私政策》"]; // 设置"需要点击的文字"数组，只需agreementText中包含文字即可
    agreementTextView.textColor = [UIColor grayColor]; // 设置整体文字颜色
    agreementTextView.clickTextColor = [UIColor blackColor]; // 设置"需要点击的文字"颜色
    agreementTextView.fontSize = YMContentSize; // 设置整体文字大小
    agreementTextView.isSetUnderline = true; // 是否设置"需要点击的文字"下划线
    agreementTextView.isShowLeftAgreeBtn = NO; // 是否显示文字左侧勾选按钮
    agreementTextView.agreeBtnNormalImageName = @"ic_compared_checkbox_normal"; // 设置左侧勾选按钮常规状态图片
    agreementTextView.agreeBtnSelectedImageName = @"ic_compared_checkbox_selected"; // 设置左侧勾选按钮选中状态图片
    agreementTextView.contentText = agreementText; // 设置文字内容
    [self.view addSubview:agreementTextView];
    __weak typeof(self) weakself = self;
    agreementTextView.clickTextDidClickBlock = ^(NSString * _Nonnull clickText) { // "需要点击的文字" 点击回调
        NSLog(@"clickText===%@", clickText);
    };
    agreementTextView.agreeBtnClickBlock = ^(UIButton * _Nonnull button) { // 左侧勾选按钮选中与否回调
        NSLog(@"button.selected===%d", button.selected);
        weakself.agreeBtn = button;
    };
}
```

如需查看具体实现，请下载demo查看相关代码。
