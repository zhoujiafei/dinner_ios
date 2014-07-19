//
//  PersonalTableViewCell.m
//  Dinner
//
//  Created by 刘 金兰 on 14-7-19.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "PersonalTableViewCell.h"

@implementation PersonalTableViewCell

@synthesize labelName = _labelName;
@synthesize detailInfo = _detailInfo;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _labelName = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 30)];
        _labelName.font = [UIFont systemFontOfSize:18];
        
        _detailInfo = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, self.frame.size.width - 100, 30)];
        _detailInfo.font = [UIFont systemFontOfSize:16];
        _detailInfo.textColor = [UIColor grayColor];

        [self.contentView addSubview:_labelName];
        [self.contentView addSubview:_detailInfo];
    }
    return self;
}

@end
