//
//  ViewController.m
//  SKDemo
//
//  Created by Sakya on 17/3/22.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "ViewController.h"
#import "SKAlertView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setFrame:CGRectMake(15, 55, 200 - 30, 45)];
    [deleteButton setBackgroundColor:[UIColor redColor]];
    [deleteButton setTitle:@"删除该患者" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteButton.layer setMasksToBounds:YES];
    [deleteButton.layer setCornerRadius:5.0f];
    [deleteButton addTarget:self action:@selector(clickToDeleteFriend) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteButton];
}
- (void)clickToDeleteFriend {
    
    SKAlertView *alertView = [[SKAlertView alloc] initWithFrame:CGRectZero title:@"测试" buttonArray:@[@"取消",@"确定"]];
    alertView.alertType = SKAlertViewStyleTextField;
    alertView.buttonConfiguration = SKAlertViewButtonConfigurationVertical;
    alertView.content = @"nice 你还发烧的地nice";

    [alertView show];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
