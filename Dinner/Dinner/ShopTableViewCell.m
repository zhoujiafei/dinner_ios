//
//  ShopTableViewCell.m
//  Dinner
//
//  Created by 刘 金兰 on 14-7-6.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "ShopTableViewCell.h"

@implementation ShopTableViewCell

@synthesize imgView = _imgView;
@synthesize title = _title;
@synthesize status = _status;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        _title = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 100, 20)];
        _status = [[UILabel alloc] initWithFrame:CGRectMake(80, 40, 100, 20)];
        
        [self.contentView addSubview:_imgView];
        [self.contentView addSubview:_title];
        [self.contentView addSubview:_status];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
