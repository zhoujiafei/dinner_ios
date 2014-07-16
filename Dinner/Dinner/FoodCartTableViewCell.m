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
@synthesize leftBtn         = _leftBtn;
@synthesize rightBtn        = _rightBtn;
@synthesize menuNum         = _menuNum;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
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
        
        //减按钮
        _leftBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _leftBtn.frame = CGRectMake(220, 12, 30, 30);
        [_leftBtn setTitle:@"＋" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _leftBtn.backgroundColor = APP_BASE_COLOR;
        _leftBtn.layer.cornerRadius = 5.0;
        
        //显示数量的框子
        _menuNum = [[UILabel alloc] initWithFrame:CGRectMake(250, 12, 30, 30)];
        _menuNum.textAlignment = NSTextAlignmentCenter;
        
        _rightBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _rightBtn.frame = CGRectMake(280, 12, 30, 30);
        [_rightBtn setTitle:@"－" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rightBtn.backgroundColor = APP_BASE_COLOR;
        _rightBtn.layer.cornerRadius = 5.0;

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 80-0.5, self.frame.size.width, 0.5)];
        line.backgroundColor = [UIColor colorWithRed:213.0f/255.0f green:213.0f/255.0f blue:213.0f/255.0f alpha:1.0];
        [self.contentView addSubview:line];
        
        [self.contentView addSubview:_menuImageView];
        [self.contentView addSubview:_menuName];
        [self.contentView addSubview:_menuPrice];
        [self.contentView addSubview:_leftBtn];
        [self.contentView addSubview:_rightBtn];
        [self.contentView addSubview:_menuNum];
    }
    return self;
}

@end
