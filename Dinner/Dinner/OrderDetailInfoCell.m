//
//  OrderDetailInfoCell.m
//  Dinner
//
//  Created by 周 加飞 on 14-7-25.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "OrderDetailInfoCell.h"

@implementation OrderDetailInfoCell

@synthesize productLabel    = _productLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        infoLabel.textColor = APP_BASE_COLOR;
        infoLabel.font = [UIFont systemFontOfSize:16];
        infoLabel.text = @"商品信息";
        [self.contentView addSubview:infoLabel];
    }
    return self;
}

//动态添加商品信息
-(void)addProductInfo:(NSArray *)productInfo
{
    if (productInfo != nil && [productInfo count] > 0)
    {
        for (int i = 0; i < [productInfo count]; i++)
        {
            //商品名称
            UILabel *productName = [[UILabel alloc] initWithFrame:CGRectMake(10, 35 + i * 20, 100, 20)];
            productName.textColor = [UIColor grayColor];
            productName.font = [UIFont systemFontOfSize:12];
            productName.text = [[productInfo objectAtIndex:i] objectForKey:@"Name"];
            [self.contentView addSubview:productName];
            
            //商品数量
            UILabel *productNum = [[UILabel alloc] initWithFrame:CGRectMake(130, 35 + i * 20, 80, 20)];
            productNum.textColor = [UIColor grayColor];
            productNum.font = [UIFont systemFontOfSize:12];
            productNum.text = [NSString stringWithFormat:@"%@ x %@份",[[productInfo objectAtIndex:i] objectForKey:@"Price"],[[productInfo objectAtIndex:i] objectForKey:@"Count"]];
            [self.contentView addSubview:productNum];
            
            //商品小计
            UILabel *smallTotal = [[UILabel alloc] initWithFrame:CGRectMake(230, 35 + i * 20, 80, 20)];
            smallTotal.textColor = [UIColor grayColor];
            smallTotal.font = [UIFont systemFontOfSize:12];
            smallTotal.text = [NSString stringWithFormat:@"￥ %.1f",[[[productInfo objectAtIndex:i] objectForKey:@"smallTotal"] floatValue]];
            smallTotal.textAlignment = NSTextAlignmentRight;
            [self.contentView addSubview:smallTotal];
        }
    }
}

//动态改变底部的line
-(void)changeFooterLine:(NSInteger)menuNum
{
    CGFloat height = 50.0f + 20 * menuNum;
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, height - 0.5, self.frame.size.width, 0.5)];
    line.image = [UIImage imageNamed:@"x-line"];
    [self.contentView addSubview:line];
}

@end
