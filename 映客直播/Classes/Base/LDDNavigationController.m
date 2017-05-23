//
//  LDDNavigationController.m
//  映客直播
//
//  Created by Ringo on 2016/11/9.
//  Copyright © 2016年 omni. All rights reserved.
//

#import "LDDNavigationController.h"

@interface LDDNavigationController ()

@end

@implementation LDDNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //背景色
    self.navigationBar.barTintColor=RGB(0, 216, 200);
    //按钮颜色
    self.navigationBar.tintColor=[UIColor whiteColor];   
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.viewControllers.count) { //避免一开始就隐藏了
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
@end
