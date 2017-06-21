//
//  SKAlertView.m
//  UnionProgarm
//
//  Created by Sakya on 17/3/17.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "SKAlertView.h"

//中间显示框的高度 default
static const CGFloat SKAlertViewMiddleViewMinHeight = 160 - 44 - 30;
//弹框高度 default
static const CGFloat SKAlertViewBigViewWidth = 280.0f;
//弹框宽度 default
static const CGFloat SKAlertViewBigViewHeight = 160.0f;
//按钮高度
static const CGFloat SKAlertViewButtonHeight = 44;

#define W CGRectGetWidth([UIScreen mainScreen].bounds)
#define H CGRectGetHeight([UIScreen mainScreen].bounds)
#define WIDTH(view) view.frame.size.width
#define HEIGHT(view) view.frame.size.height
#define X(view) view.frame.origin.x
#define Y(view) view.frame.origin.y

@interface SKAlertView ()<UITextFieldDelegate> {
    
    NSArray *_buttonTitles;
    UIView *_bigView;
    BOOL _isInitializing;
    NSString *_title;

}
@property (nonatomic, readonly) UIWindow *frontWindow;
@property (nonatomic, strong) UIView *bigView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UITextField *textField; //SKAlertViewTextFieldType 输入框信息

@property (nonatomic, strong) NSMutableArray *buttonArray;

@end

@implementation SKAlertView

#pragma mark - Instance Methods

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                  buttonArray:(NSArray *)buttonArray;{
    
    
    
    if (self = [super initWithFrame:frame]) {
        
        _isInitializing = YES;
        
        _buttonTitles = buttonArray;
        _alertType = SKAlertViewStyleDefault;
        _buttonConfiguration = SKAlertViewButtonConfigurationHorizontal;
        _title = title;

        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        self.alpha = 0.0f;
        self.bigView.alpha = 0.0f;
        [self initCustomView];

        
        _isInitializing = NO;

    }
    
    return self;
}
- (UIView *)bigView {
    if (!_bigView) {

        _bigView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SKAlertViewBigViewWidth, SKAlertViewBigViewHeight)];
        _bigView.center = CGPointMake(W / 2, H / 2);
        _bigView.layer.cornerRadius = 10;
        _bigView.layer.masksToBounds = YES;
        [_bigView setClipsToBounds:YES];
        [_bigView setBackgroundColor:[UIColor whiteColor]];
    }
    if(!_bigView.superview){

        [self insertSubview:_bigView belowSubview:self];
    }
    return _bigView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(0, 0, CGRectGetWidth(_bigView.frame), 30);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor redColor];
        _titleLabel = titleLabel;
    }
    if(!_titleLabel.superview){
        
        [_bigView addSubview:_titleLabel];
    }
    return _titleLabel;
}
- (UITextField *)textField {
    if (!_textField) {
        
        _textField = [[UITextField alloc] init];
        _textField.bounds = CGRectMake(0, 0, CGRectGetWidth(_bigView.frame) - 30, 50);
        _textField.center = CGPointMake(_bigView.bounds.size.width/2, (CGRectGetHeight(_bigView.frame) - 44 - CGRectGetHeight(_titleLabel.frame))/2+CGRectGetHeight(_titleLabel.frame));
        _textField.layer.masksToBounds = YES;
        _textField.delegate = self;
        _textField.layer.borderWidth = .5f;
        _textField.layer.cornerRadius = 4.0f;
        _textField.layer.borderColor = [UIColor blackColor].CGColor;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.font = [UIFont systemFontOfSize:17.0f];
        _textField.textColor = [UIColor blackColor];
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 10)];

    }
    return _textField;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.frame = CGRectMake(15, CGRectGetMaxY(_titleLabel.frame), CGRectGetWidth(_bigView.frame) - 30, CGRectGetHeight(_bigView.frame) - 44 - CGRectGetHeight(_titleLabel.frame));
        _contentLabel.font = [UIFont systemFontOfSize:17.0f];
        _contentLabel.textColor = [UIColor grayColor];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.numberOfLines = 0;
    }
    
    return _contentLabel;
}
- (NSMutableArray *)buttonArray {
    
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _buttonArray;
}

