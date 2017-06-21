//
//  SKPickerView.m
//  UnionProgarm
//
//  Created by Sakya on 17/3/17.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "SKPickerView.h"

//设备屏幕尺寸 scale
#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
#define kScreen_Frame    (CGRectMake(0, 0 ,kScreen_Width,kScreen_Height))
#define kScreen_CenterX  kScreen_Width/2
#define kScreen_CenterY  kScreen_Height/2

@interface SKPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate> {
    NSString *_defaultSelectText;

    PickerViewType _pickType;

}
@property (nonatomic, strong) UIPickerView *stylePickView;
@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) NSMutableArray *titleArray;
@end
@implementation SKPickerView


- (instancetype)initWithFrame:(CGRect)frame
                   pickerType:(PickerViewType)pickerType
                   titleTexts:(NSArray *) titleTexts {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];

        __weak typeof(self) weakSelf = self;
    
        _pickType = pickerType;
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height , kScreen_Width, 0)];
        [_backView setBackgroundColor:[UIColor whiteColor]];
        [self setUserInteractionEnabled:YES];
        [self addSubview:_backView];
        
        UITapGestureRecognizer *gestrue = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CancelChoose)];//给view视图添加一个点击手势
        [self addGestureRecognizer:gestrue];
        [self creatPickView];
    }
    return self;
}



- (void)creatPickView {
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 50)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(topView.frame) - 50 /2, 0, 100, CGRectGetHeight(topView.frame))];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:16]];
    _titleLabel = label;
    NSArray *titleArray = @[@"取消",@"确定"];
    for (NSInteger i = 0; i < titleArray.count; i ++) {
       
        UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [editButton setTitle:titleArray[i] forState:UIControlStateNormal];
        [editButton addTarget:self action:@selector(clickToFinishSelect:) forControlEvents:UIControlEventTouchUpInside];
        editButton.tag = i;
    

        [editButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [editButton setFrame:CGRectMake(10, 0, 50, CGRectGetHeight(topView.frame))];
     
        [topView addSubview:editButton];
    }
    [topView addSubview:label];
    
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, kScreen_Width, 150)];
    [pickerView setDelegate:self];
    [pickerView setDataSource:self];
    pickerView.showsSelectionIndicator = YES;
    for (UIView *view in pickerView.subviews) {
        if (view.bounds.size.height < 2.0f && view.backgroundColor == nil) {
            view.backgroundColor = [UIColor grayColor]; // line color
        }
    }
    [pickerView selectRow:0 inComponent:0 animated:YES];

    self.stylePickView = pickerView;
    [_backView addSubview:topView];
    [_backView addSubview:self.stylePickView];
    
}

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
        
    }
    return _titleArray;
}
#pragma mark - setter
- (void)setTitleText:(NSString *)titleText {
    
    _titleText = titleText;
    _titleLabel.text = titleText;
}

- (void)setPickerTitleArray:(NSArray *)pickerTitleArray {
   
    _pickerTitleArray = pickerTitleArray;
    __weak typeof(self) weakSelf = self;
    [weakSelf.titleArray removeAllObjects];
    //
//    if (pickerTitleArray.count > 0) {
//        [pickerTitleArray enumerateObjectsUsingBlock:^(MeSelectUnitsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            
//            [weakSelf.titleArray addObject:obj.name];
//            if (idx + 1 == weakSelf.titleArray.count) {
//                
//                [weakSelf.stylePickView reloadAllComponents];
//            }
//        }];
//    } else {
//        [weakSelf.titleArray addObject:@"暂无街道信息"];
//        [weakSelf.stylePickView reloadAllComponents];
//    }
 

}
- (void)setTitleType:(NSString *)titleType {
   
    _titleType = titleType;
    
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    if (_pickType == PickerViewSingleRowType) {
        return 1;
    }
    return _titleArray.count;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_pickType == PickerViewSingleRowType) {
        return _titleArray.count;
    }
    return ((NSArray *)_titleArray[component]).count;

}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel *pickerLabel = (UILabel *)view;
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 200, 60);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
    }
    if (_pickType == PickerViewSingleRowType) {
        if (component == 0) {
            pickerLabel.text = [self.titleArray objectAtIndex:row];
        }
    } else {
        pickerLabel.text = [self.titleArray[component] objectAtIndex:row];
    }
    
    return pickerLabel;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 40;
}
-(void)CancelChoose {
    
    [UIView animateWithDuration:0.5 animations:^{
        [_backView setFrame:CGRectMake(0, kScreen_Height, kScreen_Width, 0)];
        [self setAlpha:0];
    }];
}

-(void)clickToFinishSelect:(UIButton *)sender{
    
    if (sender.tag == 1) {


       
        if (self.delegate && [self.delegate respondsToSelector:@selector(skpickerViwSelectresults:)]) {
            NSInteger selectedRow = [self.stylePickView selectedRowInComponent:0];
            NSDictionary *result;
            
       
            [self.delegate skpickerViwSelectresults:result];

        }
    }
    [self dissmiss];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    [self endChoiceReturenText];
}
-(void)endChoiceReturenText {
    
    
}
- (void)show {
    
    [[[UIApplication  sharedApplication] keyWindow] addSubview:self] ;
    [UIView animateWithDuration:.7 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 / 0.8 options:0 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.alpha = 1;
        [_backView setFrame:CGRectMake(0, kScreen_Height - 200, kScreen_Width, 200)];
    } completion:^(BOOL finished) {
        
    }];
    
}
- (void)dissmiss {
    
    [UIView animateWithDuration:.5 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.alpha = 0;
        [_backView setFrame:CGRectMake(0, kScreen_Height, kScreen_Width, 0)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
