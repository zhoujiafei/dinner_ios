//
//  OrderSuccessViewController.m
//  Dinner
//
//  Created by 周 加飞 on 14-7-15.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "OrderSuccessViewController.h"

@implementation OrderSuccessViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"下单成功";
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    bgImageView.image = [UIImage imageNamed:@"Garfield.jpg"];
    [self.view addSubview:bgImageView];
}

@end
