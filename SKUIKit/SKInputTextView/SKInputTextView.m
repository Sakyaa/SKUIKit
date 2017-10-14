//
//  SKInputTextView.m
//  DangJian
//
//  Created by Sakya on 2017/9/25.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "SKInputTextView.h"
#import "SKInputPictureView.h"
#import "SKActionSheet.h"
#import "TZImagePickerController.h"




//相册，拍照
typedef NS_ENUM(NSInteger, ChosePhontType) {
    ChosePhontTypeAlbum,
    ChosePhontTypeCamera
};


#define UIColorRGB(x,y,z) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:1.0]

#define SKInputPictureHeight (kScreen_Width - MARGIN_MIN_SIZE *4)/3 + MARGIN_MIN_SIZE * 2


@interface SKInputTextView ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate> {
    BOOL statusTextView;//当文字大于限定高度之后的状态
    NSString *placeholderText;//设置占位符的文字
    SKInputTextViewType _inputViewType;
}
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) SKInputPictureView *pictureView;

@end
@implementation SKInputTextView

- (instancetype)initWithFrame:(CGRect)frame
            inputTextViewType:(SKInputTextViewType)type {
    self = [super initWithFrame:frame];
    if (self) {
        
        _inputViewType = type;
        [self createUI];
        //增加监听，当键盘出现或改变时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
        //增加监听，当键退出时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
    }
    /**
     点击 空白区域取消
     */
    UITapGestureRecognizer *centerTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(centerTapClick)];
    [self addGestureRecognizer:centerTap];
    return self;
}

- (void)createUI{
    
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(6);
        make.left.mas_equalTo(5);
        make.bottom.mas_equalTo(-6);
        if (_inputViewType == SKInputTextViewGeneralType) {
            make.width.mas_equalTo(kScreen_Width - 10);
        } else if (_inputViewType == SKInputTextViewPictureType ||
                   _inputViewType == SKInputTextViewPictureAutoDisType)  {
            make.width.mas_equalTo(kScreen_Width - 65);
        }
    }];
    
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(39);
    }];
    if (_inputViewType == SKInputTextViewGeneralType) {

    } else if (_inputViewType == SKInputTextViewPictureType||
               _inputViewType == SKInputTextViewPictureAutoDisType)  {
        [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(8);
            make.right.mas_equalTo(-5);
            make.width.mas_equalTo(50);
        }];
        [self.pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.bottom.mas_equalTo(self.backGroundView.mas_top);
            make.right.offset(0);
            make.height.offset(SKInputPictureHeight);
        }];
        self.pictureView.hidden = YES;
    }
}

//暴露的方法
- (void)setPlaceholderText:(NSString *)text{
    placeholderText = text;
    self.placeholderLabel.text = placeholderText;
}


//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification {
   
    if (self.pictureView.imageArray.count > 0) {
        self.pictureView.hidden = NO;
    }
    self.frame = kScreenBounds;
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    if (self.textView.text.length == 0) {
        
        self.backGroundView.frame = CGRectMake(0, kScreen_Height-height-49, kScreen_Width, 49);
    }else{
        CGRect rect = CGRectMake(0, kScreen_Height - self.backGroundView.frame.size.height-height, kScreen_Width, self.backGroundView.frame.size.height);
        self.backGroundView.frame = rect;
    }
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification {
    
    self.pictureView.hidden = YES;
    if (self.textView.text.length == 0) {
        self.backGroundView.frame = CGRectMake(0, 0, kScreen_Width, 49);
        self.frame = CGRectMake(0, kScreen_Height - 49, kScreen_Width, 49);
    }else{
        CGRect rect = CGRectMake(0, 0, kScreen_Width, self.backGroundView.frame.size.height);
        self.backGroundView.frame = rect;
        self.frame = CGRectMake(0, kScreen_Height - rect.size.height, kScreen_Width, self.backGroundView.frame.size.height);
    }
}

- (void)centerTapClick{
    [self.textView resignFirstResponder];
    //    如果是会自动消失的输入框
    if (_inputViewType == SKInputTextViewPictureAutoDisType) {
        self.hidden = YES;
    }
}

#pragma mark --- UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    /**
     *  设置占位符
     */
    if (textView.text.length == 0) {
        self.placeholderLabel.text = placeholderText;
    }else{
        self.placeholderLabel.text = @"";
    }
    
    CGFloat widthInputView;
    if (_inputViewType == SKInputTextViewGeneralType) {
        widthInputView = kScreen_Width - 10;
    } else if (_inputViewType == SKInputTextViewPictureType||
               _inputViewType == SKInputTextViewPictureAutoDisType)  {
        widthInputView = kScreen_Width - 65;
    } else {
        widthInputView = kScreen_Width - 65;
    }
    //---- 计算高度 ---- //
    CGSize size = CGSizeMake(widthInputView, CGFLOAT_MAX);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil];
    CGFloat curheight = [textView.text boundingRectWithSize:size
                                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                 attributes:dic
                                                    context:nil].size.height;
    CGFloat y = CGRectGetMaxY(self.backGroundView.frame);
    if (curheight < 19.094) {
        statusTextView = NO;
        self.backGroundView.frame = CGRectMake(0, y - 49, kScreen_Width, 49);
    }else if(curheight < MaxTextViewHeight){
        statusTextView = NO;
        self.backGroundView.frame = CGRectMake(0, y - textView.contentSize.height-10, kScreen_Width,textView.contentSize.height+10);
    }else{
        statusTextView = YES;
        return;
    }
    
}
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    NSLog(@"点击了发送按钮");
//    if (self.EwenTextViewBlock) {
//        self.EwenTextViewBlock(self.textView.text);
//    }
//    return YES;
//}



