//
//  BaseViewController.h
//  Dinner
//
//  Created by 周 加飞 on 14-7-10.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//  基类

#import <UIKit/UIKit.h>
#import "config.h"

@interface BaseViewController : UIViewController

-(void)showLoading;//显示正在加载的提示
-(void)hideTip;//隐藏提示框
-(void)sendNotificationForCartChanged;//当美食筐数量发生变化发送通知

@end
