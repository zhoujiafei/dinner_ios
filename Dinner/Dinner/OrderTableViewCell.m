//
//  OrderTableViewCell.m
//  Dinner
//
//  Created by 周 加飞 on 14-7-17.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "OrderTableViewCell.h"

@implementation OrderTableViewCell

@synthesize shopName = _shopName;
@synthesize totalPrice = _totalPrice;
@synthesize orderStatus = _orderStatus;
@synthesize orderTime = _orderTime;
@synthesize orderDate = _orderDate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //上边
        UIImageView *topRect = [[UIImageView alloc] initWithFrame:CGRectMake(20,8, self.frame.size.width - 30, 3)];
        topRect.image = [UIImage imageNamed:@"cell_top_rec"];
        
        //中间
        UIImageView *midRect = [[UIImageView alloc] initWithFrame:CGRectMake(20,11, self.frame.size.width - 30,65)];
        midRect.image = [UIImage imageNamed:@"cell_mid_rec"];
        
        //下边
        UIImageView *bottomRect = [[UIImageView alloc] initWithFrame:CGRectMake(20,76, self.frame.size.width - 30, 3)];
        bottomRect.image = [UIImage imageNamed:@"cell_buttom_rec"];
        
        //书的连接
        UIImageView *linker = [[UIImageView alloc] initWithFrame:CGRectMake(10, 34, 22, 21)];
        linker.image = [UIImage imageNamed:@"rec_cell_linker"];
        
        //向右的箭头
        UIImageView *rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 30, 37, 8, 13)];
        rightArrow.image = [UIImage imageNamed:@"orderCellRightArrow"];
        
        _shopName = [[UILabel alloc] initWithFrame:CGRectMake(80, 13, 140, 30)];
        _shopName.font = [UIFont systemFontOfSize:16];

        _totalPrice = [[UILabel alloc] initWithFrame:CGRectMake(80, 44, 140, 30)];
        _totalPrice.font = [UIFont systemFontOfSize:14];
        _totalPrice.textColor = [UIColor grayColor];
        
        _orderStatus = [[UILabel alloc] initWithFrame:CGRectMake(220,13, 60, 30)];
        _orderStatus.font = [UIFont systemFontOfSize:14];
        
        _orderTime = [[UILabel alloc] initWithFrame:CGRectMake(220, 44, 80, 30)];
        _orderTime.font = [UIFont systemFontOfSize:14];
        _orderTime.textColor = [UIColor grayColor];
        
        _orderDate = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 58, 20)];
        _orderDate.font = [UIFont systemFontOfSize:10];
        _orderDate.textColor = [UIColor whiteColor];
        
        [self.contentView addSubview:topRect];
        [self.contentView addSubview:midRect];
        [self.contentView addSubview:bottomRect];
        [self.contentView addSubview:linker];
        [self.contentView addSubview:rightArrow];
        [self.contentView addSubview:_shopName];
        [self.contentView addSubview:_totalPrice];
        [self.contentView addSubview:_orderStatus];
        [self.contentView addSubview:_orderTime];
        [self.contentView addSubview:_orderDate];
    }
    return self;
}

@end
