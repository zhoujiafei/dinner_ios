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

    //获取美食数据
    _cartData = [[DataManage shareDataManage] getData:FOOD_CART withNetworkApi:@"cart"];
    if (![_cartData isEqual:nil] && [_cartData count] > 0)
    {
        self.title = [NSString stringWithFormat:@"%@",[[_cartData objectAtIndex:0] objectForKey:@"shop_name"]];
        //创建tableView
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsZero;//设置cell的分割线不偏移
        [self.view addSubview:_tableView];
    }
    else
    {
        self.title = @"美食框";
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
    cell.menuNum.text = [[_cartData objectAtIndex:rowNo] objectForKey:@"food_num"];
    cell.menuNum.tag = rowNo + kMenuNumTag;
    cell.leftBtn.tag = rowNo;
    cell.rightBtn.tag = rowNo;
    [cell.leftBtn addTarget:self action:@selector(addMenuNums:) forControlEvents:UIControlEventTouchUpInside];
    [cell.rightBtn addTarget:self action:@selector(subMenuNums:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

//增加某一菜的个数
-(void)addMenuNums:(UIButton *)btn
{
    UILabel *menuNum = (UILabel *)[[btn superview] viewWithTag:btn.tag + 1000];
    NSInteger newNum = [menuNum.text intValue] + 1;
    if (newNum > 100)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您定数量超过限额" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    //将更改的个数更新到数据库里面
    NSMutableDictionary *curData = [NSMutableDictionary dictionaryWithDictionary:[_cartData objectAtIndex:btn.tag]];
    [curData setObject:[NSString stringWithFormat:@"%d",newNum] forKey:@"food_num"];
    [_cartData replaceObjectAtIndex:btn.tag withObject:curData];
    [[DataManage shareDataManage] insertData:FOOD_CART withNetworkApi:@"cart" withObject:_cartData];
    menuNum.text = [NSString stringWithFormat:@"%d",newNum];
}

//减少某一菜的个数
-(void)subMenuNums:(UIButton *)btn
{
    UILabel *menuNum = (UILabel *)[[btn superview] viewWithTag:btn.tag + 1000];
    NSInteger newNum = [menuNum.text intValue] - 1;
    if (newNum <= 0)
    {
        //从美食框里面移除这道菜
        [_cartData removeObjectAtIndex:btn.tag];
        //保存数据库
        [[DataManage shareDataManage] insertData:FOOD_CART withNetworkApi:@"cart" withObject:_cartData];
        [self.tableView reloadData];
        //发通知更新 _cartNav.tabBarItem.badgeValue 的值
        [self sendNotificationForCartChanged];
        return;
    }
    
    NSMutableDictionary *curData = [NSMutableDictionary dictionaryWithDictionary:[_cartData objectAtIndex:btn.tag]];
    [curData setObject:[NSString stringWithFormat:@"%d",newNum] forKey:@"food_num"];
    [_cartData replaceObjectAtIndex:btn.tag withObject:curData];
    [[DataManage shareDataManage] insertData:FOOD_CART withNetworkApi:@"cart" withObject:_cartData];
    menuNum.text = [NSString stringWithFormat:@"%d",newNum];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 10.0f;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 100.0f;
//}

@end
