

#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSUInteger, LDDNetworkStates) {
    LDDNetworkStatesNone, // 没有网络
    LDDNetworkStates2G, // 2G
    LDDNetworkStates3G, // 3G
    LDDNetworkStates4G, // 4G
    LDDNetworkStatesWIFI // WIFI
};

@interface LDDNetworkTool : AFHTTPSessionManager
+ (instancetype)sharedTool;

// 判断网络类型
+ (LDDNetworkStates)getNetworkStates;
@end
