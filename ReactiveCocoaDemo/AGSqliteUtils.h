//
//  AGSqliteUtils.h
//  agan-fruit
//
//  Created by syl on 2017/4/30.
//  Copyright © 2017年 agan-fruil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@protocol AGSqliteUtilsDelegate <NSObject>
-(void)afterExecSql:(sqlite3_stmt *)stmt;
@end
@interface AGSqliteUtils : NSObject
/* 打开对应名字的数据库 */
+(BOOL)openDataBase:(NSString *)dataBaseName;
/* 移除对应名字的数据库文件 */
+(BOOL)removeInValidateDB:(NSString *)dataBaseName;
/* 创建表 */
+(BOOL)createTable:(NSString *)createTableSqlStr;
/* 无查询结果的操作 */
+(BOOL)noQueryExec:(NSString *)dataBase execSql:(NSString *)sqlStr;
/* 有结果的查询操作 */
+(BOOL)QueryExec:(NSString *)dataBaseName execSql:(NSString *)sqlStr queryObject:(id<AGSqliteUtilsDelegate>)objc;
@end
