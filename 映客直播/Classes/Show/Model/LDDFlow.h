//
//  LDDFlow.h
//  映客直播
//
//  Created by Ringo on 2017/1/20.
//  Copyright © 2017年 omni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LDDInfo.h"

@interface LDDFlow : NSObject
@property (nonatomic, strong) NSString * flowType;
@property (nonatomic, strong) LDDInfo * info;
@end
