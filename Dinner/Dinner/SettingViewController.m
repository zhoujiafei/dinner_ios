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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showSetting];
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
            
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark Get Cache Size


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
#pragma mark Clear Caches

//获取本地缓存大小
- (void)loadCacheSize
{
//    int totalSize = 0;
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    BOOL isDirExist = [fileManager fileExistsAtPath:[PATH_OF_LIBRARY stringByAppendingPathComponent:@"Caches"]];
//    if(isDirExist) {
//        NSString *cachesFoldPath = [PATH_OF_LIBRARY stringByAppendingPathComponent:@"Caches"];
//        NSString *ASIHTTPFoldPath = [cachesFoldPath stringByAppendingPathComponent:@"ASIHTTPRequestCache"];
//        NSString *ImageCacheFoldPath = [cachesFoldPath stringByAppendingPathComponent:@"ImageCache"];
//        NSString *NewsPictureFoldPath = [cachesFoldPath stringByAppendingPathComponent:@"NewsPicture"];
//        NSString *WirlessDataFoldPath = [cachesFoldPath stringByAppendingPathComponent:@"wirlessData"];
//        
//        BOOL isSaveFoldExist = [fileManager fileExistsAtPath:ASIHTTPFoldPath];
//        if (isSaveFoldExist) {
//            totalSize = [self sizeOfFolder:ASIHTTPFoldPath];
//        }
//        BOOL isImageCacheFoldExist = [fileManager fileExistsAtPath:ImageCacheFoldPath];
//        if (isImageCacheFoldExist) {
//            totalSize = totalSize + [self sizeOfFolder:ImageCacheFoldPath];
//        }
//        BOOL isNewsPictureFoldExist = [fileManager fileExistsAtPath:NewsPictureFoldPath];
//        if (isNewsPictureFoldExist) {
//            totalSize = totalSize + [self sizeOfFolder:NewsPictureFoldPath];
//        }
//        BOOL isWirlessDataFoldExist = [fileManager fileExistsAtPath:WirlessDataFoldPath];
//        if (isWirlessDataFoldExist) {
//            totalSize = totalSize + [self sizeOfFolder:WirlessDataFoldPath];
//        }
//        NSArray *contents = [[NSFileManager defaultManager] subpathsAtPath:cachesFoldPath];
//        NSEnumerator *enumerator = [contents objectEnumerator];;
//        NSString *path;
//        while (path = [enumerator nextObject]) {
//            if ([[path pathExtension] isEqualToString:@"localstorage"])
//            {
//                NSError *error =nil;
//                NSDictionary *fattrib = [[NSFileManager defaultManager] attributesOfItemAtPath:[cachesFoldPath stringByAppendingPathComponent:path] error:&error];
//                
//                totalSize  = totalSize + (int)[fattrib fileSize];
//            }
//            
//        }
//        
//    }
//    else {
//        totalSize = [[SDImageCache sharedImageCache] getSize]+[self sizeOfFolder:PATH_OF_TEMP];
//    }
//    NSString *str = [self stringFromFileSize:totalSize];
//    sizeLabel.text = str;
//    CGSize size = [str sizeWithFont:sizeLabel.font constrainedToSize:CGSizeMake(150, 45)];
//    sizeLabel.frame = CGRectMake(274-size.width, 0, size.width, 45);
//    [activity stopAnimating];
//    [activity removeFromSuperview];
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

//计算文件夹的大小
- (int)sizeOfFolder:(NSString*)folderPath
{
    NSArray *contents;
    NSEnumerator *enumerator;
    NSString *path;
    contents = [[NSFileManager defaultManager] subpathsAtPath:folderPath];
    enumerator = [contents objectEnumerator];
    int fileSizeInt = 0;
    while (path = [enumerator nextObject]) {
        NSError *error =nil;
        NSDictionary *fattrib = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:path] error:&error];
        
        fileSizeInt +=[fattrib fileSize];
    }
    return fileSizeInt;
}

@end
