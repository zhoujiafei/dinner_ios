//
//  ShopTableViewCell.h
//  Dinner
//
//  Created by 刘 金兰 on 14-7-6.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "config.h"

@interface ShopTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *indexPicView;
@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UILabel *status;//餐厅状态
@property (nonatomic,strong) UIImageView *commentView;//评论小图标
@property (nonatomic,strong) UILabel *address;//地址
@property (nonatomic,strong) UILabel *phone;//电话
@property (nonatomic,strong) UIImageView *flatFree;//餐厅状态标志图

@end
