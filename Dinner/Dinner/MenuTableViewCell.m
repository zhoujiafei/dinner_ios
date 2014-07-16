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
@synthesize btn             = _btn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
        _menuPrice.textColor = APP_BASE_COLOR;
        _menuPrice.font = [UIFont systemFontOfSize:12];
        _menuPrice.textAlignment = NSTextAlignmentRight;
        
        //菜的简介
        _menuDetail = [[UILabel alloc] initWithFrame:CGRectMake(100, 60, 120, 30)];
        _menuDetail.textColor = [UIColor grayColor];
        _menuDetail.font = [UIFont systemFontOfSize:14];
        
        //按钮
        _btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _btn.frame = CGRectMake(230, 60, 80, 30);
        [_btn.layer setCornerRadius:5.0];
        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btn setTitle:@"吃一份" forState:UIControlStateNormal];
        _btn.backgroundColor = APP_BASE_COLOR;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 100.0-0.5, self.frame.size.width, 0.5)];
        line.backgroundColor = [UIColor colorWithRed:213.0f/255.0f green:213.0f/255.0f blue:213.0f/255.0f alpha:1.0];
        [self.contentView addSubview:line];
        
        [self.contentView addSubview:_menuImageView];
        [self.contentView addSubview:_menuName];
        [self.contentView addSubview:_menuPrice];
        [self.contentView addSubview:_menuDetail];
        [self.contentView addSubview:_btn];
        [self.contentView addSubview:starView];
        [self.contentView addSubview:line];
    }
    return self;
}

@end
