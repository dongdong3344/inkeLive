//
//  LDDBaseViewController.m
//  团购项目
//
//  Created by Ringo on 2016/11/17.
//  Copyright © 2016年 omni software. All rights reserved.
//

#import "LDDBaseViewController.h"

@interface LDDBaseViewController ()

@end

@implementation LDDBaseViewController


//get
-(void)getWithURLString:(NSString *)url parameters:(NSDictionary *)param success:(requestSuccessBlock)successBlock failure:(requestFailureBlock)failureBlock{
    
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative ];//小圆圈动画风格
    
    [SVProgressHUD show];//小圆圈动起来，
    
    
    [[LDDNetworkTool sharedTool]GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self performSelector:@selector(dismiss)withObject:nil afterDelay:1];///小圆圈显示1秒后消失
        
        if (successBlock) {
            successBlock(responseObject);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];//小圆圈消失
        if (failureBlock) {
            failureBlock(error);
        }
    }];
    
}

//post
-(void)postWithURLString:(NSString *)url parameters:(NSDictionary *)param success:(requestSuccessBlock)successBlock failure:(requestFailureBlock)failureBlock{
    [SVProgressHUD showWithStatus:nil];//小圆圈动起来
    
    [[LDDNetworkTool sharedTool]POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self performSelector:@selector(dismiss)withObject:nil afterDelay:1];///小圆圈显示1秒后消失
        
        if (successBlock) {
            successBlock(responseObject);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];//小圆圈消失
        if (failureBlock) {
            failureBlock(error);
        }

    }];
  
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)showTostMessage:(NSString *)tost{
    /*
    @"CSToastPositionTop";
    @"CSToastPositionCenter";
    @"CSToastPositionBottom";
     
     */
    [self.view makeToast:tost duration:1.5 position:@"CSToastPositionCenter" ];

    
}
-(void)dismiss{
    
    [SVProgressHUD dismiss];
}
@end
