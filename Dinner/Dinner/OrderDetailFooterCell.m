//
//  OrderDetailFooterCell.m
//  Dinner
//
//  Created by 周 加飞 on 14-7-25.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "OrderDetailFooterCell.h"

@implementation OrderDetailFooterCell

@synthesize orderNum  = _orderNum;
@synthesize orderTime = _orderTime;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        infoLabel.textColor = APP_BASE_COLOR;
        infoLabel.font = [UIFont systemFontOfSize:16];
        infoLabel.text = @"订单信息";
        
        //订单号标签
        UILabel *orderNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 100, 20)];
        orderNumLabel.textColor = [UIColor grayColor];
        orderNumLabel.font = [UIFont systemFontOfSize:12];
        orderNumLabel.text = @"订单号";
        
        //订单号
        _orderNum = [[UILabel alloc] initWithFrame:CGRectMake(110, 35, 200, 20)];
        _orderNum.textColor = [UIColor grayColor];
        _orderNum.font = [UIFont systemFontOfSize:12];
        
        //下单时间标签
        UILabel *ordeTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 100, 20)];
        ordeTimeLabel.textColor = [UIColor grayColor];
        ordeTimeLabel.font = [UIFont systemFontOfSize:12];
        ordeTimeLabel.text = @"下单时间";
        
        //下单时间
        _orderTime = [[UILabel alloc] initWithFrame:CGRectMake(110, 60, 200, 20)];
        _orderTime.textColor = [UIColor grayColor];
        _orderTime.font = [UIFont systemFontOfSize:12];
        
        //状态跟踪
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 85, 100, 20)];
        statusLabel.textColor = [UIColor grayColor];
        statusLabel.font = [UIFont systemFontOfSize:12];
        statusLabel.text = @"状态跟踪";

        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 130, self.frame.size.width, 0.5)];
        line.image = [UIImage imageNamed:@"x-line"];
        [self.contentView addSubview:line];
        [self.contentView addSubview:infoLabel];
        [self.contentView addSubview:orderNumLabel];
        [self.contentView addSubview:_orderNum];
        [self.contentView addSubview:ordeTimeLabel];
        [self.contentView addSubview:_orderTime];
        [self.contentView addSubview:statusLabel];
    }
    return self;
}

-(void)addOrderStatus:(NSArray *)orderStatus
{
    if (orderStatus != nil && [orderStatus count] > 0)
    {
        for (int i = 0; i < [orderStatus count]; i++)
        {
            //状态
            UILabel *status = [[UILabel alloc] initWithFrame:CGRectMake(110, 85 + i * 20, 80, 20)];
            status.textColor = [UIColor grayColor];
            status.font = [UIFont systemFontOfSize:12];
            status.text = [[orderStatus objectAtIndex:i] objectForKey:@"status_text"];
            [self.contentView addSubview:status];
            
            //状态变化的时间
            UILabel *statusTime = [[UILabel alloc] initWithFrame:CGRectMake(230, 85 + i * 20, 80, 20)];
            statusTime.textColor = [UIColor grayColor];
            statusTime.font = [UIFont systemFontOfSize:12];
            statusTime.text = [[orderStatus objectAtIndex:i] objectForKey:@"create_time"];
            statusTime.textAlignment = NSTextAlignmentRight;
            [self.contentView addSubview:statusTime];
        }
    }
}


@end
