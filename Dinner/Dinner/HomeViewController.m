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
    self.view.backgroundColor = [UIColor redColor];
    
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
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, 320, 400) style:UITableViewStylePlain];
            _tableView.delegate = self;
            _tableView.dataSource = self;
            [self.view addSubview:_tableView];
        }
        else
        {
            NSLog(@"没有数据");
        }
    }
    else
    {
        NSLog(@"网络不可用");
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    NSInteger rowNo = indexPath.row;
    cell.layer.cornerRadius = 12;
    cell.layer.masksToBounds = YES;
    cell.textLabel.text = [[_shopData objectAtIndex:rowNo] objectForKey:@"name"];
    return cell;
}

@end
