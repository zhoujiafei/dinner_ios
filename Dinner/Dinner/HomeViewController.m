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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"首页";
    
    //获取餐厅列表数据
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:GET_SHOPS_API]];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error)
    {
        NSData *data = [request responseData];
        NSDictionary *allData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        _shopData = [allData objectForKey:@"shops"];
        _isOnTime = (BOOL)[allData objectForKey:@"isOnTime"];
        
        if ([_shopData count] > 0)
        {
            //创建tableView
            _tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStylePlain];
            _tableView.delegate = self;
            _tableView.dataSource = self;
            [self.view addSubview:_tableView];
        }
        else
        {
            [ProgressHUD show:@"没有数据"];
        }
    }
    else
    {
        [ProgressHUD showError:@"网络不可用"];
    }
}

#pragma mark -UITableViewDataSource
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
    self.hidesBottomBarWhenPushed = YES;
    MenuViewController *menuVC = [[MenuViewController alloc] init];
    menuVC.shopId = [[_shopData objectAtIndex:[indexPath row]] objectForKey:@"id"];
    [self.navigationController pushViewController:menuVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

@end
