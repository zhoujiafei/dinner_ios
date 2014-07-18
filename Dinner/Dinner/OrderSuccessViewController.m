//
//  OrderSuccessViewController.m
//  Dinner
//
//  Created by 周 加飞 on 14-7-15.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "OrderSuccessViewController.h"

@implementation OrderSuccessViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"下单成功";
    }
    return self;
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
                                initWithFrame:CGRectMake(76, 120, 128,159)];
    xiaoren.image = [UIImage imageNamed:@"cm_center_price_1"];
    [self.view addSubview:bgImageView];
    [self.view addSubview:xiaoren];
    
}

@end
