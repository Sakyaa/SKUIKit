//
//  SKSearchBar.m
//  UnionProgarm
//
//  Created by Sakya on 17/3/24.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#pragma mark - --- View 视图 ---
#import "SKSearchBar.h"
#pragma mark - --- Model 数据 ---

#pragma mark - --- Tool 工具 ---

NS_ASSUME_NONNULL_BEGIN
//整体的高
static const CGFloat SKSearchBarHeight = 50;
//搜索框的高
static const CGFloat SKTextFieldHeight = 32;
//左右的间距
static const CGFloat SKSearchBarMarginX = 9;
//上下间距
static const CGFloat SKSearchBarMarginY = (SKSearchBarHeight - SKTextFieldHeight)/2;
//图片的大小
static const CGFloat SKImageIconWeidth = 16;

@interface SKSearchBar ()<UITextFieldDelegate>
/** 1.输入框 */
@property (nonatomic, strong) UITextField *textField;
/** 2.取消按钮 */
@property (nonatomic, strong) UIButton *buttonCancel;
/** 3.搜索图标 */
@property (nonatomic, strong) UIImageView *imageIcon;
/** 4.中间视图 */
@property (nonatomic, strong) UIButton *buttonCenter;

@end

NS_ASSUME_NONNULL_END

@implementation SKSearchBar

#pragma mark - --- 1. init 视图初始化 ---
- (instancetype)init
{
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI{
    _placeholder = @"";
    _showsCancelButton = YES;
    _placeholderColor = [UIColor colorWithWhite:0.7 alpha:1];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, SKSearchBarHeight);
    self.backgroundColor = [UIColor colorWithRed:(201.0/255) green:(201.0/255) blue:(206.0/255) alpha:1];
    self.clipsToBounds = YES;
    [self addSubview:self.buttonCancel];
    [self addSubview:self.textField];
    [self addSubview:self.buttonCenter];
}

#pragma mark - --- 2. delegate 视图委托 ---

#pragma mark - UITextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGRect frameButtonCenter = self.buttonCenter.frame;
    frameButtonCenter.origin.x = CGRectGetMinX(self.textField.frame);
    [UIView animateWithDuration:0.3 animations:^{
        self.buttonCenter.frame = frameButtonCenter;
                if (self.showsCancelButton) {
                    self.buttonCancel.frame = CGRectMake(self.frame.size.width - 60, 0, 60, SKSearchBarHeight);
                    self.textField.frame = CGRectMake(SKSearchBarMarginX, SKSearchBarMarginY, self.buttonCancel.frame.origin.x-SKSearchBarMarginX, SKTextFieldHeight);
                }
    } completion:^(BOOL finished) {
        [self.buttonCenter setHidden:YES];
        [self.imageIcon setHidden:NO];
        self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName:self.placeholderColor}];
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sk_searchBarShouldBeginEditing:)]) {
        return [self.delegate sk_searchBarShouldBeginEditing:self];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sk_searchBarTextDidBeginEditing:)])
    {
        [self.delegate sk_searchBarTextDidBeginEditing:self];
    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sk_searchBarShouldEndEditing:)]) {
        
        return [self.delegate sk_searchBarShouldEndEditing:self];
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text length] == 0) {
        [self.buttonCenter setHidden:NO];
        [self.imageIcon setHidden:YES];
        self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName:self.placeholderColor}];
        [UIView animateWithDuration:0.3 animations:^{
            if (self.showsCancelButton) {
                self.buttonCancel.frame = CGRectMake(self.frame.size.width, 0, 60, SKSearchBarHeight);
                self.textField.frame = CGRectMake(SKSearchBarMarginX, SKSearchBarMarginY, self.frame.size.width-SKSearchBarMarginX*2, SKTextFieldHeight);
            }
            self.buttonCenter.center = self.textField.center;
        } completion:^(BOOL finished) {
            
        }];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(sk_searchBarTextDidEndEditing:)])
    {
        [self.delegate sk_searchBarTextDidEndEditing:self];
    }
}
-(void)textFieldDidChange:(UITextField *)textField
{
    
    if (textField.text.length > 0) {
        [self.buttonCancel setHighlighted:YES];
    }else {
        [self.buttonCancel setHighlighted:NO];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sk_searchBar:textDidChange:)])
    {
        [self.delegate sk_searchBar:self textDidChange:textField.text];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sk_searchBar:shouldChangeTextInRange:replacementText:)])
    {
        return [self.delegate sk_searchBar:self shouldChangeTextInRange:range replacementText:string];
    }
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sk_searchBar:textDidChange:)]) {
        [self.delegate sk_searchBar:self textDidChange:@""];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sk_searchBarSearchButtonClicked:)]) {
        [self.delegate sk_searchBarSearchButtonClicked:self];
    }
    return YES;
}
#pragma mark - --- 3. event response 事件相应 ---
-(void)cancelButtonTouched
{
    self.textField.text = @"";
    [self.textField resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sk_searchBarCancelButtonClicked:)]) {
        [self.delegate sk_searchBarCancelButtonClicked:self];
    }
}
#pragma mark - --- 4. private methods 私有方法 ---
- (BOOL)becomeFirstResponder
{
    return [self.textField becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    return [self.textField resignFirstResponder];
}
#pragma mark - --- 5. setters 属性 ---
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    [self.buttonCenter setTitle:placeholder forState:UIControlStateNormal];
    [self.buttonCenter sizeToFit];
    self.buttonCenter.center = self.textField.center;
}

