//
//  LDDTabBar.h
//  映客直播
//
//  Created by Ringo on 2016/11/9.
//  Copyright © 2016年 omni. All rights reserved.
//

#import <UIKit/UIKit.h>


//定义block
typedef void(^LDDTabBarBlock)();

@interface LDDTabBar:UITabBar

@property(nonatomic,copy)LDDTabBarBlock clickBlock;
@end
