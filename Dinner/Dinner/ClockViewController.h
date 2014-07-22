//
//  ClockViewController.h
//  Dinner
//
//  Created by 刘 金兰 on 14-7-20.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "config.h"

@interface ClockViewController : BaseViewController <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) UIPickerView *picker;
@property (nonatomic,strong) NSMutableArray *hour;
@property (nonatomic,strong) NSMutableArray *minute;
@property (nonatomic,strong) UIButton *saveBtn;
@property (nonatomic,strong) UILabel *selectedTime;
@property (nonatomic,assign) BOOL isOpenRemind;
@property (nonatomic,assign) NSInteger hourRow;//保存小时所在的行
@property (nonatomic,assign) NSInteger minRow;//保存分钟所在的行

@end
