//
//  config.h
//  Dinner
//
//  Created by 刘 金兰 on 14-7-6.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#ifndef Dinner_config_h
#define Dinner_config_h

#import "BaseViewController.h"
#import "BaseNavigationController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ProgressHUD.h"
#import "DataManage.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"

//定义该app主基调颜色风格
#define APP_BASE_COLOR ([UIColor colorWithRed:255/255.0 green:102/255.0 blue:143.0/255.0 alpha:1])
//定义系统背景色
#define SYSTEM_BG_COLOR ([UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1.0])
//定义系统版本
#define SYSTEM_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue])

//缓存表名
#define CACHE_NAME @"cacheData"
//美食框的表名
#define FOOD_CART @"foodCart"

//定义美食框数量发生变化的通知名称
#define FOOD_NUM_CHANGED_NOTICE @"foodCartChangedNotice"

//接口地址
#define GET_SHOPS_API @"http://localhost/dinner/branches/beta/index.php?r=api" //获取餐厅列表数据
#define GET_MENUS_API @"http://localhost/dinner/branches/beta/index.php?r=api/menu&shop_id=%@" //获取某个餐厅的菜单
#define LOGIN_API @"http://localhost/dinner/branches/beta/index.php?r=api/login" //用户登陆接口
#define ORDER_API @"http://localhost/dinner/branches/beta/index.php?r=api/center/confirmorder" //确认下单接口
#define GET_USERINFO_API @"http://localhost/dinner/branches/beta/index.php?r=api/center" //获取用户信息接口
#define GET_HISTORY_ORDER_API @"http://localhost/dinner/branches/beta/index.php?r=api/center/historyorder&access_token=%@" //获取历史订单接口
#define GET_TODAY_ORDER_API @"http://localhost/dinner/branches/beta/index.php?r=api/center/todayorder&access_token=%@" //获取今日订单接口
#define MODIFY_PASSWORD_API @"http://localhost/dinner/branches/beta/index.php?r=api/center/modifypassword" //修改密码接口


//#define GET_SHOPS_API @"http://localhost/dinner/index.php?r=api" //获取餐厅列表数据
//#define GET_MENUS_API @"http://localhost/dinner/index.php?r=api/menu&shop_id=%@" //获取某个餐厅的菜单
//#define LOGIN_API @"http://localhost/dinner/index.php?r=api/login" //用户登陆接口
//#define ORDER_API @"http://localhost/dinner/index.php?r=api/center/confirmorder" //确认下单接口
//#define GET_USERINFO_API @"http://localhost/dinner/index.php?r=api/center" //获取用户信息接口
//#define GET_HISTORY_ORDER_API @"http://localhost/dinner/index.php?r=api/center/historyorder&access_token=%@" //获取历史订单接口
//#define GET_TODAY_ORDER_API @"http://localhost/dinner/index.php?r=api/center/todayorder&access_token=%@" //获取今日订单接口
//#define MODIFY_PASSWORD_API @"http://localhost/dinner/index.php?r=api/center/modifypassword" //修改密码接口

#endif
