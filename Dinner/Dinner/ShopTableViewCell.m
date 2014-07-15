//
//  ShopTableViewCell.m
//  Dinner
//
//  Created by 刘 金兰 on 14-7-6.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "ShopTableViewCell.h"

@implementation ShopTableViewCell

@synthesize indexPicView    = _indexPicView;
@synthesize title           = _title;
@synthesize status          = _status;
@synthesize commentView     = _commentView;
@synthesize address         = _address;
@synthesize phone           = _phone;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //logo图
        _indexPicView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 140,100)];
        
        //店名
        _title = [[UILabel alloc] initWithFrame:CGRectMake(160, 10, 80, 30)];
        _title.font = [UIFont systemFontOfSize:16];
        
        _status = [[UILabel alloc] initWithFrame:CGRectMake(260, 10, 50, 30)];
        _status.font = [UIFont systemFontOfSize:14];
        _status.textColor = [UIColor grayColor];
        _status.textAlignment = NSTextAlignmentRight;
        
        UIImageView *addImageView = [[UIImageView alloc] initWithFrame:CGRectMake(160, 40, 20, 20)];
        addImageView.image = [UIImage imageNamed:@"Position"];
        
        _address = [[UILabel alloc] initWithFrame:CGRectMake(185, 40, 125, 20)];
        _address.font = [UIFont systemFontOfSize:14];
        _address.textColor = [UIColor grayColor];

        UIImageView *phoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(160, 66, 20, 20)];
        phoneImageView.image = [UIImage imageNamed:@"Phone"];
        
        _phone = [[UILabel alloc] initWithFrame:CGRectMake(185, 66, 125, 20)];
        _phone.font = [UIFont systemFontOfSize:14];
        _phone.textColor = [UIColor grayColor];

        _commentView = [[UIImageView alloc] initWithFrame:CGRectMake(155,88, 30, 30)];
        _commentView.image = [UIImage imageNamed:@"comment_active"];
        
        [self.contentView addSubview:_indexPicView];
        [self.contentView addSubview:_title];
        [self.contentView addSubview:_status];
        [self.contentView addSubview:addImageView];
        [self.contentView addSubview:_address];
        [self.contentView addSubview:phoneImageView];
        [self.contentView addSubview:_phone];
        [self.contentView addSubview:_commentView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
