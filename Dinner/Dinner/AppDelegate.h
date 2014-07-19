//
//  AppDelegate.h
//  Dinner
//
//  Created by 刘 金兰 on 14-7-5.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "config.h"
#import "BaseNavigationController.h"
#import "BaseTabBarController.h"
#import "HomeViewController.h"
#import "CenterViewController.h"
#import "SettingViewController.h"
#import "CartViewController.h"
#import "MoreViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) BaseNavigationController *homeNav;
@property (nonatomic,strong) BaseNavigationController *cartNav;
@property (nonatomic,strong) BaseNavigationController *centerNav;
@property (nonatomic,strong) BaseNavigationController *moreNav;

@end
