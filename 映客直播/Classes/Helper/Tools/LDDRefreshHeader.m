//
//  LDDRefreshHeader.m
//
//  Created by Ringo on 2016/12/19.
//  Copyright © 2016年 Ringo. All rights reserved.
//

#import "LDDRefreshHeader.h"

@interface LDDRefreshHeader ()
@property (nonatomic, strong) NSMutableArray *refreshingArr;

@end

@implementation LDDRefreshHeader

- (NSMutableArray *)refreshingArr {
    if (!_refreshingArr) {
        _refreshingArr = [NSMutableArray array];
    }
    return _refreshingArr;
}

//重写prepare方法
- (void)prepare{
    
    [super prepare];
    
    for (int i = 1; i <= 29; i++) {
        
        UIImage *image =[UIImage imageNamed:[NSString stringWithFormat:@"refresh_fly_%04d",i]];

        [self.refreshingArr addObject:image];

    }
    [self setImages:self.refreshingArr duration:2 forState:MJRefreshStateRefreshing];//正在刷新
    [self setImages:@[self.refreshingArr[0]] forState:MJRefreshStateIdle];//空闲状态
    [self setImages:self.refreshingArr forState:MJRefreshStatePulling];//下拉状态
    
    // 隐藏更新时间
    self.lastUpdatedTimeLabel.hidden = YES;
   
    // 隐藏刷新状态
    self.stateLabel.hidden = YES;
    
  
}

//摆放子控件
- (void)placeSubviews{
    
    [super placeSubviews];
   
}
@end