- (void)initCustomView {
    
    if (_title) self.titleLabel.text = _title;
    if (_buttonTitles.count > 0) {
        
        NSInteger buttonCount = _buttonTitles.count;
        for (NSInteger i = 0;i < _buttonTitles.count;i ++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = self.frame;
            [button setTag:i];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            if (i == buttonCount - 1) {
                [button setBackgroundColor:[UIColor orangeColor]];
            } else {
                [button setBackgroundColor:[UIColor blueColor]];
            }
            [button addTarget:self action:@selector(clickToCancelAndDete:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:_buttonTitles[i] forState:UIControlStateNormal];
            [_bigView addSubview:button];
            [self.buttonArray addObject:button];
        }
    }
    
    
    
}
- (void)updateViewHierarchy {
    if (self.containerView) {
        
        [self.containerView addSubview:self];
    } else {
        [self.frontWindow addSubview:self];
    }
}
#pragma mark - textFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [_textField resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewTextFieldChangedDetectedText:)]) {
        NSString *fillInText = _textField.text;
        if (fillInText && [fillInText length] > 0) {
            
            [self.delegate alertViewTextFieldChangedDetectedText:fillInText];
        }
    }
}
#pragma mark - UITextFieldTextDidChangeNotification
- (void)textFieldDidChanged:(NSNotification *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewTextFieldChangedDetectedText:)]) {
        NSString *fillInText = _textField.text;
        if (fillInText && [fillInText length] > 0) {
            
            [self.delegate alertViewTextFieldChangedDetectedText:fillInText];
        }
    }
}
#pragma mark -  Setters
- (void)setMaxSupportedWindowLevel:(UIWindowLevel)maxSupportedWindowLevel {
    if (!_isInitializing) _maxSupportedWindowLevel = maxSupportedWindowLevel;
}
- (void)setContainerView:(UIView *)containerView {
    if (!_isInitializing) _containerView = containerView;
}
- (void)setTitleText:(NSString *)titleText {
    if (!_isInitializing) self.titleLabel.text = titleText;
}
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    if (!_isInitializing) self.textField.placeholder = placeholder;

}
- (void)setContent:(NSString *)content {
    _content = content;
    

}
-(void)setAlertType:(SKAlertViewStyle)alertType {
   
    _alertType = alertType;
    if (!_isInitializing) {
        switch (alertType) {
            case SKAlertViewStyleDefault:
                if (_textField) [_textField removeFromSuperview];
                [_bigView addSubview:self.contentLabel];
                
                break;
            case SKAlertViewStyleTextField:
                if (_contentLabel) [_contentLabel removeFromSuperview];
                [_bigView addSubview:self.textField];
                [self registerNotifications];
                break;
            default:
                break;
        }
    }
}

#pragma mark - action
-(void)clickToCancelAndDete:(UIButton *)sender
{
    
    [self dissmiss];
    if (sender.tag == 1) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewActionDetected:)]) {
            [self.delegate alertViewActionDetected:sender];
        }
    }
}
#pragma mark - Show AlertView
- (void)show {
    
    [self updateViewHierarchy];
    
    __weak SKAlertView *weakSelf = self;
    [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 / 0.8 options:0 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        weakSelf.alpha = 1;
        weakSelf.bigView.alpha = 1;
        weakSelf.bigView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
    }];

}

