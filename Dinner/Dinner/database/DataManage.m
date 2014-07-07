//
//  DataManage.m
//  AppPlant
//
//  Created by 陆浩 on 14-2-19.
//  Copyright (c) 2014年 hogesoft. All rights reserved.
//

#import "DataManage.h"
#import "FMResultSet.h"

static DataManage *dbPointer = nil;
//static id JudNull(NSString *str)
//{
//    if (str == nil) {
//        return [NSNull null];
//    }
//    return str;
//}
@implementation DataManage

+(DataManage *)shareDataManage{
    if (dbPointer == nil) {
        dbPointer = [[DataManage alloc] init];
    }
    return dbPointer;
}

#pragma mark -
#pragma mark - Store NetWorkData Operation

- (void)createTableName:(NSString*)tableName 
{
    FMDatabase  *db=[DataBase shareDataBase];
    NSString *sql=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@'('NetworkAPI' TEXT,'JsonData' TEXT);",tableName];
    [db executeUpdate:sql];
}

- (void)deleteTable:(NSString*)tableName
{
    FMDatabase  *db=[DataBase shareDataBase];
    NSString *sql=[NSString stringWithFormat:@"DELETE FROM '%@'",tableName];
    [db executeUpdate:sql];
}


- (void)insertData:(NSString*)tableName 
    withNetworkApi:(NSString*)networkAPI 
        withObject:(id)object
{
    [self deleteData:tableName withNetworkApi:networkAPI];
    if(!isNilNull(object))
    {
        NSData *newData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding];
        FMDatabase  *db=[DataBase shareDataBase];
        NSString *sql=[NSString stringWithFormat:@"INSERT INTO '%@' ('NetworkAPI','JsonData') VALUES('%@','%@')",tableName,networkAPI,jsonStr];
        [db executeUpdate:sql];
    }
}

- (id)getData:(NSString*)tableName withNetworkApi:(NSString*)networkAPI
{
    NSData *JsonData = nil;    
    FMDatabase  *db=[DataBase shareDataBase];
    NSString *qsql= [NSString stringWithFormat: @"SELECT * FROM  '%@' WHERE NetworkAPI=='%@'",tableName,networkAPI];
    FMResultSet *rs;
    rs = [db executeQuery:qsql];
    while ([rs next]) {
        NSString *xmlStr = [rs stringForColumn:@"JsonData"];
        JsonData = [xmlStr dataUsingEncoding: NSUTF8StringEncoding];
    }
    if(!isNilNull(JsonData))
    {
        id object = [NSJSONSerialization JSONObjectWithData:JsonData options:NSJSONReadingMutableContainers error:nil];
        return object;
    }
    return nil;
}

- (void)deleteData:(NSString*)tableName withNetworkApi:(NSString*)networkAPI;
{
    FMDatabase  *db=[DataBase shareDataBase];
    NSString *sqlstr = [NSString  stringWithFormat:@"DELETE FROM '%@' WHERE NetworkAPI=='%@'",tableName,networkAPI];
    [db executeUpdate:sqlstr];
}

@end
