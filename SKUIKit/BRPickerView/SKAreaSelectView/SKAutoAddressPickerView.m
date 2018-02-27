//
//  SKAutoAddressPickerView.m
//  GZCanLian
//
//  Created by Sakya on 2017/12/27.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "SKAutoAddressPickerView.h"
#import <MJExtension/MJExtension.h>

CGFloat const Height_segmentButton  = 35;
CGFloat const Width_segmentButton  = 80;
CGFloat const Height_mainAreaView  = 250; //默认高度地区选择器
CGFloat const Height_toolbar  = 40; //默认工具栏高度
NSInteger const Font_CellText = 30;

#define SKAutoSCREEN_BOUNDS [UIScreen mainScreen].bounds
#define SKAutoSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SKAutoSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

static const NSInteger toolbarLeftButtonTag = 10000;
static const NSInteger toolbarRightButtonTag = 10001;


@interface SKAutoAddressPickerView ()<UIGestureRecognizerDelegate>{
    CGFloat currentOffsetX;
    NSInteger _selectIndex; ///< 选择的button index  from 0
}
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIScrollView *areaScrollView;
@property (nonatomic, strong) UIScrollView *buttonScrollView; ///<标题的滚动啊试图
@property (nonatomic, strong) UIView *areaWhiteBaseView;
@property (nonatomic, strong) UILabel *toolbarTitleLabel;
//
@property (nonatomic, strong) NSMutableArray *tableViews;
@property (nonatomic, strong) NSMutableArray *titleButtons;

@end
@implementation SKAutoAddressPickerView
#define HTFont(s) [UIFont fontWithName:@"Helvetica-Light" size:s / 2 * MULPITLE]
#define MULPITLE [[UIScreen mainScreen] bounds].size.width / 375
#define RGB_HEX(rgbValue, a) \
[UIColor colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((CGFloat)(rgbValue & 0xFF)) / 255.0 alpha:(a)]

#define SKPickerViewSystomColor RGB_HEX(0x00b400, 1)

