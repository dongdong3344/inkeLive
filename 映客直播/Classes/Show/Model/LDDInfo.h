//
//  LDDInfo.h
//  映客直播
//
//  Created by Ringo on 2017/1/20.
//  Copyright © 2017年 omni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LDDCreator.h"
@interface LDDInfo : NSObject

@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) LDDCreator * creator;
@property (nonatomic, strong) NSString * ctime;
@property (nonatomic, strong) NSString * distance;
@property (nonatomic, assign) NSInteger feedId;
@property (nonatomic, assign) NSInteger isDel;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) NSInteger viewCount;
@end
