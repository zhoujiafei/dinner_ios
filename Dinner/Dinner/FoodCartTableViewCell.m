//
//  FoodCartTableViewCell.m
//  Dinner
//
//  Created by 刘 金兰 on 14-7-12.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "FoodCartTableViewCell.h"

@implementation FoodCartTableViewCell

@synthesize menuImageView   = _menuImageView;
@synthesize menuName        = _menuName;
@synthesize menuPrice       = _menuPrice;
@synthesize stepper         = _stepper;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.frame = CGRectMake(0.0, 0.0, [[UIScreen mainScreen] bounds].size.width, 80);
        //菜的图片
        _menuImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        _menuImageView.layer.cornerRadius = 8.0;
        _menuImageView.layer.masksToBounds = YES;
        
        //菜名
        _menuName = [[UILabel alloc] initWithFrame:CGRectMake(80, 8, 100, 30)];
        _menuName.font = [UIFont fontWithName:@"Verdana" size:16];
        
        //菜的价格
        _menuPrice = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, 100, 30)];
        _menuPrice.textColor = APP_BASE_COLOR;
        _menuPrice.font = [UIFont systemFontOfSize:12];
        
        //步进器
        _stepper = [[UIStepper alloc] initWithFrame:CGRectMake(216, 12, 80, 30)];
        _stepper.value = 1;//默认是1
        _stepper.minimumValue = 0;
        _stepper.maximumValue = 100;
        
        [self.contentView addSubview:_menuImageView];
        [self.contentView addSubview:_menuName];
        [self.contentView addSubview:_menuPrice];
        [self.contentView addSubview:_stepper];
    }
    return self;
}

@end
