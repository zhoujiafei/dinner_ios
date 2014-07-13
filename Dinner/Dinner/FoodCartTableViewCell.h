//
//  FoodCartTableViewCell.h
//  Dinner
//
//  Created by 刘 金兰 on 14-7-12.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "config.h"

@interface FoodCartTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *menuImageView;//菜图
@property (nonatomic,strong) UILabel *menuName;//菜名
@property (nonatomic,strong) UILabel *menuPrice;//菜的价格
@property (nonatomic,strong) UIStepper *stepper;//步进器

@end
