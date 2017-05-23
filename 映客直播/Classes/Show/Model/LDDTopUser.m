//
//  LDDTopUser.m
//  映客直播
//
//  Created by Ringo on 2017/1/31.
//  Copyright © 2017年 omni. All rights reserved.
//

#import "LDDTopUser.h"

@implementation LDDTopUser

//解决关键字冲突
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"user_ID": @"id"};
}

+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName
{
    return [propertyName mj_underlineFromCamel];
}
@end
