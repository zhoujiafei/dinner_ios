//
//  FeedbackViewController.m
//  Dinner
//
//  Created by 刘 金兰 on 14-7-20.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "FeedbackViewController.h"

@implementation FeedbackViewController

@synthesize feedbackView = _feedbackView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"反馈意见";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showFeedback];
}

//显示意见反馈界面
-(void)showFeedback
{
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 65, self.view.frame.size.width - 20, 45)];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.text = @"亲！很高兴您写意见给我们哦~~";
    
    //意见反馈
    _feedbackView = [[UITextView alloc] initWithFrame:CGRectMake(10, 110, self.view.frame.size.width - 20, 100)];
    _feedbackView.font = [UIFont systemFontOfSize:16];
    _feedbackView.textColor = [UIColor grayColor];
    
    
    //发送按钮
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sendBtn.frame = CGRectMake(10, 220, self.view.frame.size.width - 20, 45);
    sendBtn.backgroundColor = APP_BASE_COLOR;
    sendBtn.layer.cornerRadius = 5.0f;
    [sendBtn setTitle:@"发送意见" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [sendBtn addTarget:self action:@selector(sendMsg) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:titleLabel];
    [self.view addSubview:_feedbackView];
    [self.view addSubview:sendBtn];
}

//发送意见
-(void)sendMsg
{
    NSLog(@"sendmsg");
}

#pragma mark -
#pragma mark 隐藏键盘

//隐藏键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_feedbackView resignFirstResponder];
}

@end
