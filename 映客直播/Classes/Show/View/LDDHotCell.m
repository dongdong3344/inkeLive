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
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *tagBtn1;
@property (weak, nonatomic) IBOutlet UIButton *tagBtn2;
@property (weak, nonatomic) IBOutlet UIButton *tagBtn3;
@property (weak, nonatomic) IBOutlet UIButton *tagBtn4;
@property (weak, nonatomic) IBOutlet UIButton *tagBtn5;
@property(nonatomic,strong)NSMutableArray *tagBtnArr;//标签按钮数组
@property(nonatomic,strong)NSMutableArray *titleArray;//标题文字数组
@end

@implementation LDDHotCell
-(NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray=[NSMutableArray array];
    }
    return _titleArray;
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
    self.nameLabel.text=hotEntity.name;
    
    NSString *imageStr;
    if (![hotEntity.creator.portrait hasPrefix:@"http"]) {
        imageStr=[NSString stringWithFormat:@"%@%@",@"http://img2.inke.cn/",hotEntity.creator.portrait];
    }else{
        imageStr=hotEntity.creator.portrait;
    }
    //小头像****使用此方法内存暴增、卡顿明显
//    
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:imageStr]];
//    UIImage *image = [UIImage imageWithData:data]; // 取得图片
//    [self setCornerRadiusImage:image];//设置圆角
    
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"default_head"]];
    
    //大头像
    [self.bigIconImg sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"default_room"]];
    
    
    //计算标签按钮个数
    NSInteger numCount=hotEntity.extra.label.count;
    //实际获取数据时发现有时候会传递6个tag,本仿写只保留前5个
    if (numCount>=6) numCount=5;

    for (int i=0; i<numCount; i++) {
        NSString *str=hotEntity.extra.label[i][@"tab_name"];
        [self.titleArray addObject:str];
        UIButton *btn=self.tagBtnArr[i];
        [btn setTitle:[NSString stringWithFormat:@"  %@  ",str] forState:UIControlStateNormal];
        btn.layer.borderColor=RGB(44, 229, 205).CGColor;
        btn.layer.borderWidth=0.5;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    /**
     标签按钮**/
    
    //先将全部按钮标题去掉，再进行赋值，防止复用时，重复使用
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


-(void)setCornerRadiusImage:(UIImage*)image{
    
    CGSize orignImageSize=image.size;
    
    //缩略图大小
    CGRect rect=CGRectMake(0, 0, self.iconImg.frame.size.width, self.iconImg.frame.size.width);
    //确定缩放倍数并保持宽高不变
    float ratio=MAX(rect.size.width/orignImageSize.width, rect.size.height/orignImageSize.height);
    //根据当前屏幕创建上下文
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    //创建表示圆角矩形的UIBezerPath对象
    UIBezierPath *path=[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:self.iconImg.frame.size.width/2];
    //根据UIBezerPath对象裁剪图形上下文
    [path addClip];
    //让图片在缩略图绘制范畴中居中
    CGRect newRect;
    newRect.size.width=ratio * orignImageSize.width;
    newRect.size.height=ratio * orignImageSize.height;
    newRect.origin.x=(rect.size.width-newRect.size.width)/2.0;
    newRect.origin.y=(rect.size.height-newRect.size.height)/2.0;
    //上下文中绘制图片
    [image drawInRect:newRect];
    //通过图形上下文得到UIImage对象并将其赋给
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    self.iconImg.image=newImage;
   
    //清理上下文
    UIGraphicsEndImageContext();
    
}

@end
