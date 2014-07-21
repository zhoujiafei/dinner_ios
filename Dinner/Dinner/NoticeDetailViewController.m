//
//  NoticeDetailViewController.m
//  Dinner
//
//  Created by 周 加飞 on 14-7-21.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "NoticeDetailViewController.h"

@implementation NoticeDetailViewController

@synthesize notice = _notice;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"公告详情";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showNoticeDetail];
}

//显示详情
-(void)showNoticeDetail
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 74, self.view.frame.size.width - 40, 35)];
    title.font = [UIFont systemFontOfSize:20];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = [_notice objectForKey:@"title"];

    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(20, 119, self.view.frame.size.width - 40,300)];
    content.font = [UIFont systemFontOfSize:16];
    content.textColor = [UIColor grayColor];
    content.numberOfLines = 0;
    content.lineBreakMode = NSLineBreakByWordWrapping;
    content.text = [_notice objectForKey:@"content"];
    [content sizeToFit];
    
    [self.view addSubview:title];
    [self.view addSubview:content];
}

@end
