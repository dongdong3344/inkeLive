//
//  LDDInfoEntity.m
//  映客直播
//
//  Created by Ringo on 2017/1/20.
//  Copyright © 2017年 omni. All rights reserved.
//

#import "LDDInfo.h"


@implementation LDDInfo

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             
             @"ID":@"id"
             
             };
}


+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName
{
    return [propertyName mj_underlineFromCamel];
}

@end
