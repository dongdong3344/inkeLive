//
//  LDDHotEntity.m
//  映客直播
//
//  Created by Ringo on 2017/1/8.
//  Copyright © 2017年 omni. All rights reserved.
//

#import "LDDHotEntity.h"

@implementation LDDHotEntity

//关键字替代

+(NSDictionary*)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

/**
 下划线转成驼峰法

 @param propertyName 属性名称

 */
+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    
    if ([propertyName isEqualToString:@"ID"]) return nil;
    
    return [propertyName mj_underlineFromCamel];
    
    //1个key在执行mj_replacedKeyFromPropertyName121方法的时候已经经过mj_underlineFromCamel方法返回具体值，既然有值了，自然就轮不到执行mj_replacedKeyFromPropertyName方法。你可以将mj_replacedKeyFromPropertyName的内容写到mj_replacedKeyFromPropertyName121的，合二为一。
     
}
@end
