//
//  HistoryOrderViewController.m
//  Dinner
//
//  Created by 周 加飞 on 14-7-15.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "HistoryOrderViewController.h"

@implementation HistoryOrderViewController

@synthesize orderData               = _orderData;
@synthesize refreshTableHeaderView  = _refreshTableHeaderView;
@synthesize accessToken             = _accessToken;
@synthesize emptyBgView             = _emptyBgView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"我的订单";
        _orderData = [NSMutableArray array];
        [self getAccessToken];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getCacheData];
    [self showOrderList];
    [self showLoading];
    [self requestOrderData];
}

-(void)getAccessToken
{
    _accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    if (!_accessToken)
    {
        [self goToLogin];
        return;
    }
}

#pragma mark -
#pragma mark Show Order List Table

//获取订单的缓存数据
-(void)getCacheData
{
    NSArray *data = [[DataManage shareDataManage] getData:CACHE_NAME withNetworkApi:[NSString stringWithFormat:GET_HISTORY_ORDER_API,_accessToken]];
    if (data)
    {
        [_orderData addObjectsFromArray:data];
    }
}

//显示订单列表
-(void)showOrderList
{
    if(SYSTEM_VERSION >= 7.0)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //创建tableView
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsZero;//设置cell的分割线不偏移
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    tipLabel.text = @"亲！您还没有下过单哦！@_@";
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

//请求订单数据
-(void)requestOrderData
{
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:GET_HISTORY_ORDER_API,_accessToken]]];
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
        id returnData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        //出错了
        if ([returnData isKindOfClass:[NSDictionary class]] && [returnData objectForKey:@"errorCode"])
        {
            //未登录，则调出登陆界面
            if ([[returnData objectForKey:@"errorCode"] isEqualToNumber:[NSNumber numberWithInt:40002]])
            {
                [ProgressHUD dismiss];
                [self goToLogin];
                return;
            }

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ProgressHUD showError:[returnData objectForKey:@"errorText"]];
            });
            return;
        }
        
        //数据为空
        if ([returnData isKindOfClass:[NSArray class]] && [returnData count] <= 0)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ProgressHUD showError:@"没有数据"];
            });
        }
        
        //保存数据
        [[DataManage shareDataManage] insertData:CACHE_NAME withNetworkApi:[NSString stringWithFormat:GET_HISTORY_ORDER_API,_accessToken] withObject:returnData];
        [_orderData removeAllObjects];
        [_orderData addObjectsFromArray:returnData];
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
    if ([_orderData count] <= 0)
    {
        _emptyBgView.hidden = NO;
    }
    else
    {
        _emptyBgView.hidden = YES;
    }
}

#pragma mark -
#pragma mark UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [[[_orderData objectAtIndex:section] objectForKey:@"data"] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_orderData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        cell = [[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    NSInteger rowNo = indexPath.row;
    NSInteger sectionNo = indexPath.section;
    NSArray *allOrderData = [[_orderData objectAtIndex:sectionNo] objectForKey:@"data"];
    
    cell.shopName.text      = [[allOrderData objectAtIndex:rowNo] objectForKey:@"shop_name"];
    cell.menuName.text      = [[[[allOrderData objectAtIndex:rowNo] objectForKey:@"product_info"] objectAtIndex:0] objectForKey:@"Name"];
    
    if ([[[allOrderData objectAtIndex:rowNo] objectForKey:@"is_today"] boolValue])
    {
        cell.orderDate.text     = @"今天";
        cell.orderDate.textColor = APP_BASE_COLOR;
    }
    else
    {
        cell.orderDate.text     = [[allOrderData objectAtIndex:rowNo] objectForKey:@"create_order_date"];
    }
    cell.orderStatus.text   = [[allOrderData objectAtIndex:rowNo] objectForKey:@"status_text"];
    cell.totalPrice.text    = [[allOrderData objectAtIndex:rowNo] objectForKey:@"total_price"];
    NSInteger status        = [[[allOrderData objectAtIndex:rowNo] objectForKey:@"status"] intValue];

    UIColor *color = nil;
    switch (status)
    {
        case 1://待付款
            color = APP_BASE_COLOR;
            break;
        case 2://已付款
            color = [UIColor colorWithRed:125.0/255.0 green:181.0/255.0 blue:0.0 alpha:1];
            break;
        case 3://用户取消订单
            color = [UIColor purpleColor];
            break;
        case 4://妹子取消订单
            color = [UIColor brownColor];
            break;
        default:
            color = APP_BASE_COLOR;
            break;
    }
    cell.orderStatus.textColor = color;
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 110.0f;
    }
    else
    {
        return 30.0f;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.bounds.size.width, 100)];
    UILabel *date = nil;
    if (section == 0)
    {
        date = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 150, 20)];
    }
    else
    {
        date = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 20)];
    }

    date.textColor = [UIColor grayColor];
    date.font = [UIFont systemFontOfSize:16];
    date.text = [NSString stringWithFormat:@"%@",[[_orderData objectAtIndex:section] objectForKey:@"date"]];
    
    UILabel *priceLabel = nil;
    if (section == 0)
    {
        priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 80, 150, 20)];
    }
    else
    {
        priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 150, 20)];
    }
    
    priceLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.text = [NSString stringWithFormat:@"已消费：￥%@",[[_orderData objectAtIndex:section] objectForKey:@"total_price"]];
    priceLabel.font = [UIFont systemFontOfSize:16];
    priceLabel.textColor = APP_BASE_COLOR;
    [view addSubview:date];
    [view addSubview:priceLabel];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowNo = indexPath.row;
    NSInteger sectionNo = indexPath.section;
    NSDictionary *order = [[[_orderData objectAtIndex:sectionNo] objectForKey:@"data"] objectAtIndex:rowNo];
    self.hidesBottomBarWhenPushed = YES;
    OrderDetailViewController *orderDetail = [[OrderDetailViewController alloc] init];
    orderDetail.orderInfo = order;
    [self.navigationController pushViewController:orderDetail animated:YES];
    self.hidesBottomBarWhenPushed = NO;
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

#pragma mark -
#pragma mark Refresh Methods

//刷新的两个方法
- (void)reloadTableViewDataSource
{
    [NSThread detachNewThreadSelector:@selector(requestOrderData) toTarget:self withObject:nil]; //异步加载数据，不影tableView动作
    _reloading = YES;
}
//数据加载完成
- (void)doneLoadingTableViewData
{
    _reloading = NO;
    [_refreshTableHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    [_tableView reloadData];
}

#pragma mark -
#pragma mark Go To Login

//跳转到登陆界面
-(void)goToLogin
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
