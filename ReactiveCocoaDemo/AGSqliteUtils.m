//
//  AGSqliteUtils.m
//  agan-fruit
//
//  Created by syl on 2017/4/30.
//  Copyright © 2017年 agan-fruil. All rights reserved.
//

#import "AGSqliteUtils.h"

@implementation AGSqliteUtils
static sqlite3 *db;
+(BOOL)openDataBase:(NSString *)dataBaseName {
    if (!dataBaseName || dataBaseName.length < 1) return NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *dataBasePath = [documentPath stringByAppendingPathComponent:dataBaseName];
    BOOL openSuccess =  (sqlite3_open([dataBasePath UTF8String],&db) == SQLITE_OK);
    NSAssert(openSuccess,@"sqlite3 database open faliure");
    return openSuccess;
}
+(BOOL)removeInValidateDB:(NSString *)dataBaseName
{
    if (!dataBaseName || dataBaseName.length < 1) return YES;
    sqlite3_close(db);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *dataBasePath = [documentPath stringByAppendingPathComponent:dataBaseName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *err;
    BOOL removeSuccess = [fileManager removeItemAtPath:dataBasePath error:&err];
    return removeSuccess;
}
+(BOOL)noQueryExec:(NSString *)dataBase execSql:(NSString *)sqlStr
{
    if (![self openDataBase:dataBase]) return NO;
    return[self execSql:sqlStr];
}
+(BOOL)QueryExec:(NSString *)dataBaseName execSql:(NSString *)sqlStr queryObject:(id<AGSqliteUtilsDelegate>)objc
{
    if (![self openDataBase:dataBaseName]) return NO;
    return [self queryResult:sqlStr qureyObject:objc];
}
+(BOOL)execSql:(NSString *)sql
{
    char *err;
    if (!db) return NO;
    BOOL execSuccess = (sqlite3_exec(db,[sql UTF8String],nil,nil,&err) == SQLITE_OK);
    sqlite3_close(db);
    return execSuccess;
}
+(BOOL)queryResult:(NSString *)sql qureyObject:(id<AGSqliteUtilsDelegate>)objc
{
    if (!db) return NO;
    sqlite3_stmt *stmt;
    BOOL resultSuccess = (sqlite3_prepare_v2(db,[sql UTF8String],-1,&stmt,nil) == SQLITE_OK);
    if (!resultSuccess) return NO;
    NSAssert(objc && [objc conformsToProtocol:@protocol(AGSqliteUtilsDelegate)] && [objc respondsToSelector:@selector(afterExecSql:)],@"please confirm turn into delegate，and implemented the selector");
    [objc afterExecSql:stmt];
    sqlite3_close(db);
    return YES;
}
@end
