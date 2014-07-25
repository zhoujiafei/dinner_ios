//
//  OrderDetailFooterCell.h
//  Dinner
//
//  Created by 周 加飞 on 14-7-25.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "config.h"

@interface OrderDetailFooterCell : UITableViewCell

@property (nonatomic,strong) UILabel *orderNum;
@property (nonatomic,strong) UILabel *orderTime;

-(void)addOrderStatus:(NSArray *)orderStatus;

@end