#pragma mark -- init
- (instancetype)init {
    if (self = [super init]) {
        
        self.frame = SKAutoSCREEN_BOUNDS;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapBackgroundView:)];
        myTap.delegate=self;
        [self addGestureRecognizer:myTap];
        _selectIndex = 0;
        [self initCustomView];
    }
    return self;
}
- (void)initCustomView {
    
    _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SKAutoSCREEN_WIDTH, Height_mainAreaView + Height_toolbar)];
    _backgroundView.backgroundColor = RGB_HEX(0xF5F5F5, 1.0f);;
    [self addSubview:_backgroundView];
    //确定按钮哦
    UIButton *determineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    determineButton.frame = CGRectMake(SKAutoSCREEN_WIDTH - 70, 6, 60, Height_toolbar - 12);
    [determineButton setTitleColor:SKPickerViewSystomColor forState:UIControlStateNormal];
    [determineButton setTitle:@"确认" forState:UIControlStateNormal];
   determineButton.titleLabel.font =  [UIFont systemFontOfSize:15.0f];
    determineButton.tag = toolbarRightButtonTag;
    [determineButton addTarget:self action:@selector(pickerViewToolbarAction:) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundView addSubview:determineButton];

    
    //全部的话则可以取消
    UIButton *selectAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAllButton.frame = CGRectMake(10, 6, 60, Height_toolbar - 12);
    [selectAllButton setTitleColor:SKPickerViewSystomColor forState:UIControlStateNormal];
    [selectAllButton setTitle:@"全部" forState:UIControlStateNormal];
    selectAllButton.titleLabel.font =  [UIFont systemFontOfSize:15.0f];
    selectAllButton.tag = toolbarLeftButtonTag;
    [selectAllButton addTarget:self action:@selector(pickerViewToolbarAction:) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundView addSubview:selectAllButton];
    
    
    _areaWhiteBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, Height_toolbar, SKAutoSCREEN_WIDTH, Height_mainAreaView)];
    _areaWhiteBaseView.backgroundColor = [UIColor whiteColor];
    [_backgroundView addSubview:_areaWhiteBaseView];
  
    //设置buttonScrollview
    _buttonScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SKAutoSCREEN_WIDTH, Height_segmentButton + 2)];
    _buttonScrollView.backgroundColor = [UIColor whiteColor];
    _buttonScrollView.showsHorizontalScrollIndicator = NO;
    [_areaWhiteBaseView addSubview:_buttonScrollView];
    
    _areaScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, Height_segmentButton + 2, SKAutoSCREEN_WIDTH, _areaWhiteBaseView.bounds.size.height - Height_segmentButton - 2)];
    _areaScrollView.delegate = self;
    _areaScrollView.pagingEnabled = YES;
    _areaScrollView.showsVerticalScrollIndicator = NO;
    _areaScrollView.showsHorizontalScrollIndicator = NO;
    _areaScrollView.bounces = NO;
    [_areaWhiteBaseView addSubview:_areaScrollView];
}
#pragma mark --publick
- (void)pickerViewUpdateAddressArea:(AddressAreaModel *)areaModel {
    //    需要先判断是否本层有数据
    if (areaModel.districts.count == 0) {
        [self pickerViewToolbarAction:nil];
        return;
    }
    [self.dataSource addObject:areaModel];
    //判断视图之前是否创建了
    NSInteger index = self.dataSource.count - 1;
    [self setUpTableViewIndex:index];
    //
    CGFloat contentWidth = SKAutoSCREEN_WIDTH * self.dataSource.count;
    _areaScrollView.contentSize = CGSizeMake(contentWidth, _areaScrollView.bounds.size.height - Height_segmentButton - 2);
    
    [UIView animateWithDuration:0.5 animations:^{
        _areaScrollView.contentOffset = CGPointMake(SKAutoSCREEN_WIDTH * index, 0);
    }];
    //    button
    [self setUpSegmentControlButtonIndex:index title:areaModel.parentName];
    [self updateButtonScrollView];
}
- (void)pickerViewAddDataSource:(id)area {
    AddressAreaModel *areaModel = [AddressAreaModel mj_objectWithKeyValues:area];
    [self pickerViewUpdateAddressArea:areaModel];
}
- (void)updateButtonScrollView {
    CGFloat buttonContentSize = 0.0;
    if (self.titleButtons.count >= self.dataSource.count) {
        UIButton *button = self.titleButtons[self.dataSource.count - 1];
        buttonContentSize = button.frame.origin.x + button.bounds.size.width;
    }
    _buttonScrollView.contentSize = CGSizeMake(buttonContentSize, _buttonScrollView.bounds.size.height);
}
- (void)pickerViewShow {
    // 1.获取当前应用的主窗口
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    // 动画前初始位置
    CGRect rect = _backgroundView.frame;
    rect.origin.y = SKAutoSCREEN_HEIGHT;
    _backgroundView.frame = rect;
    _backgroundView.alpha = 1;
    // 浮现动画
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = _backgroundView.frame;
        rect.origin.y -= Height_mainAreaView + Height_toolbar;
        _backgroundView.frame = rect;
    }];
}
- (void)pickerViewHide {
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = _backgroundView.frame;
        rect.origin.y += Height_toolbar + Height_mainAreaView;
        _backgroundView.frame = rect;
        _backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)setUpTableViewIndex:(NSInteger)index {
    
    UITableView *tableView = [_areaScrollView viewWithTag:200 + index];
    if (!tableView) {
        UITableView *area_tableView = [[UITableView alloc]initWithFrame:CGRectMake(SKAutoSCREEN_WIDTH * index, 0, SKAutoSCREEN_WIDTH, _areaScrollView.bounds.size.height) style:UITableViewStylePlain];
        area_tableView.backgroundColor = [UIColor clearColor];
        area_tableView.tableFooterView = [UIView new];
        area_tableView.showsVerticalScrollIndicator = NO;
        area_tableView.delegate = self;
        area_tableView.dataSource = self;
        area_tableView.tag = 200 + index;
        [_areaScrollView addSubview:area_tableView];
        [_tableViews addObject:area_tableView];
    } else {
        [tableView reloadData];
    }
}
- (void)setUpSegmentControlButtonIndex:(NSInteger)index
                                 title:(NSString *)title {
    
    UIButton *areaBtn = [_areaWhiteBaseView viewWithTag:100 + index];
    CGFloat buttonWidth = [self getLabelWidth:title font:30 height:Height_segmentButton] + 20;
    if (!areaBtn) {
        CGFloat buttonOrX = 0.0f;
        if (self.titleButtons.count > 0) {
            UIButton *button = _titleButtons.lastObject;
            buttonOrX = button.frame.origin.x + button.bounds.size.width;
        }
        areaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        areaBtn.frame = CGRectMake(buttonOrX, 0, buttonWidth, Height_segmentButton);
        areaBtn.tag = 100 + index;
        [areaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        areaBtn.titleLabel.font = HTFont(30);
        [areaBtn setTitle:title forState:UIControlStateNormal];
        [areaBtn addTarget:self action:@selector(areaBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonScrollView addSubview:areaBtn];
        [self.titleButtons addObject:areaBtn];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(buttonOrX + 10, Height_segmentButton, buttonWidth - 20, 2)];
        lineView.backgroundColor = SKPickerViewSystomColor;
        lineView.tag = 300 + index;
        [_buttonScrollView addSubview:lineView];
        
    } else {
        UIButton *lastBtn = [_buttonScrollView viewWithTag:100 + index - 1];
        CGFloat buttonOrX  = areaBtn.frame.origin.x + buttonWidth;
        if (lastBtn) {
            buttonOrX = lastBtn.frame.origin.x + lastBtn.bounds.size.width;
        }
        areaBtn.frame = CGRectMake(buttonOrX, 0, buttonWidth, areaBtn.bounds.size.height);
        [areaBtn setTitle:title forState:UIControlStateNormal];
        areaBtn.hidden = NO;
        UIView *currentBottomView = [_buttonScrollView viewWithTag:300 + index];
        currentBottomView.frame = CGRectMake(buttonOrX + 10, Height_segmentButton, buttonWidth - 20, 2);
        currentBottomView.hidden = NO;
    }
}
#pragma mark -- tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    AddressAreaModel *areaModel = self.dataSource[tableView.tag - 200];
    return areaModel.districts.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"CELLID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    AddressAreaModel *areaModel = ((AddressAreaModel *)self.dataSource[tableView.tag - 200]).districts[indexPath.row];
    cell.textLabel.text = areaModel.administrativeName;
    if (areaModel.isSelected) {
        cell.textLabel.textColor =  SKPickerViewSystomColor;
    } else {
        cell.textLabel.textColor =  [UIColor blackColor];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSInteger index = tableView.tag - 200;
    AddressAreaModel *parentAreaModel = (AddressAreaModel *)self.dataSource[index];
    [parentAreaModel.districts enumerateObjectsUsingBlock:^(AddressAreaModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == indexPath.row) {
            obj.isSelected = YES;
        } else {
            obj.isSelected = NO;
        }
    }];
    [tableView reloadData];
    AddressAreaModel *areaModel = parentAreaModel.districts[indexPath.row];
    _selectIndex = index;
    //选择后如果之前未选中的
//    if (![parentAreaModel.parentName isEqualToString:areaModel.administrativeName]) {
        parentAreaModel.parentName = areaModel.administrativeName;
        //移除数据
        if (self.dataSource.count > index) {
            [self.dataSource removeObjectsInRange: NSMakeRange(index + 1, self.dataSource.count - index -1)];
        }
        [self updateAreaSegmentontrolTitle:parentAreaModel.parentName index:index sameLast:NO];
        //
        _areaSelectBlock ? _areaSelectBlock(areaModel) : nil;
//    } else {
//        //判断是不是最后一个了啊
//        if (index < 3) {
//            [UIView animateWithDuration:0.5 animations:^{
//                _areaScrollView.contentOffset = CGPointMake(SKAutoSCREEN_WIDTH * (index + 1), 0);
//            }];
//        } else {
//            _areaSelectBlock ? _areaSelectBlock(areaModel) : nil;
//        }
//    }

}
- (void)updateAreaSegmentontrolTitle:(NSString *)title
                               index:(NSInteger)index
                            sameLast:(BOOL)sameLast {
    
    CGFloat buttonWidth = [self getLabelWidth:title font:30 height:Height_segmentButton] + 20;
    UIButton *button = self.titleButtons[index];
    button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, buttonWidth, button.bounds.size.height);
    [button setTitle:title forState:UIControlStateNormal];
    UIView *bottomView = [_buttonScrollView viewWithTag:300 + index];
    bottomView.frame = CGRectMake(button.frame.origin.x + 10, Height_segmentButton, buttonWidth - 20, bottomView.bounds.size.height);
    for (NSInteger i = index + 1; i < self.titleButtons.count; i ++) {
        UIButton *beyondButton = [_buttonScrollView viewWithTag:100 + i];
        beyondButton.hidden = YES;
        UIView *beyondBottomView = [_buttonScrollView viewWithTag:300 + i];
        beyondBottomView.hidden = YES;
    }
    [self updateButtonScrollView];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    currentOffsetX = scrollView.contentOffset.x;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UITableView class]]) return;
    for (UIView *view in _buttonScrollView.subviews) {
        if (view.tag >= 300) {
            view.hidden = YES;
        }
    }
    if (scrollView == _areaScrollView) {
        UIView *lineView = [_buttonScrollView viewWithTag:300 + scrollView.contentOffset.x / (375 * MULPITLE)];
        lineView.hidden = NO;
    }
}
#pragma mark --event response
- (void)areaBtnAction:(UIButton *)sender {
    for (UIView *view in _areaWhiteBaseView.subviews) {
        if (view.tag >= 300) view.hidden = YES;
    }
    UIView *lineView = [_areaWhiteBaseView viewWithTag:300 + sender.tag - 100];
    lineView.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        _areaScrollView.contentOffset = CGPointMake(SKAutoSCREEN_WIDTH * (sender.tag - 100), 0);
    }];
}
- (void)pickerViewToolbarAction:(UIButton *)sender {
    if (sender && sender.tag == 10000) {
        _areaSelectFinishBlock ? _areaSelectFinishBlock(nil) : nil;
    } else {
        __block AddressAreaModel *selectAreaModel;
        for (NSInteger i = self.dataSource.count - 1; i >= 0; i --) {
            AddressAreaModel *tmpAreaModel = self.dataSource[i];
            [tmpAreaModel.districts enumerateObjectsUsingBlock:^(AddressAreaModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.isSelected) {
                    selectAreaModel = obj;
                    *stop = YES;
                }
            }];
            if (selectAreaModel != nil) break;
        }
        _areaSelectFinishBlock ? _areaSelectFinishBlock(selectAreaModel) : nil;
    }
    [self pickerViewHide];
}
- (void)didTapBackgroundView:(UITapGestureRecognizer *)sender {
    [self pickerViewHide];
}
#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//判断如果点击的是tableView的cell，就把手势给关闭了
        return NO;//关闭手势
    }//否则手势存在
    return YES;
}
#pragma mark -- lazy load
- (NSMutableArray *)tableViews {
    if (!_tableViews) {
        _tableViews = [NSMutableArray array];
    }
    return _tableViews;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (NSMutableArray *)titleButtons {
    if (!_titleButtons) {
        _titleButtons = [NSMutableArray array];
    }
    return _titleButtons;
}
- (UILabel *)toolbarTitleLabel {
    if (!_toolbarTitleLabel) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((SKAutoSCREEN_WIDTH-120)/2, 6, 120, Height_toolbar - 12)];
        titleLabel.textColor = SKPickerViewSystomColor;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"请选择地区";
        _toolbarTitleLabel = titleLabel;
    }
    return _toolbarTitleLabel;
}
#pragma mark -- setter
- (void)setToolbarStyle:(SKAddressPickerViewToolbarStyle)toolbarStyle {
    _toolbarStyle = toolbarStyle;
    switch (toolbarStyle) {
        case SKAddressPickerViewToolbarHtmlStyle:
            [_backgroundView viewWithTag:toolbarLeftButtonTag].hidden = YES;
            break;
        case SKAddressPickerViewToolbarStatisticsStyle:
            
            break;
        case SKAddressPickerViewToolbarOfflineAddStyle:
            [_backgroundView viewWithTag:toolbarLeftButtonTag].hidden = YES;
            [_backgroundView viewWithTag:toolbarRightButtonTag].hidden = YES;
            break;
        default:
            
            break;
    }
}

//计算文字的宽度
- (CGFloat)getLabelWidth:(NSString *)textStr font:(CGFloat)fontSize height:(CGFloat)labelHeight {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5 * MULPITLE; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *attribute = @{NSFontAttributeName: HTFont(fontSize),NSParagraphStyleAttributeName:paraStyle};
    CGSize size = [textStr boundingRectWithSize:CGSizeMake(1000, labelHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    return size.width;
}
@end


@interface AreaSelectCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *selectedImageView;
@end
@implementation AreaSelectCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initCustomView];
    }
    return self;
}
- (void)initCustomView {

}
@end
