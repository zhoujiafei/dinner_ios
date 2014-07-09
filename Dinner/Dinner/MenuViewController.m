//
//  MenuViewController.m
//  Dinner
//
//  Created by 刘 金兰 on 14-7-5.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "MenuViewController.h"

@implementation MenuViewController

@synthesize shopId = _shopId;
@synthesize tableView = _tableView;
@synthesize refreshTableHeaderView = _refreshTableHeaderView;
@synthesize reloading = _reloading;
@synthesize menusData = _menusData;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"菜单";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:GET_MENUS_API,_shopId]]];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error)
    {
        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:nil];
        _menusData = [data objectForKey:@"menus"];
        if ([_menusData count] > 0)
        {
            //存储数据
            [[DataManage shareDataManage] insertData:CACHE_NAME withNetworkApi:[NSString stringWithFormat:GET_MENUS_API,_shopId] withObject:_menusData];
            
            //创建tableView
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
            _tableView.delegate = self;
            _tableView.dataSource = self;
            _tableView.separatorInset = UIEdgeInsetsZero;//设置cell的分割线不偏移
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
            
            //增加一个购物车
            UIButton *cartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            cartBtn.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 80, 150, 40);
            cartBtn.backgroundColor = [UIColor colorWithRed:50.0/255.0 green:151.0/255.0 blue:228.0/255.0 alpha:1];
            [cartBtn setTitle:@"菜篮子" forState:UIControlStateNormal];
            [self.view addSubview:cartBtn];
            
        }
        else
        {
            [ProgressHUD show:@"没有数据"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ProgressHUD dismiss];
            });
        }
    }
    else
    {
        [ProgressHUD showError:@"网络不可用"];
    }
}

#pragma mark -UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_menusData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    NSInteger rowNo = indexPath.row;
    cell.menuName.text = [[_menusData objectAtIndex:rowNo] objectForKey:@"name"];
    cell.menuImageView.image = [UIImage imageWithData:
                            [NSData dataWithContentsOfURL:
                             [NSURL URLWithString:[[_menusData objectAtIndex:rowNo] objectForKey:@"index_pic"]]]];
    cell.menuDetail.text = [[_menusData objectAtIndex:rowNo] objectForKey:@"brief"];
    cell.menuPrice.text = [[[_menusData objectAtIndex:rowNo] objectForKey:@"price"] stringByAppendingString:@"元/份"];
    return cell;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //添加到购物车
    
    
}


//刷新的两个方法
- (void)reloadTableViewDataSource
{
    [NSThread detachNewThreadSelector:@selector(updateDataByPullTable) toTarget:self withObject:nil]; //异步加载数据，不影tableView动作
    _reloading = YES;
}
//数据加载完成
- (void)doneLoadingTableViewData
{
    _reloading = NO;
    [_refreshTableHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    [_tableView reloadData];
}

//更新数据
-(void)updateDataByPullTable
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:GET_MENUS_API,_shopId]]];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error)
    {
        NSData *data = [request responseData];
        NSDictionary *allData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        _menusData = [allData objectForKey:@"menus"];
        
        if ([_menusData count] > 0)
        {
            //存储数据
            [[DataManage shareDataManage] insertData:CACHE_NAME withNetworkApi:[NSString stringWithFormat:GET_MENUS_API,_shopId] withObject:allData];
            [self.tableView reloadData];
        }
        else
        {
            [ProgressHUD show:@"没有数据"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ProgressHUD dismiss];
            });
        }
    }
    else
    {
        [ProgressHUD showError:@"网络错误"];
    }
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
