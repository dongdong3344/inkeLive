//
//  LDDHotTableView.m
//  映客直播
//
//  Created by Ringo on 2017/1/7.
//  Copyright © 2017年 omni. All rights reserved.
//

#import "LDDHotTableView.h"
#import "LDDHotCell.h"

static NSString *const identifier=@"LDDHotCell";
@interface LDDHotTableView ()
@property(nonatomic,strong)AFHTTPSessionManager *manager;


@end

@implementation LDDHotTableView


-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    if (self=[super initWithFrame:frame style:style]) {
    
    [self registerNib:[UINib nibWithNibName:@"LDDHotCell" bundle:nil] forCellReuseIdentifier:identifier];
        
    
    }
    return self;
}

@end
