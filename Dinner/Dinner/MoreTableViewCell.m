//
//  MoreTableViewCell.m
//  Dinner
//
//  Created by 刘 金兰 on 14-7-19.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "MoreTableViewCell.h"

@implementation MoreTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

@end
