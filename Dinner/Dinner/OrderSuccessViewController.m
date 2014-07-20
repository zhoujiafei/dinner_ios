//
//  OrderSuccessViewController.m
//  Dinner
//
//  Created by 周 加飞 on 14-7-15.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "OrderSuccessViewController.h"

@implementation OrderSuccessViewController

@synthesize userInfo = _userInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"下单成功";
        _userInfo = [NSMutableDictionary dictionary];
        [self getUserInfo];
    }
    return self;
}

//获取用户信息
-(void)getUserInfo
{
    NSDictionary *data = [[DataManage shareDataManage] getData:CACHE_NAME withNetworkApi:@"__userinfo"];
    if (data)
    {
        [_userInfo setDictionary:data];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showSuccessOk];
}

-(void)showSuccessOk
{
    UIImageView *bgImageView = [[UIImageView alloc]
                                initWithFrame:CGRectMake(20, 85, self.view.frame.size.width - 40, self.view.frame.size.height - 105)];
    bgImageView.image = [UIImage imageNamed:@"cm_center_sv_bg"];
    
    
    UIImageView *xiaoren = [[UIImageView alloc]
                                initWithFrame:CGRectMake(150, 350, 128,159)];
    xiaoren.image = [UIImage imageNamed:@"cm_center_price_1"];
    
    UIImageView *qiqiu = [[UIImageView alloc]
                            initWithFrame:CGRectMake(50, 150, 256,256)];
    qiqiu.image = [UIImage imageNamed:@"qiqiu"];
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(30, 100, self.view.frame.size.width - 60, 40)];
    title.text = [NSString stringWithFormat:@"%@ 您好，你已成功下单！",[_userInfo objectForKey:@"name"]];
    title.font = [UIFont systemFontOfSize:20];
    title.textColor = APP_BASE_COLOR;
    
    UIButton *backHome = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backHome.frame = CGRectMake(20, 300, 100, 45);
    [backHome setTitle:@"返回首页" forState:UIControlStateNormal];
    [backHome setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [backHome addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *zhuizong = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    zhuizong.frame = CGRectMake(20, 350, 100, 45);
    [zhuizong setTitle:@"查看订单" forState:UIControlStateNormal];
    [zhuizong setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [zhuizong addTarget:self action:@selector(seeOrder) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:bgImageView];
    [self.view addSubview:xiaoren];
    [self.view addSubview:qiqiu];
    [self.view addSubview:title];
    [self.view addSubview:backHome];
    [self.view addSubview:zhuizong];
}

//回到首页
-(void)backToHome
{
    
}

//查看订单
-(void)seeOrder
{
    
}



@end
