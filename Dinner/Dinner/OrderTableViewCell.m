//
//  OrderTableViewCell.m
//  Dinner
//
//  Created by 周 加飞 on 14-7-17.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "OrderTableViewCell.h"

@implementation OrderTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //上边
        UIImageView *topRect = [[UIImageView alloc] initWithFrame:CGRectMake(10,0, self.frame.size.width - 20, 3)];
        topRect.image = [UIImage imageNamed:@"cell_top_rec"];
        
        //中间
        UIImageView *midRect = [[UIImageView alloc] initWithFrame:CGRectMake(10,6, self.frame.size.width - 20,65)];
        midRect.image = [UIImage imageNamed:@"cell_mid_rec"];
        
        //下边
        UIImageView *bottomRect = [[UIImageView alloc] initWithFrame:CGRectMake(10,0, self.frame.size.width - 20, 3)];
        bottomRect.image = [UIImage imageNamed:@"cell_buttom_rec"];
        
        [self.contentView addSubview:topRect];
        [self.contentView addSubview:midRect];
        [self.contentView addSubview:bottomRect];
        
        
    }
    return self;
}

@end
