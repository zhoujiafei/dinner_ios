//
//  CartViewController.m
//  Dinner
//
//  Created by 刘 金兰 on 14-7-8.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "CartViewController.h"

@implementation CartViewController

@synthesize tableView   = _tableView;
@synthesize cartData    = _cartData;
@synthesize totalPrice  = _totalPrice;
@synthesize emptyBgView = _emptyBgView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"美食筐";
        _cartData = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getCartData];
    [self showCart];
}

#pragma mark -
#pragma mark 目的是让每次进入美食筐都刷新数据

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_cartData removeAllObjects];
    [self getCartData];
    [self changeBgColor];
    [_tableView reloadData];
}

#pragma mark -
#pragma mark Show Cart Table

//获取美食数据
-(void)getCartData
{
    NSArray *data = [[DataManage shareDataManage] getData:FOOD_CART withNetworkApi:@"cart"];
    if (data)
    {
        [_cartData addObjectsFromArray:data];
    }
}

//显示美食筐列表
-(void)showCart
{
    UIBarButtonItem *clearCartItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_delete"] style:UIBarButtonItemStylePlain target:self action:@selector(clearFoodCart)];
    self.navigationItem.rightBarButtonItem = clearCartItem;
    
    //创建tableView
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsZero;//设置cell的分割线不偏移
    
    //没有菜时候的背景
    //提示图片
    _emptyBgView = [[UIView alloc] initWithFrame:self.view.frame];
    UIImageView *noDataIcon = [[UIImageView alloc] initWithFrame:CGRectMake(133, 64, 54, 54)];
    noDataIcon.image = [UIImage imageNamed:@"nearby_error_order"];
    
    //提示文字
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 126, 180, 45)];
    tipLabel.font = [UIFont systemFontOfSize:16];
    tipLabel.textColor = [UIColor grayColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.numberOfLines = 0;
    tipLabel.lineBreakMode = NSLineBreakByWordWrapping;
    tipLabel.text = @"亲！您还没有添加菜到美食筐哦！@_@";
    
    [_emptyBgView addSubview:noDataIcon];
    [_emptyBgView addSubview:tipLabel];
    _emptyBgView.hidden = YES;
    [_tableView addSubview:_emptyBgView];
    [self.view addSubview:_tableView];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_cartData count] > 0)
    {
        return [_cartData count] + 1;
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowNo = indexPath.row;
    if(rowNo < [_cartData count])
    {
        static NSString *cellId = @"cellId";
        FoodCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (cell == nil)
        {
            cell = [[FoodCartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }

        cell.menuName.text = [[_cartData objectAtIndex:rowNo] objectForKey:@"name"];
        [cell.menuImageView setImageWithURL:[NSURL URLWithString:[[_cartData objectAtIndex:rowNo] objectForKey:@"index_pic"]]
                           placeholderImage:[UIImage imageNamed:@"defaultFood.jpg"]];
        cell.menuPrice.text = [[[_cartData objectAtIndex:rowNo] objectForKey:@"price"] stringByAppendingString:@"元/份"];
        cell.menuNum.text = [[_cartData objectAtIndex:rowNo] objectForKey:@"food_num"];
        cell.shopName.text = [[_cartData objectAtIndex:rowNo] objectForKey:@"shop_name"];
        cell.menuNum.tag = rowNo + kMenuNumTag;
        cell.leftBtn.tag = rowNo;
        cell.rightBtn.tag = rowNo;
        [cell.leftBtn addTarget:self action:@selector(addMenuNums:) forControlEvents:UIControlEventTouchUpInside];
        [cell.rightBtn addTarget:self action:@selector(subMenuNums:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellFooter"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *footer=[[UIView alloc] initWithFrame:CGRectMake(0,0,320.0,100.0f)];
        UILabel *totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 20, 45, 30)];
        totalPriceLabel.text = @"总价：";
        totalPriceLabel.textColor = [UIColor grayColor];
        totalPriceLabel.font = [UIFont systemFontOfSize:14];
        
        _totalPrice = [[UILabel alloc] initWithFrame:CGRectMake(250, 20, 60, 30)];
        _totalPrice.text = [self getCalculateTotalPrice];
        _totalPrice.textAlignment = NSTextAlignmentRight;
        _totalPrice.textColor = APP_BASE_COLOR;
        _totalPrice.font = [UIFont systemFontOfSize:14];
        
        UIButton *orderConfirm = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        orderConfirm.frame = CGRectMake(10, 60, 300, 45);
        orderConfirm.backgroundColor = APP_BASE_COLOR;
        orderConfirm.layer.cornerRadius = 5.0f;
        [orderConfirm setTitle:@"确认下单" forState:UIControlStateNormal];
        [orderConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        orderConfirm.titleLabel.font = [UIFont systemFontOfSize:20];
        [orderConfirm addTarget:self action:@selector(confirmOrder) forControlEvents:UIControlEventTouchUpInside];
        
        [footer addSubview:totalPriceLabel];
        [footer addSubview:_totalPrice];
        [footer addSubview:orderConfirm];
        [cell.contentView addSubview:footer];
        return cell;
    }
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [_cartData count])
    {
        return 80.0f;
    }
    else
    {
        return 120.0f;
    }
}

#pragma mark -
#pragma mark Some Opration Method

//增加某一菜的个数
-(void)addMenuNums:(UIButton *)btn
{
    UILabel *menuNum = (UILabel *)[[btn superview] viewWithTag:btn.tag + 1000];
    NSInteger newNum = [menuNum.text intValue] + 1;
    if (newNum > 100)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您定的数量超过限额" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    //将更改的个数更新到数据库里面
    NSMutableDictionary *curData = [NSMutableDictionary dictionaryWithDictionary:[_cartData objectAtIndex:btn.tag]];
    [curData setObject:[NSString stringWithFormat:@"%d",newNum] forKey:@"food_num"];
    [_cartData replaceObjectAtIndex:btn.tag withObject:curData];
    [[DataManage shareDataManage] insertData:FOOD_CART withNetworkApi:@"cart" withObject:_cartData];
    menuNum.text = [NSString stringWithFormat:@"%d",newNum];
    [self changeBgColor];//改背景色
    [_tableView reloadData];
}

//减少某一菜的个数
-(void)subMenuNums:(UIButton *)btn
{
    UILabel *menuNum = (UILabel *)[[btn superview] viewWithTag:btn.tag + 1000];
    NSInteger newNum = [menuNum.text intValue] - 1;
    if (newNum <= 0)
    {
        //从美食筐里面移除这道菜
        [_cartData removeObjectAtIndex:btn.tag];
        //保存数据库
        [[DataManage shareDataManage] insertData:FOOD_CART withNetworkApi:@"cart" withObject:_cartData];
        [self changeBgColor];
        [_tableView reloadData];
        //发通知更新 _cartNav.tabBarItem.badgeValue 的值
        [self sendNotificationForCartChanged];
        return;
    }
    
    NSMutableDictionary *curData = [NSMutableDictionary dictionaryWithDictionary:[_cartData objectAtIndex:btn.tag]];
    [curData setObject:[NSString stringWithFormat:@"%d",newNum] forKey:@"food_num"];
    [_cartData replaceObjectAtIndex:btn.tag withObject:curData];
    [[DataManage shareDataManage] insertData:FOOD_CART withNetworkApi:@"cart" withObject:_cartData];
    menuNum.text = [NSString stringWithFormat:@"%d",newNum];
    [self changeBgColor];//改背景色
    [_tableView reloadData];
}

//确认下单
-(void)confirmOrder
{
    //获取access_token
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    if (!accessToken)
    {
        [self goToLogin];
        return;
    }
    
    //获取美食筐里面的数据构造提交订单的json数据
    if ([_cartData count] <= 0)
    {
        [ProgressHUD showError:@"您还未选择美食，不能下单！"];
    }
    
    NSMutableArray *order = [NSMutableArray array];
    //开始构造数据
    for (int i = 0; i < [_cartData count]; i++)
    {
        NSDictionary *curData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [[_cartData objectAtIndex:i] objectForKey:@"id"],@"id",
                                 [[_cartData objectAtIndex:i] objectForKey:@"food_num"],@"nums",nil];
        [order addObject:curData];
    }

    [ProgressHUD show:@"正在提交订单..."];
    NSData *data = [NSJSONSerialization dataWithJSONObject:order options:0 error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request_ = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:ORDER_API]];
    __weak ASIFormDataRequest *request = request_;
    [request addPostValue:json forKey:@"menu_info"];
    [request addPostValue:accessToken forKey:@"access_token"];
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
        if ([returnData objectForKey:@"errorCode"])
        {
            //未登录，则调出登陆界面
            if ([[returnData objectForKey:@"errorCode"] isEqualToNumber:[NSNumber numberWithInt:40002]])
            {
                [ProgressHUD dismiss];
                [self goToLogin];
                return;
            }
            
            [ProgressHUD showError:[returnData objectForKey:@"errorText"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ProgressHUD dismiss];
            });
            return;
        }
        else
        {
            [ProgressHUD showSuccess:@"下单成功"];
            //清空美食筐
            [_cartData removeAllObjects];
            [[DataManage shareDataManage] deleteData:FOOD_CART withNetworkApi:@"cart"];
            [self sendNotificationForCartChanged];
            [self changeBgColor];//改背景色
            [_tableView reloadData];
        }
    }];
    [request setFailedBlock:^{
        [ProgressHUD showError:@"网络错误"];
    }];
    [request startAsynchronous];
}

