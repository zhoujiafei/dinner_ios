//
//  OrderDetailPriceCell.m
//  Dinner
//
//  Created by 周 加飞 on 14-7-25.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "OrderDetailPriceCell.h"

@implementation OrderDetailPriceCell

@synthesize priceNum = _priceNum;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        priceLabel.textColor = APP_BASE_COLOR;
        priceLabel.font = [UIFont systemFontOfSize:16];
        priceLabel.text = @"消费金额";
        
        _priceNum = [[UILabel alloc] initWithFrame:CGRectMake(190, 40, 120, 50)];
        _priceNum.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:40];
        _priceNum.textAlignment = NSTextAlignmentRight;
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, self.frame.size.width, 0.5)];
        line.image = [UIImage imageNamed:@"x-line"];
        [self.contentView addSubview:line];
        [self.contentView addSubview:priceLabel];
        [self.contentView addSubview:_priceNum];
    }
    return self;
}

@end
