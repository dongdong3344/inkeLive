//
//  LDDTabBar.m
//  映客直播
//
//  Created by Ringo on 2016/11/9.
//  Copyright © 2016年 omni. All rights reserved.
//

#import "LDDTabBar.h"

@interface LDDTabBar ()

@property(nonatomic,strong)UIImageView *tabBarBgView; //tabBar背景图
@property(nonatomic,strong)UIButton *launchBtn;//直播按钮
@end

@implementation LDDTabBar


-(UIImageView *)tabBarBgView{
    
    if (!_tabBarBgView) {
        _tabBarBgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"global_tab_bg"]];
        
    }
    return _tabBarBgView;
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    
    if (self = [super initWithFrame:frame]) {
        //1,去掉tabBar的分割线
       [self setBackgroundImage:[[UIImage alloc]init]];
       [self setShadowImage:[[UIImage alloc]init]];
        
        //2,添加背景图
       [self addSubview:self.tabBarBgView];


        //3,按钮背景图
        UIButton *launchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [launchBtn setBackgroundImage:[UIImage imageNamed:@"tab_launch"] forState:UIControlStateNormal];
        
        //4,按钮大小和图片大小一致
        launchBtn.size = launchBtn.currentBackgroundImage.size;
        
        //5,按钮添加点击事件
        [launchBtn addTarget:self action:@selector(launchBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.launchBtn = launchBtn;
        [self addSubview:self.launchBtn];
        
    }
    return self;
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    self.tabBarBgView.frame=self.bounds;
    self.launchBtn.centerX = self.centerX;
    self.launchBtn.centerY = (self.height - (self.launchBtn.height - self.height)) * 0.5;
    
    int index = 0; // 按钮索引
    for (UIView *tabBarButton in self.subviews) {
        if ([NSStringFromClass(tabBarButton.class) isEqualToString:@"UITabBarButton"]){
                
        tabBarButton.width = (self.width-self.launchBtn.width)/2;
            if (index < 1) {
                tabBarButton.left = tabBarButton.width * index;
            }else{ //中间按钮后的宽度
                tabBarButton.left = tabBarButton.width * index + self.launchBtn.width;
            }
            index++;
        }
    }
}

#pragma mark -中间按钮点击事件
-(void)launchBtnClick{
    
    if (self.centerBtnClickBlock) {
        self.centerBtnClickBlock();
    }
}

#pragma mark -超出父控件点击事件处理
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    if (self.isHidden==NO) {
        // 转换坐标系
        CGPoint newPoint = [self.launchBtn convertPoint:point fromView:self];
        //判断如果这个新的点是在中间按钮身上，那么处理点击事件最合适的view就是中间按钮
        if ( [self.launchBtn pointInside:newPoint withEvent:event]) {
            return self.launchBtn;
        }
    }
    
    return [super hitTest:point withEvent:event];
}


@end
