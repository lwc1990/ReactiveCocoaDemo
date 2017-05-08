//
//  AGFMDBUtils.h
//  agan-fruit
//
//  Created by syl on 2017/4/30.
//  Copyright © 2017年 agan-fruil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@interface AGFMDBUtils : NSObject
/* 创建并获取数据库 */
+(FMDatabase *)dataBase:(NSString *)dataBaseName;

@end
