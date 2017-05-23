

#import "LDDNetworkTool.h"

@implementation LDDNetworkTool
static LDDNetworkTool *_manager;

+ (instancetype)sharedTool{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [LDDNetworkTool manager];
        // 设置超时时间
        _manager.requestSerializer.timeoutInterval = 5.f;
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
    });
    return _manager;
}

// 判断网络类型
+ (LDDNetworkStates)getNetworkStates{
    
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    // 保存网络状态
    LDDNetworkStates states = LDDNetworkStatesNone;
    for (id child in subviews) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏码
            int networkType = [[child valueForKeyPath:@"dataNetworkType"] intValue];
            switch (networkType) {
                case 0:
                    states = LDDNetworkStatesNone;
                    break;
                case 1:
                    states = LDDNetworkStates2G;
                    break;
                case 2:
                    states = LDDNetworkStates3G;
                    break;
                case 3:
                    states = LDDNetworkStates4G;
                    break;
                case 5:
                    states = LDDNetworkStatesWIFI;
                    break;
                default:
                    break;
            }
        }
    }

    return states;
}
@end
