//
//  LDDLocationManager.m
//  映客直播
//
//  Created by Ringo on 2017/1/20.
//  Copyright © 2017年 omni. All rights reserved.
//

#import "LDDLocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface LDDLocationManager ()<CLLocationManagerDelegate>
@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,copy)locationBlock block;
@end

@implementation LDDLocationManager


+(instancetype)sharedManager{
    
    static LDDLocationManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager=[[LDDLocationManager alloc]init];
        
        
    });
    return _manager;
    
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _locationManager=[[CLLocationManager alloc]init];
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;//设置精确度
        
        _locationManager.distanceFilter=100;
        _locationManager.delegate=self;
        
        if (![CLLocationManager locationServicesEnabled]) {
            NSLog(@"请开启定位");
        }else{
            
            CLAuthorizationStatus status=[CLLocationManager authorizationStatus];
            if (status==kCLAuthorizationStatusNotDetermined) {
                [_locationManager requestWhenInUseAuthorization];
            }
        }
        
    }
    return self;
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    // 1.获取用户位置的对象
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    NSString *lat=[NSString stringWithFormat:@"%f",coordinate.latitude];
    NSString *lon=[NSString stringWithFormat:@"%f",coordinate.longitude];
   // NSLog(@"纬度:%f 经度:%f", coordinate.latitude, coordinate.longitude);
    self.block(lat,lon);
    
    [LDDLocationManager sharedManager].lat=lat;
    [LDDLocationManager sharedManager].lon=lon;
    // 2.停止定位
    [manager stopUpdatingLocation];
    
    
}
-(void)getGps:(locationBlock)block{
    
    self.block=block;//将block这个局部变量变成全局变量
    [self.locationManager startUpdatingLocation];//发起定位请求
}
@end
