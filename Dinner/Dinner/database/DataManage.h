//
//  DataManage.h
//  AppPlant
//
//  Created by 陆浩 on 14-2-19.
//  Copyright (c) 2014年 hogesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBase.h"
#define isNilNull(obj)  (!obj || [obj isEqual:[NSNull null]])

@interface DataManage : NSObject{    
}

+(DataManage *)shareDataManage;
//创建表
- (void)createTableName:(NSString*)tableName;
//删除
- (void)deleteTable:(NSString*)tableName;
//*********************FIRST**************************
//插入或者更新数据到对应的URL
- (void)insertData:(NSString*)tableName 
    withNetworkApi:(NSString*)networkAPI 
        withObject:(id)object;

//获取数据库中表里的对应URL的数据
- (id)getData:(NSString*)tableName withNetworkApi:(NSString*)networkAPI;

//删除数据库的某张表里面对应URL的值
- (void)deleteData:(NSString*)tableName withNetworkApi:(NSString*)networkAPI;

@end
