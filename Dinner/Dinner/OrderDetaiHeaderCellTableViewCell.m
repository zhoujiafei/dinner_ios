//
//  OrderDetaiHeaderCellTableViewCell.m
//  Dinner
//
//  Created by 周 加飞 on 14-7-25.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "OrderDetaiHeaderCellTableViewCell.h"

@implementation OrderDetaiHeaderCellTableViewCell

@synthesize indexPicView    = _indexPicView;
@synthesize shopName        = _shopName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *indexPicView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 35, 35)];
        indexPicView.image = [UIImage imageNamed:@"defaultShop.jpg"];
        indexPicView.layer.cornerRadius = 17.0;
        indexPicView.layer.masksToBounds = YES;
        indexPicView.backgroundColor = [UIColor redColor];
       
        _shopName = [[UILabel alloc] initWithFrame:CGRectMake(65, 18, 250, 20)];
        _shopName.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:16];
        _shopName.textColor = [UIColor grayColor];

        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 55, self.frame.size.width, 0.5)];
        line.image = [UIImage imageNamed:@"x-line"];
        [self.contentView addSubview:line];
        [self.contentView addSubview:indexPicView];
        [self.contentView addSubview:_shopName];
    }
    return self;
}

@end
