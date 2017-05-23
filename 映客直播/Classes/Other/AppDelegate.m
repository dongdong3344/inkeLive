//
//  AppDelegate.m
//  映客直播
//
//  Created by Ringo on 2016/11/9.
//  Copyright © 2016年 omni . All rights reserved.
//

#import "AppDelegate.h"
#import "LDDTabBarController.h"
#import "LDDLocationManager.h"
#import "Reachability.h"

#define kDeviceVersion  [[UIDevice currentDevice] systemVersion].floatValue
@interface AppDelegate ()<UITabBarControllerDelegate>{
    
    Reachability *_reach;
    LDDNetworkStates _preStatus;
    
}
@property(nonatomic,assign)NSUInteger lastSelectedIndex;//之前选中的控制器的index

@end

@implementation AppDelegate

static UIWindow *topBarWindow;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // iOS8以后需要注册,才能将未读的数在图标右上角显示
    if (kDeviceVersion >= 8.0) {
        // 使用本地通知
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        // 进行注册
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 2;
    }
    
    [NSThread sleepForTimeInterval:1.5];//设置启动页面持续显示时间
    
    LDDTabBarController *tabBarVC=[[LDDTabBarController alloc]init];
    tabBarVC.delegate=self;//设置代理
    self.window.rootViewController=tabBarVC;
       
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        topBarWindow=[[UIWindow alloc]init];
        topBarWindow.frame=[UIApplication sharedApplication].statusBarFrame;
        topBarWindow.windowLevel=UIWindowLevelAlert;
        topBarWindow.backgroundColor=[UIColor clearColor];
        topBarWindow.hidden=NO;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToTop)];
        [topBarWindow addGestureRecognizer:tap];
        
    });
    
    //回去当前位置的经纬度
    [[LDDLocationManager sharedManager]getGps:^(NSString *lat, NSString *lon) {
        
     // NSLog(@"纬度:%@ 经度:%@", lat, lon);
        
    }];
    [self checkNetworkStates];//检测网络状态
    
    return YES;
}

//tabBar控制器代理方法
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    //viewController是封装好的nav,不是子控制器
    
    if (tabBarController.selectedIndex==self.lastSelectedIndex) {//判断当前控制器是不是之前选中的控制器
        //发出通知
        [[NSNotificationCenter defaultCenter]postNotificationName:@"LDTabbarButtonDidRepeatClickNotification" object:nil];
        
    }
    
    self.lastSelectedIndex=tabBarController.selectedIndex;
    
}



-(void)backToTop{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    //查找主窗口内的所有scrollview
    [self searchScrollviewInWindow:window];
}


-(void)searchScrollviewInWindow:(UIView*)view{
    for (UIView *subview in view.subviews) {
        [self searchScrollviewInWindow:subview];
    }
    
    if (![view isKindOfClass:[UIScrollView class]]) return;//不是scrollview直接return
    
    CGRect windowRect=[UIApplication sharedApplication].keyWindow.bounds;
    CGRect viewRect=[view convertRect:view.bounds toView:nil];
    if (!CGRectIntersectsRect(windowRect, viewRect)) return;//不重叠，直接return
    
    UIScrollView *scrollView=(UIScrollView*)view;
    CGPoint offset=scrollView.contentOffset;
    offset.y=-scrollView.contentInset.top;
    [scrollView setContentOffset:offset animated:YES];
    
}



// 实时监控网络状态
- (void)checkNetworkStates{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChange) name:kReachabilityChangedNotification object:nil];
    _reach= [Reachability reachabilityWithHostName:@"http://www.baidu.com"];
    [_reach startNotifier];
}

- (void)networkChange{
    NSString *tips;
    LDDNetworkStates currentStates = [LDDNetworkTool getNetworkStates];
    if (currentStates == _preStatus)return;

    _preStatus = currentStates;
    switch (currentStates) {
        case LDDNetworkStatesNone:
            tips = @"当前无网络, 请检查您的网络状态";
            break;
        case LDDNetworkStates2G:
            tips = @"当前处于非Wifi环境，土豪请随意";
            break;
        case LDDNetworkStates3G:
            tips = @"当前处于非Wifi环境，土豪请随意";
            break;
        case LDDNetworkStates4G:
            tips = @"当前处于非Wifi环境，土豪请随意";
            break;
        case LDDNetworkStatesWIFI:
            tips = nil;
            break;
        default:
            break;
    }
    
    if (tips.length) {
        [[[UIAlertView alloc] initWithTitle:@"映客直播" message:tips delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}



@end
