//
//  OrderDetailInfoCell.h
//  Dinner
//
//  Created by 周 加飞 on 14-7-25.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "config.h"

@interface OrderDetailInfoCell : UITableViewCell

@property (nonatomic,strong) UILabel *productLabel;

//渲染商品列表
-(void)addProductInfo:(NSArray *)productInfo;
-(void)changeFooterLine:(NSInteger)menuNum;

@end
