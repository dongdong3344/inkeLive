//
//  LDDMeViewController.m
//  映客直播
//
//  Created by Ringo on 2016/11/9.
//  Copyright © 2016年 omni. All rights reserved.
//

#import "LDDMeViewController.h"
#import "LDDTableViewCell.h"
#import "LDDCell.h"


#define kHeadViewH 320.0

static NSString * reuseCellID=@"LDDTableViewCell";

static NSString * CellID=@"LDDCell";

@interface LDDMeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraints;
@property(assign,nonatomic) CGFloat originalOffSetY;//起始偏移量
@property(strong,nonatomic)NSArray *itemArray;
@property(strong,nonatomic)NSArray *desArray;
@property(strong,nonatomic)UIButton *titleViewBtn;



@end

@implementation LDDMeViewController


-(UIButton *)titleViewBtn{
    if (!_titleViewBtn) {
        _titleViewBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_titleViewBtn setImage:[UIImage imageNamed:@"diomaond"] forState:UIControlStateNormal];
        [_titleViewBtn setTitle:@"送出0" forState:UIControlStateNormal];
        _titleViewBtn.titleLabel.font=[UIFont fontWithName:@"Chalkboard SE" size:14];
    
        _titleViewBtn.size=CGSizeMake(100, 20);
        
        CGFloat imgX=_titleViewBtn.imageView.frame.origin.x
        ;
        CGFloat titleX=_titleViewBtn.titleLabel.frame.origin.x
        ;
        if (imgX<titleX) {
            CGRect titleFrame=_titleViewBtn.titleLabel.frame;
            titleFrame.origin.x=imgX;
            _titleViewBtn.titleLabel.frame=titleFrame;
            
            CGRect imgFrame=_titleViewBtn.imageView.frame;
            imgFrame.origin.x=CGRectGetMaxX(_titleViewBtn.titleLabel.frame);
            _titleViewBtn.imageView.frame=imgFrame;

        }
        
//        
//        [_titleViewBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 40)];
//        _titleViewBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 20);
    }
    return _titleViewBtn;
}
-(NSArray *)itemArray{
    if (!_itemArray) {
        _itemArray=@[@"视频",@"收益",@"账户",@"等级",@"实名认证",@"设置"];
    }
    return _itemArray;
}

-(NSArray *)desArray{
    if (!_desArray) {
        _desArray=@[@"",@"0映票",@"0砖石",@"5等级",@""];
    }
    return _desArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNAV];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.originalOffSetY=-kHeadViewH;
    
   
    self.tableView.backgroundColor=RGB(244, 244, 244);
    self.tableView.contentInset=UIEdgeInsetsMake(kHeadViewH, 0, 0, 0);
    self.tableView.showsVerticalScrollIndicator=NO;
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LDDTableViewCell" bundle:nil] forCellReuseIdentifier:reuseCellID];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LDDCell" bundle:nil] forCellReuseIdentifier:CellID];

    
    
         
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //获取当前滚动偏移量-开始时的偏移量
    CGFloat currentOffSetY=scrollView.contentOffset.y;
    
    CGFloat deltaY=currentOffSetY-self.originalOffSetY;
    
    //计算下头部试图高度
    CGFloat h=kHeadViewH - deltaY;
    if (h<64)  h=64;

    self.heightConstraints.constant=h;
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==0 || section==2) {
        return 1;
    }else if (section==1){
        return 5;
    }
    return 0;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0 && indexPath.row==0) {
        LDDTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseCellID];
        return cell;
    }
    
    
    LDDCell *cell =[tableView dequeueReusableCellWithIdentifier:CellID];
    if (indexPath.section==1) {
        
        cell.titleLabel.text=[self.itemArray objectAtIndex:indexPath.row];
        cell.desLabel.text=[self.desArray objectAtIndex:indexPath.row];
        if (indexPath.row==3) {
            cell.desLabel.textColor=[UIColor grayColor];
        }
    }
    if (indexPath.section==2){
        cell.titleLabel.text=[self.itemArray lastObject];
        cell.desLabel.text=@"";
    }
    return cell;
}


/*设置footerView的背景色*/
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = RGB(244, 244, 244);
    
}
-(void)setupNAV{
    
    self.navigationItem.titleView=self.titleViewBtn;
    self.navigationController.navigationBar.shadowImage=[UIImage new];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];

    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"message"] style:UIBarButtonItemStyleDone target:self action:@selector(searchAction:)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"me_btn_edit_h_"] style:UIBarButtonItemStyleDone target:self action:@selector(messageAction:)];
    
    
}


-(void)searchAction:(UIButton*)button{
    
    
}

-(void)messageAction:(UIButton*)button{
    
    
}
@end
