//
//  MenuViewController.m
//  Dinner
//
//  Created by 刘 金兰 on 14-7-5.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "MenuViewController.h"

@implementation MenuViewController

@synthesize shopId                  = _shopId;
@synthesize tableView               = _tableView;
@synthesize refreshTableHeaderView  = _refreshTableHeaderView;
@synthesize reloading               = _reloading;
@synthesize menusData               = _menusData;
@synthesize cartBtn                 = _cartBtn;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"菜单";
    [self showLoading];
    [self showMenus];
}

//显示菜单
-(void)showMenus
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:GET_MENUS_API,_shopId]];
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
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
        
        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:nil];
        _menusData = [data objectForKey:@"menus"];
        if ([_menusData count] > 0)
        {
            //存储数据
            [[DataManage shareDataManage] insertData:CACHE_NAME withNetworkApi:[NSString stringWithFormat:GET_MENUS_API,_shopId] withObject:_menusData];
            
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
            _cartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _cartBtn.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 80, 150, 40);
            _cartBtn.backgroundColor = APP_BASE_COLOR;
            [_cartBtn setTitle:@"美食框" forState:UIControlStateNormal];
            [_cartBtn addTarget:self action:@selector(lookCart:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_cartBtn];
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

//查看购物车
-(void)lookCart:(UIButton *)btn
{
    self.hidesBottomBarWhenPushed = YES;
    CartViewController *cart = [[CartViewController alloc] init];
    [self.navigationController pushViewController:cart animated:YES];
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
    [cell.menuImageView setImageWithURL:[NSURL URLWithString:[[_menusData objectAtIndex:rowNo] objectForKey:@"index_pic"]]
                   placeholderImage:[UIImage imageNamed:@"defaultFood.jpg"]];
    cell.menuDetail.text = [[_menusData objectAtIndex:rowNo] objectForKey:@"brief"];
    cell.menuPrice.text = [[[_menusData objectAtIndex:rowNo] objectForKey:@"price"] stringByAppendingString:@"元/份"];
    cell.btn.tag = rowNo;
    [cell.btn addTarget:self action:@selector(addMenuToFoodCart:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

//添加菜到美食框
-(void)addMenuToFoodCart:(UIButton *)btn
{
    btn.backgroundColor = [UIColor colorWithRed:125.0/255.0 green:181.0/255.0 blue:0.0 alpha:1];
    
    //获取所选的菜的基本信息
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[_menusData objectAtIndex:btn.tag]];
    [dic setObject:@"1" forKey:@"food_num"];
    
    //获取购物车里面的数据
    NSMutableArray *foodCart = [[DataManage shareDataManage] getData:FOOD_CART withNetworkApi:@"cart"];
    if (![foodCart isEqual:nil] && [foodCart count] > 0)
    {
        //首先判断购物车里面的菜所属的商家与当前的商家是不是同一家
        if (![_shopId isEqualToString:[[foodCart objectAtIndex:0] objectForKey:@"shop_id"]])
        {
            NSString *msg = [NSString stringWithFormat:@"当前美食框里面的菜来自:《%@》，请清空美食框之后再选菜",[[foodCart objectAtIndex:0] objectForKey:@"shop_name"]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"清空", nil];
            [alert show];
            return;
        }
        
        //判断添加的这道菜是不是已经存在于购物车
        if ([self isInFoodCart:[dic objectForKey:@"id"]])
        {
            [ProgressHUD showSuccess:@"这道菜已经存在美食框"];
            return;
        }
    }
    else
    {
        foodCart = [NSMutableArray array];
    }
    
    //添加到购物车里面
    [foodCart addObject:dic];
    //再将添加之后的数据保存到购物车里面
    [[DataManage shareDataManage] insertData:FOOD_CART withNetworkApi:@"cart" withObject:foodCart];
    
    //保存数据之后发通知
    [self sendNotificationForCartChanged];
}

//判断某一道菜是否已经在购物车里面了
-(BOOL)isInFoodCart:(NSString *)menuId
{
    //获取购物车数据
    NSArray *cartData = [[DataManage shareDataManage] getData:FOOD_CART withNetworkApi:@"cart"];
    if (![cartData isEqual:nil] && [cartData count] > 0)
    {
        for (int i = 0; i < [cartData count]; i++)
        {
            if([[[cartData objectAtIndex:i] objectForKey:@"id"] isEqualToString:menuId])
            {
                return YES;
            }
        }
    }
    return NO;
}


#pragma mark -UIAlertViewDelegate
//主要是用于清空美食框
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //如果用户点击确认，则清空美食框
    if (buttonIndex == 1)
    {
        [[DataManage shareDataManage] deleteData:FOOD_CART withNetworkApi:@"cart"];
        [self sendNotificationForCartChanged];
        [ProgressHUD showSuccess:@"美食框已清空"];
    }
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