- (void)setText:(NSString *)text
{
    self.textField.text = text?:@"";
    if (text.length > 0) {
        [self textFieldShouldBeginEditing:self.textField];
    }
}

- (void)setInputAccessoryView:(UIView *)inputAccessoryView
{
    _inputAccessoryView = inputAccessoryView;
    self.textField.inputAccessoryView = inputAccessoryView;
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.textField.textColor = textColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    NSAssert(_placeholder, @"Please set placeholder before setting placeholdercolor");
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName:placeholderColor}];
    [self.buttonCenter setTitleColor:placeholderColor forState:UIControlStateNormal];
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    self.textField.font = font;
    self.buttonCenter.titleLabel.font = font;
    [self.buttonCenter sizeToFit];
}

#pragma mark - --- 6. getters 属性 —

- (NSString *)text
{
    return self.textField.text;
}

- (UITextField *)textField
{
    if (!_textField) {
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(SKSearchBarMarginX, SKSearchBarMarginY, self.frame.size.width-SKSearchBarMarginX*2, SKTextFieldHeight)];
        textField.delegate = self;
        textField.borderStyle = UITextBorderStyleNone;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.returnKeyType = UIReturnKeySearch;
        textField.enablesReturnKeyAutomatically = YES;
        textField.font = [UIFont systemFontOfSize:14.0f];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [textField addTarget:self
                      action:@selector(textFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];
        textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        textField.borderStyle=UITextBorderStyleNone;
        textField.layer.cornerRadius = 4.0f;
        textField.layer.masksToBounds=YES;
        textField.backgroundColor = [UIColor whiteColor];
        [textField setLeftViewMode:UITextFieldViewModeAlways];
        //左侧的view
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, CGRectGetHeight(self.frame))];
        [leftView addSubview:self.imageIcon];
        textField.leftView = leftView;
        [textField setClipsToBounds:YES];
        _textField = textField;
        
    }
    return _textField;
}

- (UIButton *)buttonCancel
{
    if (!_buttonCancel) {
        UIButton *buttonCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonCancel.frame = CGRectMake(self.frame.size.width, 0, 60, SKSearchBarHeight);
        buttonCancel.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [buttonCancel addTarget:self
                         action:@selector(cancelButtonTouched)
               forControlEvents:UIControlEventTouchUpInside];
        [buttonCancel setTitle:@"取消" forState:UIControlStateNormal];
        [buttonCancel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [buttonCancel setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        buttonCancel.autoresizingMask =UIViewAutoresizingFlexibleLeftMargin;
        
        _buttonCancel = buttonCancel;
    }
    return _buttonCancel;
}

- (UIButton *)buttonCenter
{
    if (!_buttonCenter) {
        
        UIButton *buttonCenter = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonCenter setImage:[UIImage imageNamed:@"me_unitSearch_icon"] forState:UIControlStateNormal];
        [buttonCenter setTitleColor:_placeholderColor forState:UIControlStateNormal];
        [buttonCenter setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, +6)];
        [buttonCenter.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [buttonCenter setEnabled:NO];
        buttonCenter.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [buttonCenter sizeToFit];
        _buttonCenter = buttonCenter;
    }
    return _buttonCenter;
}

- (UIImageView *)imageIcon
{
    if (!_imageIcon) {
        
        UIImageView *imageIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, (SKSearchBarHeight - SKImageIconWeidth)/2, SKImageIconWeidth, SKImageIconWeidth)];
        [imageIcon setImage:[UIImage imageNamed:@"me_unitSearch_icon"]];
        imageIcon.contentMode = UIViewContentModeScaleAspectFit;
        [imageIcon setHidden:YES];
        _imageIcon = imageIcon;
    }
    return _imageIcon;
}
@end
