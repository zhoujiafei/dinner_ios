//
//  FoodCartBtn.m
//  Dinner
//
//  Created by 刘 金兰 on 14-7-25.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "FoodCartBtn.h"

@implementation FoodCartBtn

@synthesize foodNum = _foodNum;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        nameLabel.text = @"美食筐";
        nameLabel.textColor = [UIColor whiteColor];
        
        UIImageView *foodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(70, 10, 20, 20)];
        foodImageView.image = [UIImage imageNamed:@"cm_center_discount"];
        
        UILabel *xLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 20, 20)];
        xLabel.text = @"x";
        xLabel.font = [UIFont fontWithName:@"Avenir-HeavyOblique" size:16];
        xLabel.textColor = [UIColor whiteColor];
        
        _foodNum = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, 30, 20)];
        _foodNum.font = [UIFont fontWithName:@"Avenir-HeavyOblique" size:16];
        _foodNum.textColor = [UIColor whiteColor];
        
        
        self.backgroundColor = APP_BASE_COLOR;
        [self addSubview:nameLabel];
        [self addSubview:foodImageView];
        [self addSubview:xLabel];
        [self addSubview:_foodNum];
    }
    return self;
}

-(void)setFoodCartNum:(NSInteger)num
{
    NSString *numStr = [NSString stringWithFormat:@"%d",num];
    _foodNum.text = numStr;
}






@end