//获取计算的购物车里面的总价
-(NSString *)getCalculateTotalPrice
{
    CGFloat total = 0.0f;
    for (int i = 0; i < [_cartData count]; i++)
    {
        NSInteger num = [[[_cartData objectAtIndex:i] objectForKey:@"food_num"] intValue];
        CGFloat curPrice = [[[_cartData objectAtIndex:i] objectForKey:@"price"] floatValue];
        total += curPrice * num;
    }
    return [NSString stringWithFormat:@"￥%.1f",total];
}

//跳转到登陆界面
-(void)goToLogin
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
}

//清空美食筐
-(void)clearFoodCart
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要清空美食筐吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

//确认要清空美食筐
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //确认
    if (buttonIndex == 1)
    {
        [_cartData removeAllObjects];
        [[DataManage shareDataManage] deleteData:FOOD_CART withNetworkApi:@"cart"];
        [self sendNotificationForCartChanged];
        [self changeBgColor];
        [self.tableView reloadData];
        [ProgressHUD showSuccess:@"美食筐已清空"];
    }
}

//处理tableView背景颜色
-(void)changeBgColor
{
    if ([_cartData count] <= 0)
    {
        _emptyBgView.hidden = NO;
    }
    else
    {
        _emptyBgView.hidden = YES;
    }
}

@end
