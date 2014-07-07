//
//  DataBase.m
//  AppPlant
//
//  Created by 陆浩 on 14-2-19.
//  Copyright (c) 2014年 hogesoft. All rights reserved.
//

#import "DataBase.h"


static FMDatabase *dbPointer = nil;

@implementation DataBase


+ (FMDatabase *)shareDataBase {
    if (dbPointer == nil) {
        dbPointer = [DataBase openDB];
    }
    return dbPointer;
}

+ (FMDatabase *)openDB {
    NSString *dbPath = [self setUpDB];
    FMDatabase *db = [[FMDatabase alloc] initWithPath:dbPath];
    [db open];
    return db;
}

+ (void)closeDB:(FMDatabase *)db {
    [db close];
}

+ (NSString *)setUpDB {
    //为了简化创建数据库文件的过程，直接在工程中放入一个空的数据库，第一次运行的时候直接复制。
	NSString *realPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"dinner.db"];
	NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"dinner" ofType:@"db"];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
    @synchronized([self class]) {
        if ([fileManager fileExistsAtPath:realPath]) {
            NSDictionary *dstAttri = [fileManager attributesOfItemAtPath:realPath error:nil];
            NSDictionary *srcAttri = [fileManager attributesOfItemAtPath:sourcePath error:nil];
            NSDate *dstDate = [dstAttri objectForKey:@"NSFileCreationDate"];
            NSDate *srcDate = [srcAttri objectForKey:@"NSFileCreationDate"];
            if ([dstDate compare:srcDate] < 0) {
                //                [fileManager removeItemAtPath:realPath error:nil];
                //                NSString *updatedDataPath = [documentPath stringByAppendingPathComponent:@"updated.data"];
                //                [fileManager removeItemAtPath:updatedDataPath error:nil];
                //                NSString *plistDocPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            }
        }else{
            NSError *error = nil;
            
            if (![fileManager copyItemAtPath:sourcePath toPath:realPath error:&error]) {
                NSLog(@"%@",[error localizedDescription]);
                NSLog(@"复制失败。。。");
            }
//            NSLog(@"复制sqlite到路径：%@成功。",realPath);
        }
    }
    
    return realPath;
}

+ (void) closeDefalt{
	if (dbPointer) {
		[dbPointer close];
		dbPointer = NULL;
	}
}
@end
