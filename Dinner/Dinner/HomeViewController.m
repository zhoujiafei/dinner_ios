//
//  HomeViewController.m
//  Dinner
//
//  Created by 刘 金兰 on 14-7-5.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "HomeViewController.h"

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"首页";
    self.view.backgroundColor = [UIColor redColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(110, 80, 110, 45);
    [btn setTitle:@"查看菜单" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(seeMenus) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

-(void)seeMenus
{
    MenuViewController *menu = [[MenuViewController alloc] init];
    [self.navigationController pushViewController:menu animated:YES];
}

@end
