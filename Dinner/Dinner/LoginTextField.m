//
//  LoginTextField.m
//  Dinner
//
//  Created by 周 加飞 on 14-7-18.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "LoginTextField.h"

@implementation LoginTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

//控制 placeHolder 的位置，左右缩 20
- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds , 30 , 0 );
}

// 控制文本的位置，左右缩 20
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds , 30 , 0 );
}

-(CGRect) leftViewRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 10;// 右偏10
    return iconRect;
}

@end
