//
//  CenterViewController.h
//  Dinner
//
//  Created by 刘 金兰 on 14-7-5.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "config.h"
#import "LoginViewController.h"
#import "CenterTableViewCell.h"
#import "XHPathCover.h"
#import "HistoryOrderViewController.h"
#import "ModifyPasswordViewController.h"
#import "PersonalViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface CenterViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) XHPathCover *pathCover;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *settingLabels;
@property (nonatomic,strong) NSArray *settingIcons;
@property (nonatomic,strong) NSMutableDictionary *userInfo;//保存用户信息

@end
