//
//  MenuTableViewCell.m
//  Dinner
//
//  Created by 周 加飞 on 14-7-9.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "MenuTableViewCell.h"

@implementation MenuTableViewCell
@synthesize menuImageView   = _menuImageView;
@synthesize menuName        = _menuName;
@synthesize menuPrice       = _menuPrice;
@synthesize menuDetail      = _menuDetail;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.frame = CGRectMake(0.0, 0.0, [[UIScreen mainScreen] bounds].size.width, 100);
        
        //菜的图片
        _menuImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
        _menuImageView.layer.cornerRadius = 8.0;
        _menuImageView.layer.masksToBounds = YES;
        
        //菜名
        _menuName = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 100, 30)];
        _menuName.font = [UIFont fontWithName:@"Verdana" size:16];
        
        //小星星图标
        UIImage *starImage = [UIImage imageNamed:@"star"];
        UIColor *color = [[UIColor alloc] initWithPatternImage:starImage];
        UIView *starView = [[UIView alloc] initWithFrame:CGRectMake(100, 42, 80, 18)];
        [starView setBackgroundColor:color];
        
        //菜的价格
        _menuPrice = [[UILabel alloc] initWithFrame:CGRectMake(230, 10, 80, 30)];
        _menuPrice.textColor = [UIColor redColor];
        _menuPrice.font = [UIFont systemFontOfSize:12];
        _menuPrice.textAlignment = NSTextAlignmentRight;
        
        //菜的简介
        _menuDetail = [[UILabel alloc] initWithFrame:CGRectMake(100, 60, 120, 30)];
        _menuDetail.textColor = [UIColor grayColor];
        _menuDetail.font = [UIFont systemFontOfSize:14];
        
        //按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(230, 60, 80, 30);
        [btn.layer setCornerRadius:5.0];
        [btn setTitle:@"吃一份" forState:UIControlStateNormal];
        [btn setBackgroundColor:APP_BASE_COLOR];
        
        [self.contentView addSubview:_menuImageView];
        [self.contentView addSubview:_menuName];
        [self.contentView addSubview:_menuPrice];
        [self.contentView addSubview:_menuDetail];
        [self.contentView addSubview:btn];
        [self.contentView addSubview:starView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
//    self.backgroundColor = [UIColor blueColor];
}

@end
