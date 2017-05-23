//
//  LDDLivingViewController.m
//  映客直播
//
//  Created by Ringo on 2017/1/15.
//  Copyright © 2017年 omni. All rights reserved.
//

#import "LDDLivingViewController.h"
#import "LDDUserCollectionCell.h"
#import "LDDTopUser.h"
static NSString *identifier=@"LDDUserCollectionCell";

@interface LDDLivingViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *closeImgView;//关闭按钮
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;//头像
@property (weak, nonatomic) IBOutlet UILabel *onLineLabel;//观看人数
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;//背景图片
@property (weak, nonatomic) IBOutlet UICollectionView *topUserCollectionView;//topUser
@property (weak, nonatomic) IBOutlet UILabel *userIDLabel;//ID
@property (strong,nonatomic) NSMutableArray *topUsersArray;//人员数组

@end

@implementation LDDLivingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.iconImg.layer.cornerRadius=20;
    self.iconImg.layer.masksToBounds=YES;
    
    [self setupClose];
    [self setupCollectionView];

}

-(void)setupClose{
    
    self.closeImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeClick)];
    [self.closeImgView addGestureRecognizer:gesture];
    
}

-(void)setupCollectionView{
    
    // 设置流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize=CGSizeMake(35, 35);
    // 设置最小行间距
    layout.minimumLineSpacing =10;

    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.topUserCollectionView.collectionViewLayout=layout;
    // 通过xib注册
    [self.topUserCollectionView registerClass:[LDDUserCollectionCell class] forCellWithReuseIdentifier:identifier];
    self.topUserCollectionView.showsHorizontalScrollIndicator = NO;
    self.topUserCollectionView.bounces = NO;
    self.topUserCollectionView.backgroundColor=[UIColor clearColor];
    
}

-(void)setTopUsersArray:(NSMutableArray *)topUsersArray{
    _topUsersArray=topUsersArray;
    
}

- (void)loadDataForTopUser {

  NSString *url = [NSString stringWithFormat:@"%@%lu&s_sg=465491e51221b2aa56cdefeffcd99ce0&s_sc=100&s_st=1485826864",TopUser_API,self.hotEntity.ID];
    
  [[LDDNetworkTool sharedTool]GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      
   self.topUsersArray = [LDDTopUser mj_objectArrayWithKeyValuesArray:responseObject[@"users"]];

    [self.topUserCollectionView reloadData];
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      
      LDDLog(@"error:%@",error);
      
  }];
   
    
}
-(void)setHotEntity:(LDDHotEntity *)hotEntity{
    _hotEntity=hotEntity;
    self.onLineLabel.text=[NSString stringWithFormat:@"%ld",(long)hotEntity.onlineUsers];
    self.userIDLabel.text=[NSString stringWithFormat:@"映客号:%lu",_hotEntity.creator.ID];
    
    NSString *imageStr;
    if (![hotEntity.creator.portrait hasPrefix:@"http"]) {
        imageStr=[NSString stringWithFormat:@"%@%@",@"http://img2.inke.cn/",hotEntity.creator.portrait];
    }else{
        imageStr=hotEntity.creator.portrait;
    }
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"default_head"]];
    
    
    [self loadDataForTopUser];//请求topUser数据
   
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 30;

}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LDDUserCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.topUser=self.topUsersArray[indexPath.item];
   
    return cell;
}

-(void)closeClick{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
