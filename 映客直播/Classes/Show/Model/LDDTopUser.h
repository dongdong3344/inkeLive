//
//  LDDTopUser.h
//  映客直播
//
//  Created by Ringo on 2017/1/31.
//  Copyright © 2017年 omni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LDDTopUser : NSObject
@property (nonatomic, copy) NSString *birth;
@property (nonatomic, copy) NSString *Description;
@property (nonatomic, copy) NSString *emotion;
@property (nonatomic, assign) NSUInteger gender;
@property (nonatomic, assign) NSUInteger gmutex;
@property (nonatomic, copy) NSString *homeTown;

@property (nonatomic, assign) NSUInteger user_ID;
@property (nonatomic, assign) NSUInteger inkeVerify;
@property (nonatomic, assign) NSUInteger level;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *portrait;

@property (nonatomic, copy) NSString *profession;
@property (nonatomic, assign) NSUInteger rankVeri;
@property (nonatomic, assign) NSUInteger sex;
@property (nonatomic, assign) NSUInteger thirdPlatform;
@property (nonatomic, copy) NSString *veriInfo;
@end
