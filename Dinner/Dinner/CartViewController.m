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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"美食框";

    //获取美食数据
    _cartData = [[DataManage shareDataManage] getData:FOOD_CART withNetworkApi:@"cart"];
    if (![_cartData isEqual:nil] && [_cartData count] > 0)
    {
        //创建tableView
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsZero;//设置cell的分割线不偏移
        [self.view addSubview:_tableView];
    }
    else
    {
        [ProgressHUD showSuccess:@"您还未添加美食"];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_cartData count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    FoodCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        cell = [[FoodCartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    NSInteger rowNo = indexPath.row;
    cell.menuName.text = [[_cartData objectAtIndex:rowNo] objectForKey:@"name"];
    [cell.menuImageView setImageWithURL:[NSURL URLWithString:[[_cartData objectAtIndex:rowNo] objectForKey:@"index_pic"]]
                       placeholderImage:[UIImage imageNamed:@"food"]];
    cell.menuPrice.text = [[[_cartData objectAtIndex:rowNo] objectForKey:@"price"] stringByAppendingString:@"元/份"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}


@end
