//
//  OrderDetailViewController.m
//  Dinner
//
//  Created by 刘 金兰 on 14-7-20.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "OrderDetailViewController.h"

@implementation OrderDetailViewController

@synthesize orderInfo = _orderInfo;
@synthesize tableView = _tableView;
@synthesize cancelBtn = _cancelBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"订单详情";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showOrderDetail];
}

//显示订单详情
-(void)showOrderDetail
{
    if(SYSTEM_VERSION >= 7.0)
    {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    
    //创建tableView
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsZero;//设置cell的分割线不偏移
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    //底部增加状态显示
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 65, self.view.bounds.size.width, 65)];
    footerView.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:0.8];
    
    if (_orderInfo)
    {
        if ([[_orderInfo objectForKey:@"status"] intValue] == 1)
        {
            _cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            _cancelBtn.frame = CGRectMake(10, 10, 300, 45);
            _cancelBtn.backgroundColor = APP_BASE_COLOR;
            _cancelBtn.layer.cornerRadius = 5.0f;
            [_cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:20];
            [_cancelBtn addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
            [footerView addSubview:_cancelBtn];
        }
        else
        {
            CGRect imageRect;
            CGRect statusRect;
            
            //已付款
            if ([[_orderInfo objectForKey:@"status"] intValue] == 2)
            {
                imageRect = CGRectMake(120, 20, 25, 25);
                statusRect = CGRectMake(155, 20, 150, 25);
            }
            else
            {
                imageRect = CGRectMake(80, 20, 25, 25);
                statusRect = CGRectMake(115, 20, 150, 25);
            }
            
            UIImageView *successView = [[UIImageView alloc] initWithFrame:imageRect];
            successView.image = [UIImage imageNamed:@"success_ok"];
            UILabel *statusText = [[UILabel alloc] initWithFrame:statusRect];
            statusText.text = [_orderInfo objectForKey:@"status_text"];
            statusText.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
            [footerView addSubview:successView];
            [footerView addSubview:statusText];
        }
    }
    
    [self.view addSubview:footerView];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowNo = indexPath.row;
    if (rowNo == 0)
    {
        //第一行显示店名与店招
        OrderDetaiHeaderCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (cell == nil)
        {
            cell = [[OrderDetaiHeaderCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
    
        cell.shopName.text = [_orderInfo objectForKey:@"shop_name"];
        return cell;
    }
    else if(rowNo == 1)
    {
        OrderDetailPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (cell == nil)
        {
            cell = [[OrderDetailPriceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        }
        
        cell.priceNum.text = [NSString stringWithFormat:@"-%@",[_orderInfo objectForKey:@"total_price"]];
        return cell;
    }
    else if(rowNo == 2)
    {
        OrderDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        if (cell == nil)
        {
            cell = [[OrderDetailInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
        }
        [cell addProductInfo:[_orderInfo objectForKey:@"product_info"]];
        [cell changeFooterLine:[[_orderInfo objectForKey:@"product_info"] count]];
        return cell;
    }
    else
    {
        OrderDetailFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
        if (cell == nil)
        {
            cell = [[OrderDetailFooterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell4"];
        }
        
        cell.orderNum.text = [_orderInfo objectForKey:@"order_number"];
        cell.orderTime.text = [NSString stringWithFormat:@"%@ %@",[_orderInfo objectForKey:@"create_order_date"],[_orderInfo objectForKey:@"create_time_text"]];
        
        [cell addOrderStatus:[_orderInfo objectForKey:@"status_log"]];
        return cell;
    }
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 55.5f;
    }
    else if(indexPath.row == 1)
    {
        return 100.5f;
    }
    else if(indexPath.row == 2)
    {
        NSInteger menuNum = [[_orderInfo objectForKey:@"product_info"] count];
        return 50.5f + 20 * menuNum;
    }
    else
    {
        return 130.5f;
    }
}

//取消订单
-(void)cancelOrder
{
    //获取access_token
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    
    [ProgressHUD show:@"正在取消..."];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:CANCEL_ORDER_API]];
    [request addPostValue:accessToken forKey:@"access_token"];
    [request addPostValue:[_orderInfo objectForKey:@"id"] forKey:@"id"];
    [request setCompletionBlock:^{
        if ([request responseStatusCode] != 200)
        {
            return;
        }
        
        if (isNilNull([request responseData]))
        {
            return;
        }
        
        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:nil];
        if (data && [data objectForKey:@"errorCode"])
        {
            [ProgressHUD showError:[data objectForKey:@"errorText"]];
            return;
        }
        else
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ProgressHUD showSuccess:@"取消成功"];
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
    [request setFailedBlock:^{
        [ProgressHUD showError:@"网络连接错误"];
    }];
    [request startAsynchronous];
}

@end
