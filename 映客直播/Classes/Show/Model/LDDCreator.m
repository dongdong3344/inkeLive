//
//  LDDCreator.m
//  映客直播
//
//  Created by Ringo on 2017/1/8.
//  Copyright © 2017年 omni. All rights reserved.
//

#import "LDDCreator.h"

@implementation LDDCreator


+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    //解决关键字冲突
    if ([propertyName isEqualToString:@"ID"]) {
        return  @"id";
    }
    
    return [propertyName mj_underlineFromCamel];
}
@end
