//
//  MenuTableViewCell.h
//  Dinner
//
//  Created by 周 加飞 on 14-7-9.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "config.h"

@interface MenuTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *menuImageView;//菜图
@property (nonatomic,strong) UILabel *menuName;//菜名
@property (nonatomic,strong) UILabel *menuPrice;//菜的价格
@property (nonatomic,strong) UILabel *menuDetail;//菜的简介
@property (nonatomic,strong) UIButton *btn;


@end
