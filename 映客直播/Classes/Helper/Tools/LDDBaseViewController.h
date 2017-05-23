//
//  LDDBaseViewController.h
//  团购项目
//
//  Created by Ringo on 2016/11/17.
//  Copyright © 2016年 omni software. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^requestSuccessBlock)(id responseObject);

typedef void(^requestFailureBlock)(NSError *error);

@interface LDDBaseViewController : UITableViewController



//get
-(void)getWithURLString:(NSString*)url
             parameters:(NSDictionary*)param
                success:(requestSuccessBlock) successBlock
                failure:(requestFailureBlock) failureBlock;

//post
-(void)postWithURLString:(NSString*)url
              parameters:(NSDictionary*)param
                 success:(requestSuccessBlock) successBlock
                 failure:(requestFailureBlock) failureBlock;

-(void)showTostMessage:(NSString *)tost;//弹出提示信息


@end
