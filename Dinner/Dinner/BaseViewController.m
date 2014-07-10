//
//  BaseViewController.m
//  Dinner
//
//  Created by 周 加飞 on 14-7-10.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "BaseViewController.h"

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1.0];
}

//正在加载提示框
-(void)showLoading
{
    [ProgressHUD show:@"正在加载..."];
}

//隐藏提示框
-(void)hideTip
{
    [ProgressHUD dismiss];
}

@end
