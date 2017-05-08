//
//  AGFMDBUtils.m
//  agan-fruit
//
//  Created by syl on 2017/4/30.
//  Copyright © 2017年 agan-fruil. All rights reserved.
//

#import "AGFMDBUtils.h"

@implementation AGFMDBUtils
+(FMDatabase *)dataBase:(NSString *)dataBaseName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *docmentPath = [paths objectAtIndex:0];
    NSString *dataBasePath = [docmentPath stringByAppendingPathComponent:dataBaseName];
    return [FMDatabase databaseWithPath:dataBasePath];
}
@end