#pragma  mark -- 发送事件
- (void)sendContentClick{
    
    [self.textView endEditing:YES];
    if (self.EwenTextViewBlock) {
        self.EwenTextViewBlock(self.textView.text,self.pictureView.imageArray);
    }
    //    如果是会自动消失的输入框
    if (_inputViewType == SKInputTextViewPictureAutoDisType) {
        self.hidden = YES;
    }
    //---- 发送成功之后清空 ------//
    self.textView.text = nil;
    self.placeholderLabel.text = placeholderText;
    [self.pictureView.imageArray removeAllObjects];
    self.pictureView.hidden = YES;
    self.frame = CGRectMake(0, kScreen_Height-49, kScreen_Width, 49);
    self.backGroundView.frame = CGRectMake(0, 0, kScreen_Width, 49);
}
#pragma mark - UITextViewDelegate;
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return

        [self sendContentClick];
        //在这里做你响应return键的代码
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}



#pragma mark --- 懒加载控件
- (UIView *)backGroundView{
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 49)];
        _backGroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_backGroundView];
    }
    return _backGroundView;
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.backgroundColor = SystemGrayBackgroundColor;
        _textView.delegate = self;
        _textView.layer.cornerRadius = 5;
        _textView.returnKeyType = UIReturnKeySend;
        [self.backGroundView addSubview:_textView];
    }
    return _textView;
}

- (UILabel *)placeholderLabel{
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc]init];
        _placeholderLabel.font = [UIFont systemFontOfSize:15];
        _placeholderLabel.textColor = Color_c;
        [self.backGroundView addSubview:_placeholderLabel];
    }
    return _placeholderLabel;
}

- (UIButton *)selectButton{
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setImage:[UIImage imageNamed:@"general_addpicture_button"] forState:UIControlStateNormal];
        [_selectButton addTarget:self action:@selector(selectPictureEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.backGroundView addSubview:_selectButton];
    }
    return _selectButton;
}
- (SKInputPictureView *)pictureView {
    if (!_pictureView) {
        _pictureView = [[SKInputPictureView alloc] init];
        [self addSubview:_pictureView];
    }
    return _pictureView;
}

#pragma mark --- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (statusTextView == NO) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }else{
        
    }
}
#pragma mark -- action
- (void)selectPictureEvent:(UIButton *)sender {
   
    if (self.pictureView.imageArray.count > 2) {
        [SKHUDManager showBriefAlert:@"最多选择3张图片"];
        return;
    }
    [self.textView resignFirstResponder];
    SKActionSheet *actionSheetView = [[SKActionSheet alloc] initWithCancelStr:@"取消" otherButtonTitles:@[@"拍照",@"从手机相册"] AttachTitle:nil];
    actionSheetView.ButtonIndex = ^(NSInteger buttonIndex){
        
        switch (buttonIndex) {
            case 1:
                //           拍照
                [self chosePhoto:ChosePhontTypeCamera];
                break;
            case 2:  //打开相册拍照
                [self chosePhoto:ChosePhontTypeAlbum];
                break;
        }
    };
}
//selectphoto
- (void)chosePhoto:(ChosePhontType)type {
    
    
    if (type == ChosePhontTypeAlbum) {
        
        [self pushImagePickerController];
    } else if (type == ChosePhontTypeCamera) {
        
        UIImagePickerController *piker = [[UIImagePickerController alloc] init];
        piker.delegate = self;
        piker.allowsEditing=YES;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            piker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
        }else{
            return;
        }
        [[Helper superViewControllerWithView:self] presentViewController:piker animated:YES completion:^{
        }];
    }
}
#pragma mark - UIImagePickerControllerDelegate 选择图片
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }];
    
    //选择完照片
    _pictureView.selectArray = @[image];
    [self.textView becomeFirstResponder];
}



#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3 - self.pictureView.imageArray.count columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    UIViewController *currentViewController = [Helper superViewControllerWithView:self];
    imagePickerVc.delegate =self;
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    imagePickerVc.navigationBar.barTintColor = currentViewController.navigationController.navigationBar.barTintColor;
    imagePickerVc.navigationBar.tintColor = currentViewController.navigationController.navigationBar.tintColor;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.oKButtonTitleColorDisabled = Color_c;
    imagePickerVc.oKButtonTitleColorNormal = Color_system_red;
    imagePickerVc.needCircleCrop = NO;
    [[Helper superViewControllerWithView:self] presentViewController:imagePickerVc animated:YES completion:nil];
}
#pragma  mark -TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    NSMutableArray *selectedPhotos = [NSMutableArray arrayWithArray:photos];
    //    NSMutableArray *selectedAssets = [NSMutableArray arrayWithArray:assets];
    //选择完照片
    _pictureView.selectArray = selectedPhotos;
    [self.textView becomeFirstResponder];
}

- (void)dealloc {
    [MyNotification removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [MyNotification removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [MyNotification removeObserver:self];
}
@end
