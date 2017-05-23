//
//  LDDLiveViewController.m
//  映客直播
//
//  Created by Ringo on 2016/11/9.
//  Copyright © 2016年 omni. All rights reserved.
//

#import "LDDMainViewController.h"

static CGFloat const titleBtnWidth = 50.0;//文字按钮宽度
static CGFloat const maxScale = 1.2;//点击标题按钮，文字放大倍数

@interface LDDMainViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong) UIScrollView *mainScrollView;//内容滚动试图
@property(nonatomic,strong) UIScrollView *titleScrollView;//标题滚动试图
@property(nonatomic,strong) NSMutableArray *buttonArr;//用于存放标题按钮
@property(nonatomic,strong) NSArray *titleArr;//标题文字数组
@property(nonatomic,strong) UIButton *lastSelectedBtn;//选中的按钮
@property(nonatomic,strong) UIButton *dropBtn;//向下的按钮
@property(nonatomic,strong)UILabel *lineLabel;//下划线

@end

@implementation LDDMainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
}

-(void)initUI{
    
    //1,不要自动调整
    self.automaticallyAdjustsScrollViewInsets =NO;
    
    //2,添加左右按钮
    [self setupNavigationBar];
    
    //3,添加子视图控制器
    [self setupChildVc];
    
    //4,设置标题按钮
    [self setupTitleButton];
    
}

#pragma mark- getter
-(NSArray*)titleArr{
    
    //标题文字应该从服务器获取，但是在热门频道，点击cell push后，再点击关闭按钮pop到根视图控制器后黑屏，需要点击下“热门”按钮才能恢复，原因不明。故此处暂且将标题数组定死。
    /**
    _titleArr=[NSMutableArr Arr];
    
            [[LDDNetworkTool sharedTool]GET:HOT_NAVTAG_API parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                for (NSInteger i=0; i<[responseObject[@"tabs"] count]; i++) {
                    NSDictionary *dict=responseObject[@"tabs"][i];
                    NSString *title= dict[@"tab_title"];
                    [_titleArr addObject:title];//tmpArr数组指针没有改变，只是指向的内存里的内容改变，无法再外部增加__block修饰符
                }
    
                    [self initUI];
    
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                LDDLog(@"error:%@",error);
            }];
     */

    if (!_titleArr) {
        _titleArr=@[@"关注",@"热门",@"附近",@"视频",@"游戏",@"才艺",@"好声音"];
    }
    return _titleArr;
}

-(UILabel *)lineLabel{
    if (!_lineLabel) {
        _lineLabel=[[UILabel alloc]init];
        _lineLabel.backgroundColor=[UIColor whiteColor];
        [self.titleScrollView addSubview:_lineLabel];
    }
    return _lineLabel;
    
}
-(NSMutableArray *)buttonArr{
    
    if (!_buttonArr) {
        _buttonArr=[NSMutableArray array];
    }
    return _buttonArr;
}

-(UIScrollView *)titleScrollView{
    
    if (!_titleScrollView) {
        _titleScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.titleArr.count*titleBtnWidth, 44)];
        _titleScrollView.showsHorizontalScrollIndicator=NO;
        _titleScrollView.bounces=NO;//不让其左右弹动
        [self.view addSubview:_titleScrollView];

    }
    return _titleScrollView;
}

-(UIScrollView *)mainScrollView{
    
    if (!_mainScrollView) {
        _mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH, SCREEN_HEIGHT)];
        _mainScrollView.contentSize=CGSizeMake(self.titleArr.count *SCREEN_WIDTH, 0);
        _mainScrollView.delegate = self;
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.showsHorizontalScrollIndicator=NO;
        _mainScrollView.bounces=NO;//不让其弹动
        [self.view addSubview:_mainScrollView];

    }
    return _mainScrollView;
}

