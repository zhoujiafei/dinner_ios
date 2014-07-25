//
//  FoodCartBtn.h
//  Dinner
//
//  Created by 刘 金兰 on 14-7-25.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "config.h"

@interface FoodCartBtn : UIButton

@property (nonatomic,strong) UILabel *foodNum;

-(void)setFoodCartNum:(NSInteger)num;

@end
