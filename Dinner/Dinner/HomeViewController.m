//
//  HomeViewController.m
//  Dinner
//
//  Created by 刘 金兰 on 14-7-5.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "HomeViewController.h"

@implementation HomeViewController

@synthesize tableView = _tableView;
@synthesize shopData = _shopData;
@synthesize isOnTime = _isOnTime;
@synthesize refreshTableHeaderView = _refreshTableHeaderView;
@synthesize reloading = _reloading;
@synthesize emptyBgView = _emptyBgView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"首页";
        _shopData = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getCacheData];
    [self showAllShops];
    [self showLoading];
    [self requestShopListData];
}

#pragma mark -
#pragma mark Show Table

//获取餐厅列表缓存数据
-(void)getCacheData
{
    NSArray *data = [[DataManage shareDataManage] getData:CACHE_NAME withNetworkApi:GET_SHOPS_API];
    if (data)
    {
        [_shopData addObjectsFromArray:data];
    }
}

//显示商家列表
-(void)showAllShops
{
    if(SYSTEM_VERSION >= 7.0)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //创建tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsZero;//设置cell的分割线不偏移
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    /****************************没有菜时候的背景***************************/
    //提示图片
    _emptyBgView = [[UIView alloc] initWithFrame:self.view.frame];
    UIImageView *noDataIcon = [[UIImageView alloc] initWithFrame:CGRectMake(133, 128, 54, 54)];
    noDataIcon.image = [UIImage imageNamed:@"nearby_error_deal"];
    //提示文字
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 190, 180, 45)];
    tipLabel.font = [UIFont systemFontOfSize:16];
    tipLabel.textColor = [UIColor grayColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.numberOfLines = 0;
    tipLabel.lineBreakMode = NSLineBreakByWordWrapping;
    tipLabel.text = @"亲！暂时还没有餐厅可供选择哦！@_@";
    [_emptyBgView addSubview:noDataIcon];
    [_emptyBgView addSubview:tipLabel];
    _emptyBgView.hidden = YES;
    [_tableView addSubview:_emptyBgView];
    /****************************没有菜时候的背景***************************/
    [self changeBgColor];
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

//请求餐厅列表数据
-(void)requestShopListData
{
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:GET_SHOPS_API]];
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
        
        NSData *data = [request responseData];
        NSDictionary *allData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray *requestShopData = [allData objectForKey:@"shops"];
        _isOnTime = [[allData objectForKey:@"isOnTime"] boolValue];
        if ([requestShopData count] <= 0)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ProgressHUD showError:@"没有数据"];
            });
        }
        
        //保存数据
        [[DataManage shareDataManage] insertData:CACHE_NAME withNetworkApi:GET_SHOPS_API withObject:requestShopData];
        [_shopData removeAllObjects];
        [_shopData addObjectsFromArray:requestShopData];
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
    if ([_shopData count] <= 0)
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
    return [_shopData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    ShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        cell = [[ShopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    NSInteger rowNo = indexPath.row;
    cell.title.text = [[_shopData objectAtIndex:rowNo] objectForKey:@"name"];
    [cell.indexPicView setImageWithURL:[NSURL URLWithString:[[_shopData objectAtIndex:rowNo] objectForKey:@"logo"]]
                       placeholderImage:[UIImage imageNamed:@"defaultShop.jpg"]];
    NSString *statusText = _isOnTime?@"营业中":@"已打烊";
    cell.status.text = statusText;
    cell.address.text = [[_shopData objectAtIndex:rowNo] objectForKey:@"address"];
    cell.phone.text = [[_shopData objectAtIndex:rowNo] objectForKey:@"tel"];

    NSString *flatImage = @"";
    if (_isOnTime)
    {
        flatImage = @"deal_flag_free";
    }
    else
    {
        flatImage = @"deal_flag_end";
    }
    cell.flatFree.image = [UIImage imageNamed:flatImage];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.hidesBottomBarWhenPushed = YES;
    MenuViewController *menuVC = [[MenuViewController alloc] init];
    menuVC.shopId = [[_shopData objectAtIndex:[indexPath row]] objectForKey:@"id"];
    [self.navigationController pushViewController:menuVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 65.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark -
#pragma mark Refresh Methods

//刷新的两个方法
- (void)reloadTableViewDataSource
{
    [NSThread detachNewThreadSelector:@selector(requestShopListData) toTarget:self withObject:nil]; //异步加载数据，不影tableView动作
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