//向下的箭头按钮
-(UIButton *)dropBtn{
    if (!_dropBtn) {
        _dropBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_dropBtn setImage:[UIImage imageNamed:@"live_area_drop"] forState:UIControlStateNormal];
       
        [self.titleScrollView addSubview:_dropBtn];
        
    }
    return _dropBtn;
}
#pragma mark -初始化标题栏
- (void)setupTitleButton {
   
    CGFloat btnW=titleBtnWidth;
    CGFloat btnH=20;
    for (NSInteger i=0;i<self.titleArr.count;i++) {
        UIButton *titleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [titleBtn setTitle:_titleArr[i] forState:UIControlStateNormal];
        titleBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        titleBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
        [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        titleBtn.tag=i;//设置tag值
        titleBtn.frame=CGRectMake(i*btnW, 12, btnW, btnH);
        [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleScrollView addSubview:titleBtn];
        [self.buttonArr addObject:titleBtn];
        
        if (i==1) {
            [self.dropBtn sizeToFit];
            self.dropBtn.top=titleBtn.bottom-4;
            self.dropBtn.centerX=titleBtn.centerX;
            [self titleBtnClick:titleBtn];
        }
        self.titleScrollView.contentSize=CGSizeMake(self.titleArr.count*titleBtnWidth, 0);//设置contentSize
    }
}

#pragma mark -title点击事件处理
- (void)titleBtnClick:(UIButton *)button {

    [self selectTitleBtn:button];
    
    self.mainScrollView.contentOffset = CGPointMake(button.tag*SCREEN_WIDTH, 0);
    
    [self selectContentViewWithIndex:button.tag];
    
    
    
}

#pragma mark -按钮放大
-(void)selectTitleBtn:(UIButton *)button{
    //之前选中的按钮恢复默认大小
    self.lastSelectedBtn.transform = CGAffineTransformIdentity;
    //放大当前按钮
    button.transform = CGAffineTransformMakeScale(maxScale, maxScale);
    
    //当前按钮成为已选中的按钮
    self.lastSelectedBtn = button;
    
    //更新下划线位置
    [self setupLinePosition:button];

    //设置标题按钮居中显示
    [self setupTitleCenter:button];
    
}

#pragma mark -更新lineLabel位置
-(void)setupLinePosition:(UIButton*)button{
    
    if (button.tag==1) {
        self.dropBtn.hidden=NO;
        self.lineLabel.hidden=YES;
    }else{
        self.dropBtn.hidden=YES;
        self.lineLabel.hidden=NO;
    }
    //重新设置label的frame
    [UIView animateWithDuration:0.2 animations:^{
        self.lineLabel.centerX=button.centerX;
        self.lineLabel.size=CGSizeMake(10, 2);
        self.lineLabel.top=button.bottom+4;
    }];
}

#pragma mark -更新title显示
-(void)setupTitleCenter:(UIButton *)button {

    CGFloat offsetX= button.center.x - 0.5*self.titleScrollView.width;
    CGFloat offsetMax =self.titleScrollView.contentSize.width -self.titleScrollView.width;
    //在偏最左和偏最右时，标题按钮不需要滚动到中间位置
    if (offsetX < 0)		 offsetX = 0;
    if (offsetX > offsetMax && offsetMax>0) offsetX = offsetMax;
    
    [self.titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
}

#pragma mark -添加子控制器View
- (void)selectContentViewWithIndex:(NSUInteger)index {
    
    UIViewController *childVC = self.childViewControllers[index];
    [self.mainScrollView setContentOffset:CGPointMake(index*SCREEN_WIDTH, 0) animated:YES];
    if ([childVC isViewLoaded])  return;
    
    childVC.view.frame = self.mainScrollView.bounds;
    [self.mainScrollView addSubview:childVC.view];
}

#pragma mark -设置子控制器
-(void)setupChildVc{

 NSArray*controllerArr=@[@"LDDFollowViewController",@"LDDHotViewController",@"LDDNearViewController",@"LDDVideoViewController",@"LDDGameViewController",@"LDDTalentViewController",@"LDDVoiceViewController"];
    
    for (NSInteger i=0; i<controllerArr.count; i++) {
        UIViewController *childVC=[[NSClassFromString(controllerArr[i]) alloc]init];
        
        [self addChildViewController:childVC];
    }

}

#pragma mark -ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger leftIndex = scrollView.contentOffset.x/SCREEN_WIDTH;
    NSInteger rightIndex=leftIndex+1;
    UIButton *leftButton = self.buttonArr[leftIndex];
    UIButton *rightButton  = nil;
    if (rightIndex < self.buttonArr.count) {
        rightButton  = self.buttonArr[rightIndex];
    }
    
    CGFloat scale = (scrollView.contentOffset.x - leftIndex*SCREEN_WIDTH)/SCREEN_WIDTH;
    
    rightButton.transform = CGAffineTransformMakeScale(1 + scale*(maxScale-1), 1 + scale*(maxScale-1));
    leftButton.transform = CGAffineTransformMakeScale(1 + (1 - scale)*(maxScale-1), 1 + (1 - scale)*(maxScale-1));
   
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger index = scrollView.contentOffset.x/SCREEN_WIDTH;//计算索引值
    [self selectContentViewWithIndex:index];
    
    [self selectTitleBtn:self.buttonArr[index]];
    
}

#pragma mark -设置NavigationBar
-(void)setupNavigationBar{
    
    self.navigationItem.titleView=self.titleScrollView;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"title_button_search"] style:UIBarButtonItemStyleDone target:self action:@selector(searchAction:)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"message"] style:UIBarButtonItemStyleDone target:self action:@selector(messageAction:)];
    
    
}
-(void)searchAction:(UIButton*)button{
    
    
}

-(void)messageAction:(UIButton*)button{
    
    
}
@end
