//
//  OrderTableViewCell.m
//  Dinner
//
//  Created by 周 加飞 on 14-7-17.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "OrderTableViewCell.h"

@implementation OrderTableViewCell

@synthesize shopName    = _shopName;
@synthesize totalPrice  = _totalPrice;
@synthesize orderStatus = _orderStatus;
@synthesize orderDate   = _orderDate;
@synthesize menuName    = _menuName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *indexPicView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 30, 30)];
        indexPicView.image = [UIImage imageNamed:@"defaultShop.jpg"];
        indexPicView.layer.cornerRadius = 5.0;
        indexPicView.layer.masksToBounds = YES;
        
        _shopName = [[UILabel alloc] initWithFrame:CGRectMake(5, 50, 40, 15)];
        _shopName.font = [UIFont systemFontOfSize:10];
        _shopName.textColor = [UIColor grayColor];
        
        //竖直分割线
        UIImageView *verticalLine = [[UIImageView alloc] initWithFrame:CGRectMake(50,15, 1, 45)];
        verticalLine.image = [UIImage imageNamed:@"detail_line_v"];
        
        _menuName = [[UILabel alloc] initWithFrame:CGRectMake(60, 18, 150, 20)];
        _menuName.font = [UIFont systemFontOfSize:16];
        _menuName.textColor = [UIColor grayColor];
        
        _orderDate = [[UILabel alloc] initWithFrame:CGRectMake(60, 40, 70, 15)];
        _orderDate.font = [UIFont systemFontOfSize:10];
        _orderDate.textColor = [UIColor grayColor];
        
        _totalPrice = [[UILabel alloc] initWithFrame:CGRectMake(210, 10, 100, 25)];
        _totalPrice.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:16];
        _totalPrice.textAlignment = NSTextAlignmentRight;
        
        _orderStatus = [[UILabel alloc] initWithFrame:CGRectMake(210, 38, 100, 15)];
        _orderStatus.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:14];
        _orderStatus.textAlignment = NSTextAlignmentRight;

        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 70-0.5, self.frame.size.width, 0.5)];
        line.image = [UIImage imageNamed:@"x-line"];
        
        [self.contentView addSubview:line];
        [self.contentView addSubview:verticalLine];
        [self.contentView addSubview:indexPicView];
        [self.contentView addSubview:_shopName];
        [self.contentView addSubview:_menuName];
        [self.contentView addSubview:_orderDate];
        [self.contentView addSubview:_totalPrice];
        [self.contentView addSubview:_orderStatus];
    }
    return self;
}

@end
