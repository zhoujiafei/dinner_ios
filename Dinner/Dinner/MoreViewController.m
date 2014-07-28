//
//  MoreViewController.m
//  Dinner
//
//  Created by 周 加飞 on 14-7-16.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "MoreViewController.h"

@interface MoreViewController ()

@property (nonatomic,strong) NSArray *labelArr;
@property (nonatomic,strong) NSArray *labelIcon;

@end

@implementation MoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"更多";
        self.labelArr = [NSArray arrayWithObjects:@[@"公告",@"扫描"],@[@"设置",@"关于我们",@"反馈意见",@"版本更新"], nil];
        self.labelIcon = [NSArray arrayWithObjects:@[@"more_shake",@"more_scan"],@[@"more_setting",@"more_about",@"more_feedback",@"seller_navi"], nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showMore];
}

#pragma mark -
#pragma mark Show Personal Interface

//显示个人信息的界面
-(void)showMore
{
    if(SYSTEM_VERSION >= 7.0)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsZero;//设置cell的分割线不偏移
    [self.view addSubview:_tableView];
}

#pragma mark -
#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.labelArr objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    MoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        cell = [[MoreTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    NSInteger rowNo = indexPath.row;
    cell.textLabel.text = [[self.labelArr objectAtIndex:indexPath.section] objectAtIndex:rowNo];
    cell.imageView.image = [UIImage imageNamed:[[self.labelIcon objectAtIndex:indexPath.section] objectAtIndex:rowNo]];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 100;
    }
    else
    {
        return 20;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.labelArr count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
                [self goToTargetInterface:[[NoticeViewController alloc] init]];
                break;
            case 1:
                [self goToTargetInterface:[[ScanViewController alloc] init]];
                break;
            default:
                break;
        }
    }
    else
    {
        switch (indexPath.row)
        {
            case 0:
                [self goToTargetInterface:[[SettingViewController alloc] init]];
                break;
            case 1:
                [self goToTargetInterface:[[AboutUsViewController alloc] init]];
                break;
            case 2:
                [self goToTargetInterface:[[FeedbackViewController alloc] init]];
                break;
            case 3:
                [self checkNewVersion];
                break;
                
            default:
                break;
        }
    }
}

#pragma mark -
#pragma mark Go To Interface

//跳到指定的界面
-(void)goToTargetInterface:(BaseViewController *)viewController
{
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark -
#pragma mark Check New Version

-(void)checkNewVersion
{
    [ProgressHUD show:@"正在检测..."];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:CHECK_VERSION_API]];
    [request setCompletionBlock:^{
        if ([request responseStatusCode] != 200)
        {
            return;
        }
        
        if (isNilNull([request responseData]))
        {
            return;
        }
        
        NSDictionary *returnData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:nil];
        if (returnData)
        {
            if ([[returnData objectForKey:@"app_version"] isEqualToString:APP_VERSION])
            {
                [ProgressHUD showSuccess:@"检测到有新版本"];
            }
        }
        
        [ProgressHUD showSuccess:@"当前已是最新版本"];
    }];
    [request setFailedBlock:^{
        [ProgressHUD showError:@"网络连接错误"];
    }];
    [request startAsynchronous];
}

@end
