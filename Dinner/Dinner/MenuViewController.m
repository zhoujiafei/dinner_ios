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
@synthesize emptyBgView             = _emptyBgView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"菜单";
        _menusData = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getCacheData];
    [self showMenus];
    [self showLoading];
    [self requestMenuData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

#pragma mark -
#pragma mark Show Menus Table

//获取菜单列表缓存数据
-(void)getCacheData
{
    NSArray *data = [[DataManage shareDataManage] getData:CACHE_NAME withNetworkApi:[NSString stringWithFormat:GET_MENUS_API,_shopId]];
    if (data)
    {
        [_menusData addObjectsFromArray:data];
    }
}

//显示菜单
-(void)showMenus
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
    tipLabel.text = @"亲！这家餐厅暂时还没有菜哦！@_@";
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
    
    //增加一个购物车
    _cartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cartBtn.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 80, 150, 40);
    _cartBtn.backgroundColor = APP_BASE_COLOR;
    [_cartBtn setTitle:@"美食框" forState:UIControlStateNormal];
    [_cartBtn addTarget:self action:@selector(lookCart:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cartBtn];
}

//请求数据
-(void)requestMenuData
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
        NSArray *menus = [data objectForKey:@"menus"];
        if ([menus count] <= 0)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ProgressHUD showError:@"没有数据"];
            });
        }
        
        //保存数据
        [[DataManage shareDataManage] insertData:CACHE_NAME withNetworkApi:[NSString stringWithFormat:GET_MENUS_API,_shopId] withObject:menus];
        [_menusData removeAllObjects];
        [_menusData addObjectsFromArray:menus];
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
    if ([_menusData count] <= 0)
    {
        _emptyBgView.hidden = NO;
    }
    else
    {
        _emptyBgView.hidden = YES;
    }
}

#pragma mark -
#pragma Go To Cart Method

//查看购物车
-(void)lookCart:(UIButton *)btn
{
    self.hidesBottomBarWhenPushed = YES;
    CartViewController *cart = [[CartViewController alloc] init];
    [self.navigationController pushViewController:cart animated:YES];
}

#pragma mark -
#pragma mark Add Food To Cart

//添加菜到美食框
-(void)addMenuToFoodCart:(UIButton *)btn
{
    //获取所选的菜的基本信息
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[_menusData objectAtIndex:btn.tag]];
    [dic setObject:@"1" forKey:@"food_num"];
    
    //获取购物车里面的数据
    NSMutableArray *foodCart = [NSMutableArray arrayWithArray:[[DataManage shareDataManage] getData:FOOD_CART withNetworkApi:@"cart"]];
    if ([foodCart count] > 0)
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
    
    //改变按钮颜色
    btn.backgroundColor = [UIColor colorWithRed:125.0/255.0 green:181.0/255.0 blue:0.0 alpha:1];
    //添加到购物车里面
    [foodCart addObject:dic];
    //再将添加之后的数据保存到购物车里面
    [[DataManage shareDataManage] insertData:FOOD_CART withNetworkApi:@"cart" withObject:foodCart];
    //保存数据之后发通知
    [self sendNotificationForCartChanged];
}

//添加到购物车的动画(参考系是self.view)
-(void)addCartAnimation:(UIButton *)btn
{
    //首先创建动画的图片
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cm_center_discount"]];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.frame = CGRectMake(0, 0, 20, 20);
    imageView.hidden = YES;
    CALayer *layer = [[CALayer alloc]init];
    layer.contents = imageView.layer.contents;
    layer.frame = imageView.frame;
    layer.opacity = 1;
    [self.view.layer addSublayer:layer];
    
    //获取起点位置
    CGPoint startPoint = [self.view convertPoint:btn.center fromView:btn.superview];
    //获取终点位置
    CGPoint endPoint = [self.view convertPoint:_cartBtn.center fromView:self.view];
    
    //创建贝塞尔曲线
    UIBezierPath *bezierPath=[UIBezierPath bezierPath];
    [bezierPath moveToPoint:startPoint];
    //贝塞尔曲线中间点
    float sx = startPoint.x;
    float sy = startPoint.y;
    float ex = endPoint.x;
    float ey = endPoint.y;
    float x  = sx+(ex-sx)/3;
    float y  = sy+(ey-sy) * 0.5-400;
    CGPoint centerPoint=CGPointMake(x,y);
    [bezierPath addQuadCurveToPoint:endPoint controlPoint:centerPoint];
    
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = bezierPath.CGPath;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = 0.5;
    animation.delegate = self;
    animation.autoreverses = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [animation setValue:btn forKey:@"button"];
    [animation setValue:layer forKeyPath:@"layer"];
    [animation setValue:imageView forKeyPath:@"animationView"];
    [layer addAnimation:animation forKey:@"buy"];
}

//动画结束
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    UIButton *btn = [anim valueForKey:@"button"];
    CALayer *layer = [anim valueForKey:@"layer"];
    if (layer)
    {
        [layer removeFromSuperlayer];
    }
    
    UIImageView *view = [anim valueForKey:@"animationView"];
    if (view)
    {
        [view removeFromSuperview];
    }
    [self addMenuToFoodCart:btn];
}

#pragma mark -
#pragma mark 判断某一道菜是否已经在购物车里面了

//判断某一道菜是否已经在购物车里面了
-(BOOL)isInFoodCart:(NSString *)menuId
{
    //获取购物车数据
    NSArray *cartData = [[DataManage shareDataManage] getData:FOOD_CART withNetworkApi:@"cart"];
    if ([cartData count] > 0)
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

#pragma mark -
#pragma mark UIAlertViewDelegate

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

#pragma mark -
#pragma mark UITableViewDataSource

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
    
    //判断当前这道菜是不是已经在美食框里面了，如果已经在就将背景色置
    if ([self isInFoodCart:[[_menusData objectAtIndex:rowNo] objectForKey:@"id"]])
    {
        cell.btn.backgroundColor = [UIColor colorWithRed:125.0/255.0 green:181.0/255.0 blue:0.0 alpha:1];
    }
    else
    {
        cell.btn.backgroundColor = APP_BASE_COLOR;
    }
    [cell.btn addTarget:self action:@selector(addCartAnimation:) forControlEvents:UIControlEventTouchUpInside];
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
    return 100.0f;
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
    [NSThread detachNewThreadSelector:@selector(requestMenuData) toTarget:self withObject:nil]; //异步加载数据，不影tableView动作
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
