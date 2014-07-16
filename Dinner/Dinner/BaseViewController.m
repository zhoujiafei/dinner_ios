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

//当美食框数量发生变化发送通知
-(void)sendNotificationForCartChanged
{
    //获取当前美食框的数量
    NSArray *foodCart = [[DataManage shareDataManage] getData:FOOD_CART withNetworkApi:@"cart"];
    NSString *numStr = @"";
    if (![foodCart isEqual:nil] && [foodCart count] > 0)
    {
        numStr = [NSString stringWithFormat:@"%d",[foodCart count]];
    }
    
    //发送通知
    NSNotification *notification = [NSNotification
                                    notificationWithName:FOOD_NUM_CHANGED_NOTICE
                                    object:nil
                                    userInfo:[NSDictionary dictionaryWithObject:numStr forKey:@"cartNum"]];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end


















