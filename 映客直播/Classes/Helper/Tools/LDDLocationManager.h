//
//  LDDLocationManager.h
//  映客直播
//
//  Created by Ringo on 2017/1/20.
//  Copyright © 2017年 omni. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^locationBlock)(NSString *lat,NSString*lon);//参数是经纬度

@interface LDDLocationManager : NSObject

+(instancetype)sharedManager;

-(void)getGps:(locationBlock)block;

@property(nonatomic,copy)NSString *lat;
@property(nonatomic,copy)NSString *lon;

@end
