//
//  MoreViewController.m
//  Dinner
//
//  Created by 周 加飞 on 14-7-16.
//  Copyright (c) 2014年 周加飞. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@property (nonatomic,strong) NSArray *labelArr;
@property (nonatomic,strong) NSArray *labelIcon;
@property (nonatomic,assign) BOOL isOpenRemind;

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"设置";
        self.labelArr = [NSArray arrayWithObjects:@[@"订餐提醒",@"清除缓存"], nil];
        self.labelIcon = [NSArray arrayWithObjects:@[@"remind_expired",@"remind_clean"], nil];
        self.isOpenRemind   = [[[NSUserDefaults standardUserDefaults] objectForKey:@"is_open_remind"] boolValue];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showSetting];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isOpenRemind   = [[[NSUserDefaults standardUserDefaults] objectForKey:@"is_open_remind"] boolValue];
    [_tableView reloadData];
}

#pragma mark -
#pragma mark Show Personal Interface

//显示个人信息的界面
-(void)showSetting
{
    if(SYSTEM_VERSION >= 7.0)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsZero;//设置cell的分割线不偏移
    [self.view addSubview:_tableView];
}

#pragma mark -
#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.labelArr objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    MoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        cell = [[MoreTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    NSInteger rowNo = indexPath.row;
    cell.textLabel.text = [[self.labelArr objectAtIndex:indexPath.section] objectAtIndex:rowNo];
    cell.imageView.image = [UIImage imageNamed:[[self.labelIcon objectAtIndex:indexPath.section] objectAtIndex:rowNo]];
    
    if (rowNo == 0)
    {
        if (self.isOpenRemind)
        {
            cell.detailTextLabel.text = @"已开启";
            cell.detailTextLabel.textColor = APP_BASE_COLOR;
        }
        else
        {
            cell.detailTextLabel.text = @"已关闭";
            cell.detailTextLabel.textColor = [UIColor grayColor];
        }
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
    }
    else
    {
        cell.detailTextLabel.text = [self getCurrentCacheSize];
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.labelArr count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            [self goToTargetInterface:[[ClockViewController alloc] init]];
            break;
        case 1:
            [self confirmClearCache];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark Go To Interface

//跳到指定的界面
-(void)goToTargetInterface:(BaseViewController *)viewController
{
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark -
#pragma mark Clear All Caches

//弹出提示是否确认清除缓存
-(void)confirmClearCache
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"要清除所有缓存吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

//执行清除操作
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [ProgressHUD show:@"正在清理..."];
        //清除SDImageCache
        [[SDImageCache sharedImageCache] clearMemory];
        [[SDImageCache sharedImageCache] clearDisk];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDirExist = [fileManager fileExistsAtPath:[PATH_OF_LIBRARY stringByAppendingPathComponent:@"Caches"]];
        if(isDirExist)
        {
            NSString *cachesFoldPath = [PATH_OF_LIBRARY stringByAppendingPathComponent:@"Caches"];
            NSArray *contents = [fileManager contentsOfDirectoryAtPath:cachesFoldPath error:NULL];
            NSEnumerator *e = [contents objectEnumerator];
            NSString *filename;
            while ((filename = [e nextObject]))
            {
                [fileManager removeItemAtPath:[cachesFoldPath stringByAppendingPathComponent:filename] error:NULL];
            }
        }
        [ProgressHUD showSuccess:@"清理完成"];
        [_tableView reloadData];
    }
}

#pragma mark -
#pragma mark Get Cache Size

//获取单签app的缓存大小
-(NSString *)getCurrentCacheSize
{
    int totalSize = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirExist = [fileManager fileExistsAtPath:[PATH_OF_LIBRARY stringByAppendingPathComponent:@"Caches"]];
    if(isDirExist)
    {
        NSString *cachesFoldPath = [PATH_OF_LIBRARY stringByAppendingPathComponent:@"Caches"];
        totalSize = [self sizeOfFolder:cachesFoldPath];
    }
    //加上SDImageCache的缓存客tmp目录
    totalSize += [[SDImageCache sharedImageCache] getSize]+[self sizeOfFolder:PATH_OF_TEMP];
    //加上数据库的大小
//    totalSize += [self sizeOfFile:[PATH_OF_DOCUMENT stringByAppendingPathComponent:@"dinner.db"]];
    NSString *sizeStr = [self stringFromFileSize:totalSize];
    return sizeStr;
}

//计算文件夹的大小递归子目录
- (int)sizeOfFolder:(NSString*)folderPath
{
    NSArray *contents;
    NSEnumerator *enumerator;
    NSString *path;
    contents = [[NSFileManager defaultManager] subpathsAtPath:folderPath];
    enumerator = [contents objectEnumerator];
    int fileSizeInt = 0;
    while (path = [enumerator nextObject])
    {
        NSError *error =nil;
        NSDictionary *fattrib = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:path] error:&error];
        fileSizeInt +=[fattrib fileSize];
    }
    return fileSizeInt;
}

//获取某个文件的大小
- (long long)sizeOfFile:(NSString*) filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath])
    {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//单位转换
- (NSString *)stringFromFileSize:(int)theSize
{
    float floatSize = theSize;
    if (theSize<1023)
        return @"0.0 K";
    floatSize = floatSize / 1024;
    if (floatSize<1023)
        return([NSString stringWithFormat:@"%1.1f K",floatSize]);
    floatSize = floatSize / 1024;
    if (floatSize<1023)
        return([NSString stringWithFormat:@"%1.1f M",floatSize]);
    floatSize = floatSize / 1024;
    
    return([NSString stringWithFormat:@"%1.1f G",floatSize]);
}

@end
