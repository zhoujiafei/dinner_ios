//
//  MenuViewController.m
//  Dinner
//
//  Created by 刘 金兰 on 14-7-5.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "MenuViewController.h"

@implementation MenuViewController

@synthesize shopId = _shopId;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"菜单";
    self.view.backgroundColor = [UIColor greenColor];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:GET_MENUS_API,_shopId]]];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error)
    {
        NSData *data = [request responseData];
        NSDictionary *allData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSLog(@"%@",allData);
        
        
        
        
        
        
    }
    else
    {
        [ProgressHUD showError:@"网络不可用"];
    }
}

@end
