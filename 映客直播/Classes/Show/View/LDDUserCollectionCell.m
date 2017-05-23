//
//  LDDUserCollectionCell.m
//  映客直播
//
//  Created by Ringo on 2017/1/30.
//  Copyright © 2017年 omni. All rights reserved.
//

#import "LDDUserCollectionCell.h"


@interface LDDUserCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;

@end
@implementation LDDUserCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconImg.layer.cornerRadius=17.5;
    self.iconImg.layer.masksToBounds=YES;
    self.iconImg.layer.shouldRasterize=YES;
    self.iconImg.layer.rasterizationScale=[UIScreen mainScreen].scale;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //加载xib,不要忘记
        self = [[NSBundle mainBundle]loadNibNamed:@"LDDUserCollectionCell" owner:self options:nil].lastObject;
    }
    
    return self;
}

-(void)setTopUser:(LDDTopUser *)topUser{
    _topUser=topUser;
    NSString *imageStr;
    if (![topUser.portrait hasPrefix:@"http"]) {
        imageStr=[NSString stringWithFormat:@"%@%@",@"http://img2.inke.cn/",topUser.portrait];
    }else{
        imageStr=topUser.portrait;
    }
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"default_head"]];
 
}

@end
