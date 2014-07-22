//
//  AboutUsViewController.m
//  Dinner
//
//  Created by 刘 金兰 on 14-7-20.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "AboutUsViewController.h"

@implementation AboutUsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"关于我们";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showAboutUs];
}

//显示关于我们的界面
-(void)showAboutUs
{
    //应用图标图片
    UIImageView *appIconView = [[UIImageView alloc] initWithFrame:CGRectMake(120, 150, 80, 80)];
    appIconView.image = [UIImage imageNamed:@"avatar.jpg"];
    
    //应用名称
    UILabel *appName = [[UILabel alloc] initWithFrame:CGRectMake(115, 230, 90, 25)];
    appName.text = @"阿吃啦";
    appName.textAlignment = NSTextAlignmentCenter;
    appName.font = [UIFont systemFontOfSize:18];
    
    //版本号
    UILabel *version = [[UILabel alloc] initWithFrame:CGRectMake(125, 255, 70, 20)];
    version.text = @"v1.0.0";
    version.textAlignment = NSTextAlignmentCenter;
    version.font = [UIFont systemFontOfSize:12];
    version.textColor = [UIColor grayColor];
    
    UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(35, 280, 250, 100)];
    detail.textColor = [UIColor grayColor];
    detail.textAlignment = NSTextAlignmentCenter;
    detail.font = [UIFont systemFontOfSize:14];
    detail.numberOfLines = 0;
    detail.lineBreakMode = NSLineBreakByWordWrapping;
    detail.text = @"阿吃啦是您订餐的首选，更方便，更快捷，更时尚，快来玩转阿吃啦吧！@_@";
    
    //公司
    UILabel *company = [[UILabel alloc] initWithFrame:CGRectMake(80, 380, 160, 30)];
    company.textColor = [UIColor grayColor];
    company.font = [UIFont systemFontOfSize:14];
    company.textAlignment = NSTextAlignmentCenter;
    company.text = @"www.zhouxingxing.com";
    
    //地址
    UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(60, 410, 200, 30)];
    address.textColor = [UIColor grayColor];
    address.font = [UIFont systemFontOfSize:14];
    address.textAlignment = NSTextAlignmentCenter;
    address.text = @"杭州西湖雷峰塔白娘子路188号";
    
    [self.view addSubview:appIconView];
    [self.view addSubview:appName];
    [self.view addSubview:version];
    [self.view addSubview:detail];
    [self.view addSubview:company];
    [self.view addSubview:address];
}

@end
