//
//  NoticeTableViewCell.m
//  Dinner
//
//  Created by 周 加飞 on 14-7-21.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "NoticeTableViewCell.h"

@implementation NoticeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 45-0.5, self.frame.size.width, 0.5)];
        line.image = [UIImage imageNamed:@"x-line"];
        [self.contentView addSubview:line];
    }
    return self;
}

@end
