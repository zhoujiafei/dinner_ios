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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"首页";
    [self showLoading];
    [self showAllShops];
}

//显示商家列表
-(void)showAllShops
{
    NSURL *url = [NSURL URLWithString:GET_SHOPS_API];
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
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
        _shopData = [allData objectForKey:@"shops"];
        _isOnTime = [[allData objectForKey:@"isOnTime"] boolValue];
        
        if ([_shopData count] > 0)
        {
            [self hideTip];
            //存储数据
            [[DataManage shareDataManage] insertData:CACHE_NAME withNetworkApi:GET_SHOPS_API withObject:allData];
            
            if(SYSTEM_VERSION >= 7.0)
            {
                self.automaticallyAdjustsScrollViewInsets = NO;
            }
            //创建tableView
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
            _tableView.delegate = self;
            _tableView.dataSource = self;
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
        else
        {
            [ProgressHUD show:@"没有数据"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ProgressHUD dismiss];
            });
        }
    }];
    [request setFailedBlock:^{
        [self hideTip];
        [ProgressHUD showError:@"网络错误"];
    }];
    [request startAsynchronous];
}

#pragma mark -UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_shopData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    NSInteger rowNo = indexPath.row;
    cell.layer.masksToBounds = YES;
    cell.textLabel.text = [[_shopData objectAtIndex:rowNo] objectForKey:@"name"];
    cell.imageView.contentMode = UIViewContentModeCenter;
    cell.imageView.image = [UIImage imageWithData:
                                [NSData dataWithContentsOfURL:
                                                [NSURL URLWithString:[[_shopData objectAtIndex:rowNo] objectForKey:@"logo"]]]];
    //调整图片大小
    CGSize itemSize = CGSizeMake(40, 40);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSString *statusText = _isOnTime?@"正在营业中":@"已经打烊";
    cell.detailTextLabel.text = statusText;
    return cell;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isOnTime)
    {
        self.hidesBottomBarWhenPushed = YES;
        MenuViewController *menuVC = [[MenuViewController alloc] init];
        menuVC.shopId = [[_shopData objectAtIndex:[indexPath row]] objectForKey:@"id"];
        [self.navigationController pushViewController:menuVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    else
    {
        [ProgressHUD showError:@"已经打烊啦！"];
    }
}


//刷新的两个方法
- (void)reloadTableViewDataSource
{
    [NSThread detachNewThreadSelector:@selector(updateNewsByPullTable) toTarget:self withObject:nil]; //异步加载数据，不影tableView动作
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
-(void)updateNewsByPullTable
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:GET_SHOPS_API]];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error)
    {
        NSData *data = [request responseData];
        NSDictionary *allData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        _shopData = [allData objectForKey:@"shops"];
        _isOnTime = [[allData objectForKey:@"isOnTime"] boolValue];
        
        if ([_shopData count] > 0)
        {
            //存储数据
            [[DataManage shareDataManage] insertData:CACHE_NAME withNetworkApi:GET_SHOPS_API withObject:allData];
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
