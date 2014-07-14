//
//  FoodCartTableViewCell.h
//  Dinner
//
//  Created by 刘 金兰 on 14-7-12.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "config.h"

#define kMenuNumTag 1000 //显示菜的个数的label的tag基准值

@interface FoodCartTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *menuImageView;//菜图
@property (nonatomic,strong) UILabel *menuName;//菜名
@property (nonatomic,strong) UILabel *menuPrice;//菜的价格
@property (nonatomic,strong) UIButton *leftBtn;//减按钮
@property (nonatomic,strong) UIButton *rightBtn;//加按钮
@property (nonatomic,strong) UILabel *menuNum;//显示某一道菜所选的个数

@end
