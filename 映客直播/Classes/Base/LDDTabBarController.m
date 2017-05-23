//
//  LDDTabBarController.m
//  映客直播
//
//  Created by Ringo on 2016/11/9.
//  Copyright © 2016年 omni. All rights reserved.
//

#import "LDDTabBarController.h"
#import "LDDTabBar.h"
#import "LDDNavigationController.h"
#import "LDDLaunchViewController.h"

@interface LDDTabBarController ()
@property(nonatomic,strong)LDDTabBar *inkeTabBar;
@end

@implementation LDDTabBarController


-(LDDTabBar *)inkeTabBar{
    
    if (!_inkeTabBar) {
        _inkeTabBar=[[LDDTabBar alloc]init];
        LDDLaunchViewController *launchVC=[[LDDLaunchViewController alloc]init];
        launchVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;//模态视图方式
        __weak typeof(self) weakSelf=self;
    
        _inkeTabBar.centerBtnClickBlock=^(){
            
            [weakSelf presentViewController:launchVC animated:YES completion:nil];

        };

    }
    
    return _inkeTabBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupControllers];//创建控制器
   
    [self setupTabBar];//设置tabBar
    
}
#pragma mark-设置tabBar

-(void)setupTabBar{
    
    //KVC实质是修改了系统的_tabBar
    [self setValue:self.inkeTabBar forKeyPath:@"tabBar"];
   
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"global_tab_bg"]];
    
    NSMutableArray *controllersArr=[NSMutableArray arrayWithArray:@ [@"LDDMainViewController",@"LDDMeViewController"]];
    NSArray *images=@[@"tab_live",@"tab_me"];
    NSArray *selectedImage=@[@"tab_live_p",@"tab_me_p"];

    for (NSInteger i=0; i<controllersArr.count; i++) {
        NSString *controllerName=controllersArr[i];
        UIViewController *vc=[[NSClassFromString(controllerName) alloc]init];
        [vc.tabBarItem setImage:[UIImage imageNamed:images[i]]];
        vc.tabBarItem.selectedImage=[[UIImage imageNamed:selectedImage[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
       
        vc.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, MAXFLOAT); //将title的位置设置成无限远，隐藏文字

        LDDNavigationController *nav=[[LDDNavigationController alloc]initWithRootViewController:vc];
        [controllersArr replaceObjectAtIndex:i withObject:nav];
    }
    self.viewControllers=controllersArr;
    
}

//点击tabBar按钮点击事件
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    NSInteger index = [self.tabBar.items indexOfObject:item];
    [self animationWithIndex:index];
}

//点击tabBar item动画
- (void)animationWithIndex:(NSInteger) index {
    NSMutableArray *tabBarBtnArr = [NSMutableArray array];
    for (UIView *tabBarBtn in self.tabBar.subviews) {
        if ([tabBarBtn isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarBtnArr addObject:tabBarBtn];
        }
       
    }
    UIButton *btn=tabBarBtnArr[index];
    [UIView animateWithDuration:0.2 animations:^{
        btn.transform=CGAffineTransformMakeScale(1.2, 1.2);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            btn.transform=CGAffineTransformIdentity;
            
        }];
    }];
 
}

//创建控制器
-(void)setupControllers{
    
    NSMutableArray *controllersArry=[NSMutableArray arrayWithArray:@[@"LDDMainViewController",@"LDDMeViewController"]];
    for (NSInteger i=0; i<controllersArry.count; i++) {
        NSString *controllerName=controllersArry[i];
        UIViewController *Viewcontroller=[[NSClassFromString(controllerName) alloc]init];
        //创建每个控制器的导航控制器，需要自定义，故创建baseNAVcontroller
        LDDNavigationController *navVC=[[LDDNavigationController alloc]initWithRootViewController:Viewcontroller];
        //使用navVC 控制器去替换数组
        [controllersArry replaceObjectAtIndex:i withObject:navVC];
    }
    self.viewControllers=controllersArry;//tabBarController的控制器是导航栏控制器
}
@end
