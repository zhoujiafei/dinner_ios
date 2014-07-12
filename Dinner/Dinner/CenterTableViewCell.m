//
//  CenterTableViewCell.m
//  Dinner
//
//  Created by 周 加飞 on 14-7-11.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "CenterTableViewCell.h"

@implementation CenterTableViewCell

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
