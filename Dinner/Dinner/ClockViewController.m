//
//  ClockViewController.m
//  Dinner
//
//  Created by 刘 金兰 on 14-7-20.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "ClockViewController.h"

@implementation ClockViewController

@synthesize picker = _picker;
@synthesize hour = _hour;
@synthesize minute = _minute;
@synthesize saveBtn = _saveBtn;
@synthesize selectedTime = _selectedTime;
@synthesize isOpenRemind = _isOpenRemind;
@synthesize hourRow = _hourRow;
@synthesize minRow = _minRow;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"订餐提醒";
        _hour = [NSMutableArray array];
        _minute = [NSMutableArray array];
        [self getRemindSetting];
        [self initDataSource];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showClock];
}

//获取提醒的设置
-(void)getRemindSetting
{
    _isOpenRemind   = [[[NSUserDefaults standardUserDefaults] objectForKey:@"is_open_remind"] boolValue];
    _hourRow        = [[[NSUserDefaults standardUserDefaults] objectForKey:@"hour_row"] intValue];
    _minRow         = [[[NSUserDefaults standardUserDefaults] objectForKey:@"min_row"] intValue];
}

//初始化数据源
-(void)initDataSource
{
    //构建小时的数据源
    for (int i = 0; i < 24; i++)
    {
        NSString *hou = @"";
        if (i < 10)
        {
            hou = [NSString stringWithFormat:@"0%d",i];
        }
        else
        {
            hou = [NSString stringWithFormat:@"%d",i];
        }
        [_hour addObject:hou];
    }
    
    //构建分钟的数据源
    for (int i = 0; i < 60; i++)
    {
        NSString *min = @"";
        if (i < 10)
        {
            min = [NSString stringWithFormat:@"0%d",i];
        }
        else
        {
            min = [NSString stringWithFormat:@"%d",i];
        }
        [_minute addObject:min];
    }
}

//显示提醒界面
-(void)showClock
{
    //提示label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 84, 120, 30)];
    titleLabel.text = @"是否打开提醒";
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont systemFontOfSize:19];

    //增加一个开关
    UISwitch *clockSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(250, 84.0, 0.0, 0.0)];
    clockSwitch.on = _isOpenRemind?YES:NO;
    clockSwitch.onTintColor = APP_BASE_COLOR;
    [clockSwitch addTarget:self action:@selector(openClock:) forControlEvents:UIControlEventValueChanged];
    
    //提示label
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 130, 120, 30)];
    timeLabel.text = @"设定的时间";
    timeLabel.textColor = [UIColor grayColor];
    timeLabel.font = [UIFont systemFontOfSize:19];
    
    //选好的时间
    _selectedTime = [[UILabel alloc] initWithFrame:CGRectMake(180, 130, 120, 30)];
    _selectedTime.textColor = [UIColor grayColor];
    _selectedTime.font = [UIFont systemFontOfSize:19];
    _selectedTime.textAlignment = NSTextAlignmentRight;
    _selectedTime.text = [NSString stringWithFormat:@"%@ : %@",[_hour objectAtIndex:_hourRow],[_minute objectAtIndex:_minRow]];
    
    //时间选择器
    _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(20, 160, self.view.frame.size.width - 40, 100)];
    _picker.delegate = self;
    _picker.dataSource = self;
    _picker.hidden = _isOpenRemind?NO:YES;
    [_picker selectRow:_hourRow inComponent:1 animated:YES];
    [_picker selectRow:_minRow inComponent:2 animated:YES];
    
    //保存按钮
    _saveBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _saveBtn.frame = CGRectMake(20, 320, 280, 45);
    _saveBtn.backgroundColor = APP_BASE_COLOR;
    _saveBtn.layer.cornerRadius = 5.0f;
    [_saveBtn setTitle:@"设定" forState:UIControlStateNormal];
    [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _saveBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [_saveBtn addTarget:self action:@selector(saveTime) forControlEvents:UIControlEventTouchUpInside];
    _saveBtn.hidden = _isOpenRemind?NO:YES;

    [self.view addSubview:titleLabel];
    [self.view addSubview:clockSwitch];
    [self.view addSubview:timeLabel];
    [self.view addSubview:_selectedTime];
    [self.view addSubview:_picker];
    [self.view addSubview:_saveBtn];
}

-(void)openClock:(UISwitch *)clock
{
    //如果打开就显示设置时间的选择器
    if (clock.on)
    {
        _picker.hidden = NO;
        _saveBtn.hidden = NO;
    }
    else
    {
        _picker.hidden = YES;
        _saveBtn.hidden = YES;
        [[UIApplication sharedApplication] cancelAllLocalNotifications];//取消通知
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[[NSNumber alloc] initWithBool:clock.on] forKey:@"is_open_remind"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _isOpenRemind = clock.on;
}

//保存时间
-(void)saveTime
{
    _hourRow    = [_picker selectedRowInComponent:1];
    _minRow     = [_picker selectedRowInComponent:2];
    _selectedTime.text = [NSString stringWithFormat:@"%@ : %@",[_hour objectAtIndex:_hourRow],[_minute objectAtIndex:_minRow]];
    [[NSUserDefaults standardUserDefaults] setObject:[[NSNumber alloc] initWithInt:_hourRow] forKey:@"hour_row"];
    [[NSUserDefaults standardUserDefaults] setObject:[[NSNumber alloc] initWithInt:_minRow] forKey:@"min_row"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //设置本地提醒通知
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    //触发通知的时间
    NSDate *now = [formatter dateFromString:[NSString stringWithFormat:@"%@:%@:00",[_hour objectAtIndex:_hourRow],[_minute objectAtIndex:_minRow]]];
    notification.fireDate = now;
    //时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    //通知重复提示的单位，可以是天、周、月
    notification.repeatInterval = NSDayCalendarUnit;
    //通知内容
    notification.alertBody = @"阿吃啦喊你吃饭啦！";
    notification.alertAction = @"阿吃啦喊你吃饭啦！";
    //通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    //执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ProgressHUD showSuccess:@"设定成功"];
        [self.navigationController popViewControllerAnimated:YES];
    });
}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return 1;
    }
    else if(component == 1)
    {
        return [_hour count];
    }
    else
    {
        return [_minute count];
    }
}

#pragma mark -
#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        return @"提醒时间";
    }
    else if(component == 1)
    {
        return [_hour objectAtIndex:row];
    }
    else
    {
        return [_minute objectAtIndex:row];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0)
    {
        return 120;
    }
    else
    {
        return 60;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}


@end
