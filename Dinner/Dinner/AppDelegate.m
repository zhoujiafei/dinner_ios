    //
//  AppDelegate.m
//  Dinner
//
//  Created by 刘 金兰 on 14-7-5.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize homeNav = _homeNav;
@synthesize cartNav = _cartNav;
@synthesize centerNav = _centerNav;
@synthesize moreNav = _moreNav;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //创建缓存数据表
    [[DataManage shareDataManage] createTableName:CACHE_NAME];
    //创建美食筐的数据表
    [[DataManage shareDataManage] createTableName:FOOD_CART];
    
    //获取美食筐里面美食菜种类的个数
    NSArray *foodCart = [[DataManage shareDataManage] getData:FOOD_CART withNetworkApi:@"cart"];
    NSInteger foodNum = 0;
    if (![foodCart isEqual:nil] && [foodCart count] > 0)
    {
        foodNum = [foodCart count];
    }
    
    //首页
    HomeViewController *home = [[HomeViewController alloc] init];
    _homeNav = [[BaseNavigationController alloc] initWithRootViewController:home];
    _homeNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"tab_all_normal"] tag:1];
    
    //美食筐
    CartViewController *cart = [[CartViewController alloc] init];
    _cartNav = [[BaseNavigationController alloc] initWithRootViewController:cart];
    _cartNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"美食筐" image:[UIImage imageNamed:@"trolley"] tag:2];
    
    if (foodNum > 0)
    {
        _cartNav.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",foodNum];
    }
    
    //用户中心
    CenterViewController *center = [[CenterViewController alloc] init];
    _centerNav = [[BaseNavigationController alloc] initWithRootViewController:center];
    _centerNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"用户中心" image:[UIImage imageNamed:@"tab_personal_normal"] tag:3];
    
    //设置
    MoreViewController *more = [[MoreViewController alloc] init];
    _moreNav = [[BaseNavigationController alloc] initWithRootViewController:more];
    _moreNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"更多" image:[UIImage imageNamed:@"tab_more"] tag:4];
    
    //创建UITabBar，并且将各子级导航加入到里面
    BaseTabBarController *tab = [[BaseTabBarController alloc] init];
    tab.viewControllers = @[_homeNav,_cartNav,_centerNav,_moreNav];
    
    
    //加入到窗口
    self.window.rootViewController = tab;
    //注册通知，一旦美食筐里面的数量发生变化，就更改 _cartNav.tabBarItem.badgeValue 的值
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCartNum:) name:FOOD_NUM_CHANGED_NOTICE object:nil];
    return YES;
}

//通知观察者
-(void)changeCartNum:(NSNotification *)notification
{
    NSDictionary *info = notification.userInfo;
    NSString *tag = [info objectForKey:@"cartNum"];
    if ([tag isEqualToString:@""])
    {
        tag = nil;
    }
    _cartNav.tabBarItem.badgeValue = tag;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//接收到通知
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIAlertView *remind = [[UIAlertView alloc] initWithTitle:@"提醒" message:notification.alertBody delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [remind show];
}

@end
