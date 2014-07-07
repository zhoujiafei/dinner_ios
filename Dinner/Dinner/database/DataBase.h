//
//  DataBase.h
//  AppPlant
//
//  Created by 陆浩 on 14-2-19.
//  Copyright (c) 2014年 hogesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DataBase : NSObject
{
    
}

+ (FMDatabase *)shareDataBase;
+ (FMDatabase *)openDB;
+ (void)closeDB:(FMDatabase *)db;
+ (NSString *)setUpDB;
+ (void)closeDefalt;
@end