#pragma mark - hide alertView
- (void)dissmiss {
    
    __weak SKAlertView *weakSelf = self;

    [UIView animateWithDuration:.2 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {

        [weakSelf removeFromSuperview];
    }];
}
- (UIWindow *)frontWindow {

    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal && window.windowLevel <= self.maxSupportedWindowLevel);
        
        if(windowOnMainScreen && windowIsVisible && windowLevelSupported) {
            return window;
        }
    }
    return nil;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    CGFloat labelHeight = 0.0f;
    
    if (_alertType == SKAlertViewStyleDefault) {
        _contentLabel.text = _content;
        CGRect labelRect = CGRectZero;
        CGFloat labelWidth = 0.0f;
        CGSize constraintSize = CGSizeMake(CGRectGetWidth(_bigView.frame) - 30, 300.0f);
        labelRect = [_content boundingRectWithSize:constraintSize
                                           options:(NSStringDrawingOptions)(NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin)
                                        attributes:@{NSFontAttributeName: self.contentLabel.font}
                                           context:NULL];
        labelHeight = ceilf(CGRectGetHeight(labelRect));
        labelWidth = ceilf(CGRectGetWidth(labelRect));
    } else if (_alertType == SKAlertViewStyleTextField) {
        
        labelHeight = SKAlertViewMiddleViewMinHeight;
        _textField.text = _content;
    }
    CGFloat bigViewHeight = 0.0f;
    CGFloat MidContentViewHeight = labelHeight > SKAlertViewMiddleViewMinHeight ? labelHeight : SKAlertViewMiddleViewMinHeight;
    
    if (_buttonConfiguration == SKAlertViewButtonConfigurationHorizontal) {
        
        bigViewHeight = 30 + MidContentViewHeight + SKAlertViewButtonHeight;
        
    } else if (_buttonConfiguration == SKAlertViewButtonConfigurationVertical) {
        bigViewHeight = 30 + MidContentViewHeight + SKAlertViewButtonHeight * _buttonArray.count;
    }
    [_bigView setBounds:CGRectMake(0, 0, SKAlertViewBigViewWidth, bigViewHeight)];
    
    _contentLabel.frame = CGRectMake(15, CGRectGetMaxY(_titleLabel.frame), CGRectGetWidth(_bigView.frame) - 30, MidContentViewHeight);
    
    if (_buttonArray.count > 0) {
        
        CGFloat buttonOriginY = MidContentViewHeight + 30;
        CGFloat buttonOriginX = 0.0f;
        CGFloat buttonWidth = SKAlertViewBigViewWidth/_buttonArray.count;
        
        for (UIButton *button in _buttonArray) {
            if (_buttonConfiguration == SKAlertViewButtonConfigurationHorizontal) {
                
                [button setFrame:CGRectMake(buttonOriginX, buttonOriginY, buttonWidth, SKAlertViewButtonHeight)];
                buttonOriginX += buttonWidth;
            } else if (_buttonConfiguration == SKAlertViewButtonConfigurationVertical) {
                
                [button setFrame:CGRectMake(0, buttonOriginY, SKAlertViewBigViewWidth, SKAlertViewButtonHeight)];
                buttonOriginY += SKAlertViewButtonHeight;
                
            }
        }
    }
    
}


#pragma mark - Notifications and their handling

- (void)registerNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}
//键盘事件
-(void)keyBoardWillShow:(NSNotification *)notification
{
    
    CGRect keyboardF = [[[notification userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    CGRect begin = [[[notification userInfo] objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect end = [[[notification userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    double duration=[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGFloat keyHeight = (HEIGHT(self)-Y(_bigView)-HEIGHT(_bigView))-keyboardF.size.height;
    // 第三方键盘回调三次问题，监听仅执行最后一次
    if(begin.size.height>0 && (begin.origin.y-end.origin.y>0)){
        [UIView animateWithDuration:duration animations:^{
            
            self.frame =CGRectMake(0, keyHeight, WIDTH(self), HEIGHT(self));
            
        }];
    }
    
}
-(void)keyBoardDidHide:(NSNotification *)notification{
    
    self.frame = CGRectMake(0, 0, WIDTH(self), HEIGHT(self));
}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
