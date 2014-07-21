//
//  NoticeViewController.m
//  Dinner
//
//  Created by 周加飞 on 14-7-5.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "NoticeViewController.h"

@implementation NoticeViewController

@synthesize tableView               = _tableView;
@synthesize refreshTableHeaderView  = _refreshTableHeaderView;
@synthesize reloading               = _reloading;
@synthesize noticeData              = _noticeData;
@synthesize emptyBgView             = _emptyBgView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"公告";
        _noticeData = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getCacheData];
    [self showNotice];
    [self showLoading];
    [self requestNoticeData];
}

#pragma mark -
#pragma mark Show Notice Table

//获取公告列表缓存数据
-(void)getCacheData
{
    NSArray *data = [[DataManage shareDataManage] getData:CACHE_NAME withNetworkApi:GET_NOTICE_API];
    if (data)
    {
        [_noticeData addObjectsFromArray:data];
    }
}

//显示公告界面
-(void)showNotice
{
    if(SYSTEM_VERSION >= 7.0)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //创建tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorInset = UIEdgeInsetsZero;//设置cell的分割线不偏移
    
    /****************************没有菜时候的背景***************************/
    //提示图片
    _emptyBgView = [[UIView alloc] initWithFrame:self.view.frame];
    UIImageView *noDataIcon = [[UIImageView alloc] initWithFrame:CGRectMake(133, 128, 54, 54)];
    noDataIcon.image = [UIImage imageNamed:@"nearby_error_order"];
    //提示文字
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 190, 180, 45)];
    tipLabel.font = [UIFont systemFontOfSize:16];
    tipLabel.textColor = [UIColor grayColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.numberOfLines = 0;
    tipLabel.lineBreakMode = NSLineBreakByWordWrapping;
    tipLabel.text = @"亲！暂时还没有公告哦！@_@";
    [_emptyBgView addSubview:noDataIcon];
    [_emptyBgView addSubview:tipLabel];
    _emptyBgView.hidden = YES;
    [_tableView addSubview:_emptyBgView];
    /****************************没有菜时候的背景***************************/
    
    [self.view addSubview:_tableView];
    //刷新控件
    if (_refreshTableHeaderView == nil)
    {
        _refreshTableHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 64.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
        _refreshTableHeaderView.delegate = self;
        [_tableView addSubview:_refreshTableHeaderView];
    }
    //最后一次更新的时间
    [_refreshTableHeaderView refreshLastUpdatedDate];
}

//请求数据
-(void)requestNoticeData
{
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:GET_NOTICE_API]];
    [request setCompletionBlock:^{
        [self hideTip];
        if ([request responseStatusCode] != 200)
        {
            return;
        }
        
        if (isNilNull([request responseData]))
        {
            return;
        }
        
        NSArray *returnData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:nil];
        if ([returnData count] <= 0)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ProgressHUD showError:@"没有数据"];
            });
        }
        
        //保存数据
        [[DataManage shareDataManage] insertData:CACHE_NAME withNetworkApi:GET_NOTICE_API withObject:returnData];
        [_noticeData removeAllObjects];
        [_noticeData addObjectsFromArray:returnData];
        [self changeBgColor];
        [_tableView reloadData];
        
    }];
    [request setFailedBlock:^{
        [ProgressHUD showError:@"网络连接错误"];
    }];
    [request startAsynchronous];
}

//处理tableView背景颜色
-(void)changeBgColor
{
    if ([_noticeData count] <= 0)
    {
        _emptyBgView.hidden = NO;
    }
    else
    {
        _emptyBgView.hidden = YES;
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_noticeData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    NoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        cell = [[NoticeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    NSInteger rowNo = indexPath.row;
    cell.textLabel.text = [[_noticeData objectAtIndex:rowNo] objectForKey:@"title"];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 65.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

//查看公告详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *detailInfo = [_noticeData objectAtIndex:indexPath.row];
    self.hidesBottomBarWhenPushed = YES;
    NoticeDetailViewController *detailVC = [[NoticeDetailViewController alloc] init];
    detailVC.notice = detailInfo;
    [self.navigationController pushViewController:detailVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark -
#pragma mark Refresh Methods

//刷新的两个方法
- (void)reloadTableViewDataSource
{
    [NSThread detachNewThreadSelector:@selector(requestNoticeData) toTarget:self withObject:nil]; //异步加载数据，不影tableView动作
    _reloading = YES;
}
//数据加载完成
- (void)doneLoadingTableViewData
{
    _reloading = NO;
    [_refreshTableHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    [self changeBgColor];
    [_tableView reloadData];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.5];
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [NSDate date];
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshTableHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshTableHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return _reloading;
}

@end
