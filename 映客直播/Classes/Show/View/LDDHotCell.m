//
//  LDDHotCell.m
//  映客直播
//
//  Created by Ringo on 2017/1/8.
//  Copyright © 2017年 omni. All rights reserved.
//

#import "LDDHotCell.h"
#import "UIImageView+CornerRadius.h"

@interface LDDHotCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UIImageView *bigIconImg;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *tagBtn1;
@property (weak, nonatomic) IBOutlet UIButton *tagBtn2;
@property (weak, nonatomic) IBOutlet UIButton *tagBtn3;
@property (weak, nonatomic) IBOutlet UIButton *tagBtn4;
@property (weak, nonatomic) IBOutlet UIButton *tagBtn5;
@property(nonatomic,strong)NSMutableArray *tagBtnArr;//标签按钮数组
@property(nonatomic,strong)NSMutableArray *titleArr;//标题文字数组
@end

@implementation LDDHotCell

-(NSMutableArray *)titleArr{
    if (!_titleArr) {
        _titleArr=[NSMutableArray array];
    }
    return _titleArr;
}

-(NSMutableArray *)tagBtnArr{
    if (!_tagBtnArr) {
        _tagBtnArr=[NSMutableArray arrayWithArray:@[self.tagBtn1,self.tagBtn2,self.tagBtn3,self.tagBtn4,self.tagBtn5]];
    }
    return _tagBtnArr;
}

-(void)setHotEntity:(LDDHotEntity *)hotEntity{
    _hotEntity=hotEntity;

    //昵称
    self.nickLabel.text=hotEntity.creator.nick;
    //在线人数
    self.lineCountLabel.text=[NSString stringWithFormat:@"%ld 在看",(long)hotEntity.onlineUsers ];
    //描述信息
    self.descriptionLabel.text=hotEntity.name;
    
    NSString *imageUrl;
    if (![hotEntity.creator.portrait hasPrefix:@"http"]) {
        imageUrl=[NSString stringWithFormat:@"%@%@",@"http://img2.inke.cn/",hotEntity.creator.portrait];
    }else{
        imageUrl=hotEntity.creator.portrait;
    }

    //小头像
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"default_head"]];


    //大头像
    [self.bigIconImg sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"default_room"]];
    
    
    //计算标签按钮个数
    NSInteger numCount=hotEntity.extra.label.count;
    //实际获取数据时发现有时候会传递6个tag,本仿写只保留前5个
    if (numCount>=6) numCount=5;

    for (int i=0; i<numCount; i++) {
        NSString *str=hotEntity.extra.label[i][@"tab_name"];
        [self.titleArr addObject:str];
        UIButton *btn=self.tagBtnArr[i];
        [btn setTitle:[NSString stringWithFormat:@"  %@  ",str] forState:UIControlStateNormal];
        btn.layer.borderColor=RGB(44, 229, 205).CGColor;
        btn.layer.borderWidth=0.5;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    //标签按钮,先将全部按钮标题去掉，再进行赋值，防止复用时，重复使用
    
    for (UIButton *btn in self.tagBtnArr) {
        btn.titleLabel.font=[UIFont systemFontOfSize:10];
        [btn setTitle:@"" forState:UIControlStateNormal];
        
        btn.layer.cornerRadius=10;
        btn.layer.masksToBounds=YES;
        btn.layer.borderColor=[UIColor clearColor].CGColor;
        btn.layer.borderWidth=0;
    }

    //设置圆角
     [self.iconImg zy_cornerRadiusAdvance:25 rectCornerType:UIRectCornerAllCorners];
    
    //Cell选中不变色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


/**
 设置圆角图片

 @param image 传入的图片
 */

-(UIImage*)avatarImage:(UIImage*)image{
    
    CGRect rect= CGRectMake(0, 0, self.iconImg.width, self.iconImg.height);
    //根据当前屏幕创建上下文
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    //根据UIBezerPath对象裁剪图形上下文
    UIBezierPath *path=[UIBezierPath bezierPathWithOvalInRect:rect];
    //根据UIBezerPath对象裁剪图形上下文
    [path addClip];
    //上下文中绘制图片
    [image drawInRect:rect];
    //通过图形上下文得到UIImage对象
    UIImage *resultImage=UIGraphicsGetImageFromCurrentImageContext();
    //清理上下文
    UIGraphicsEndImageContext();
    
    return resultImage;
    
}

@end
