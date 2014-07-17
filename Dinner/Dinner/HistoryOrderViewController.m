//
//  HistoryOrderViewController.m
//  Dinner
//
//  Created by 周 加飞 on 14-7-15.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "HistoryOrderViewController.h"

@implementation HistoryOrderViewController

@synthesize orderData = _orderData;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"历史订单";
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [_orderData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        cell = [[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
//    NSInteger rowNo = indexPath.row;
    return cell;
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
//- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
//{
//    [self reloadTableViewDataSource];
//    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.5];
//}
//
//- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
//{
//    return [NSDate date];
//}
//
//
//#pragma mark -
//#pragma mark UIScrollViewDelegate Methods
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [_refreshTableHeaderView egoRefreshScrollViewDidScroll:scrollView];
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    [_refreshTableHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
//}
//
//- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
//{
//    return _reloading;
//}

@end
