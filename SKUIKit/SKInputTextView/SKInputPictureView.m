//
//  SKInputPictureView.m
//  DangJian
//
//  Created by Sakya on 2017/10/10.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "SKInputPictureView.h"
#import "UIImage+CornerRadius.h"


@interface SKInputPictureView ()
@property (nonatomic, strong) NSMutableArray *itemArray;
@end

@implementation SKInputPictureView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initCustomView];
    }
    return self;
}
- (void)initCustomView {
    CGFloat widthSize = (kScreen_Width - MARGIN_MIN_SIZE *4)/3;
    for (NSInteger i = 0; i < 3; i ++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake((MARGIN_MIN_SIZE + widthSize) * i + MARGIN_MIN_SIZE, MARGIN_MIN_SIZE, widthSize, widthSize);
        imageView.userInteractionEnabled = YES;
        imageView.hidden = YES;
        [self addSubview:imageView];
        [self.itemArray addObject:imageView];
        UIButton *deleteButton = [SKBuildKit buttonWithImageName:@"organization_deletePicture_icon" superview:imageView target:self action:@selector(deleteImaegeEvent:)];
        deleteButton.tag = TAG_BASE_MAX + i;
        deleteButton.frame = CGRectMake(widthSize - 25, -20, 40, 40);
    }
}
- (void)layoutSubviews {
    
    
}
- (void)reloadImageView {
    
    for (NSInteger index = 0; index < 3; index ++) {
        UIImage *image = self.imageArray.count > index ? self.imageArray[index] : nil;
        UIImageView *imageView = self.itemArray[index];
        if (image) {
            imageView.hidden = NO;
            CGFloat widthSize = (kScreen_Width - MARGIN_MIN_SIZE *4)/3;
            UIImage *cirImage = [image imageWithCornerRadius:0 imageSize:CGSizeMake(widthSize, widthSize)];
            imageView.image = cirImage;
        } else {
            imageView.hidden = YES;
        }
    }
    
}
- (void)setSelectArray:(NSArray *)selectArray {
    _selectArray = selectArray;
    [self.imageArray addObjectsFromArray:selectArray];
    [self reloadImageView];
    if (self.imageArray.count > 0) {
        self.hidden = NO;
    }
}
- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _imageArray;
}
- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _itemArray;
}
- (void)deleteImaegeEvent:(UIButton *)sender {
    if (self.imageArray.count > sender.tag - TAG_BASE_MAX) {
        [self.imageArray removeObjectAtIndex:sender.tag - TAG_BASE_MAX];
        [self reloadImageView];
    }
    if (self.imageArray.count == 0) {
        self.hidden = YES;
    }
}

@end
