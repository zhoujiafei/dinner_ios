//
//  ClockViewController.m
//  Dinner
//
//  Created by 刘 金兰 on 14-7-20.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "ClockViewController.h"

@implementation ClockViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"订餐提醒";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showClock];
}

//显示提醒界面
-(void)showClock
{
    UISwitch *clockSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(54.0f, 84.0f, 0.0f, 0.0f)];
    clockSwitch.on = YES;
    clockSwitch.onTintColor = APP_BASE_COLOR;
    
    [self.view addSubview:clockSwitch];
    
    
    
    
    
}

@end
