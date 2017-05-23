//
//  LDDNearViewController.m
//  映客直播
//
//  Created by Ringo on 2016/11/10.
//  Copyright © 2016年 omni. All rights reserved.
//

#import "LDDNearViewController.h"
#import "LDDLocationManager.h"
#import "LDDFlow.h"

@interface LDDNearViewController ()


@property(nonatomic,strong)NSMutableArray *flowEntityArr;
@end

@implementation LDDNearViewController

-(NSMutableArray *)flowEntityArr{
    if (_flowEntityArr) {
        _flowEntityArr=[NSMutableArray array];
    }
    return _flowEntityArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self requestData];
   
}


-(void)requestData{
    
    LDDLocationManager *locationManager=[LDDLocationManager sharedManager];
    NSDictionary *dic=@{@"uid":@"139182535",
                        @"latitude":locationManager.lat,
                        @"longitude":locationManager.lon};
    
    AFHTTPSessionManager *manager=[[AFHTTPSessionManager alloc]init];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/plain"];
    
    [manager GET:HOT_NEAR_API parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //LDDLog(@"reponseObject:%@",responseObject);
        
        self.flowEntityArr=[LDDFlow mj_objectArrayWithKeyValuesArray:responseObject[@"flow"]];
        // NSLog(@"array:%@",self.flowEntityArr);
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

@end
