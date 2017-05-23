//
//  LDDHotViewController.m
//  映客直播
//
//  Created by Ringo on 2016/11/10.
//  Copyright © 2016年 omni. All rights reserved.
//

#import "LDDHotViewController.h"
#import "LDDHotCell.h"
#import "LDDHotTableView.h"
#import "LDDWebViewController.h"
#import "LDDHotEntity.h"
#import "LDDPlayerViewController.h"
#import "LDDTabBar.h"
#import "UIView+HKOpenOrClose.h"
#import "LDDRefreshHeader.h"
#import "UIView+LDViewExtension.h"

static NSString *const identifier=@"LDDHotCell";
static CGFloat kDuration=5.f;//定时器刷新时间
static CGFloat kStatusBarHeight = 20.f;
static CGFloat kNavBarHeight = 44.f;
static CGFloat kTabBarCenterButtonDelta = 44.f;//中间按钮超出TabBar的距离，根据实际情况来定

static BOOL SDImageCacheOldShouldDecompressImages = YES;
static BOOL SDImagedownloderOldShouldDecompressImages = YES;


@interface LDDHotViewController ()<SDCycleScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic)SDCycleScrollView *cycleScrollView;
@property(nonatomic,strong)LDDHotTableView *hotTableView;
@property(nonatomic,strong)NSMutableArray *urlArray;
@property(nonatomic,strong)NSMutableArray *hotEntityArr;//模型数组
@property(nonatomic,weak)NSTimer *timer;
@property(assign,nonatomic)CGFloat previousOffsetY;//偏移量
@end

@implementation LDDHotViewController

#pragma mark -getter
-(NSMutableArray *)hotEntityArr{
    if (!_hotEntityArr) {
        _hotEntityArr=[NSMutableArray array];
    }
    return _hotEntityArr;
}

-(NSMutableArray *)urlArray{
    if (!_urlArray) {
        _urlArray=[NSMutableArray array];
    }
    return _urlArray;
}

-(LDDHotTableView *)hotTableView{
    if (!_hotTableView) {
        _hotTableView=[[LDDHotTableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        
        _hotTableView.delegate=self;
        
    }
    return _hotTableView;
}

-(SDCycleScrollView *)cycleScrollView{
    
    if (!_cycleScrollView) {
        _cycleScrollView=[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140) delegate:nil placeholderImage:[UIImage imageNamed:@"default_ticker"]];
        _cycleScrollView.delegate=self;//设置代理
        _cycleScrollView.pageDotColor=[UIColor whiteColor];
        
        _cycleScrollView.currentPageDotColor=RGB(0, 216, 200);
        
        _cycleScrollView.autoScrollTimeInterval=3;//时间间隔
        
        _cycleScrollView.pageControlAliment= SDCycleScrollViewPageContolAlimentCenter
        ;//居中显示
        
    }
    return _cycleScrollView;
}
#pragma mark -点击轮播图片回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (cycleScrollView==self.cycleScrollView) {
        LDDWebViewController *webVC=[[LDDWebViewController alloc]init];
        
        webVC.url=self.urlArray[index];
        self.navigationController.hidesBottomBarWhenPushed=YES;
        
        [self.navigationController pushViewController:webVC animated:YES];
        
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTabBar];
    self.tableView=self.hotTableView;
    self.tableView.contentInset=UIEdgeInsetsMake(64, 0, 0, 0);
    self.automaticallyAdjustsScrollViewInsets =NO;
    self.hotTableView.tableHeaderView=self.cycleScrollView;
    [self loadImgConfiguration];
    
    [self getCycleImages];//请求轮播图数据
    [self setupRefresh];//刷新数据
    [self setupTimer];//定时器
    [self recevieNotification];//接收通知
}


-(void)loadImgConfiguration{
    SDImageCache *canche = [SDImageCache sharedImageCache];
    SDImageCacheOldShouldDecompressImages = canche.shouldDecompressImages;
    canche.shouldDecompressImages = NO;
    
    SDWebImageDownloader *downloder = [SDWebImageDownloader sharedDownloader];
    SDImagedownloderOldShouldDecompressImages = downloder.shouldDecompressImages;
    downloder.shouldDecompressImages = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //开启定时器
    [_timer setFireDate:[NSDate distantPast]];
    
    
    //[_timer fire];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self open];
    //关闭定时器，临时关闭，可再开启
    [_timer setFireDate:[NSDate distantFuture]];
    
    //移除定时器，永久停止
    //[_timer invalidate];
    //_timer=nil;
}

- (void)initTabBar {
    _previousOffsetY = 0;
    UITabBar *tabBar = self.tabBarController.tabBar;
    tabBar.hk_postion = HKMovingViewPostionBottom;
    tabBar.hk_extraDistance = kTabBarCenterButtonDelta;
}

#pragma mark-refresh tableView
-(void)setupRefresh{
    
    
    /**
     此处注意循坏引用，造成内存泄漏！！
     */
    
    __weak typeof(self) weakSelf=self;
   self.tableView.mj_header=[LDDRefreshHeader headerWithRefreshingBlock:^{
       __strong typeof(self) strongself = weakSelf;
        [strongself getHotLiveData];//获取热门数据
       
    }];
    
    [self.tableView.mj_header beginRefreshing];//页面加载时就进行下拉刷新
 
}

#pragma mark -定时器
-(void)setupTimer{

    
    //将计数器的repeats设置为YES的时候，self的引用计数会加1。因此可能会导致self（即viewController）不能release，必须在viewWillAppear/viewDidAppear的时候，将计数器timer开启，在viewWillDisappear/viewDidDisappear的时候，将计数器timer关闭，否则可能会导致内存泄露。
    
    _timer=[NSTimer scheduledTimerWithTimeInterval:kDuration target:self selector:@selector(getHotLiveData) userInfo:nil repeats:YES] ;
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    //UITrackingRunLoopMode,滑动时停止定时器
}


- (void)open {
    [self.navigationController.navigationBar hk_open];
    [self.tabBarController.tabBar hk_open];
}

- (void)close {
    [self.navigationController.navigationBar hk_close];
    [self.tabBarController.tabBar hk_close];
}

- (void)updateScrollViewInset {
    CGFloat navBarMaxY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    CGFloat tabBarMinY = CGRectGetMinY(self.tabBarController.tabBar.frame);
    UIEdgeInsets scrollViewInset = self.tableView.contentInset;
    scrollViewInset.top = navBarMaxY;
    scrollViewInset.bottom = MAX(0, SCREEN_HEIGHT - tabBarMinY);
    self.tableView.contentInset = scrollViewInset;
    self.tableView.scrollIndicatorInsets = scrollViewInset;
}

- (void)closeOrOpenBar {
    //NavBar和TabBar是展开还是收起
    BOOL opening = [self.navigationController.navigationBar hk_shouldOpen];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        CGFloat navBarOffsetY = 0;
        if (opening) {
            //navBarOffsetY为NavBar从当前位置到展开滑动的距离
            navBarOffsetY = [self.navigationController.navigationBar hk_open];
            [self.tabBarController.tabBar hk_open];
        } else {
            //navBarOffsetY为NavBar从当前位置到收起滑动的距离
            navBarOffsetY = [self.navigationController.navigationBar hk_close];
            [self.tabBarController.tabBar hk_close];
        }
        //更新TableView的contentInset
        [self updateScrollViewInset];
        //根据NavBar的偏移量来滑动TableView
        CGPoint contentOffset = self.tableView.contentOffset;
        contentOffset.y += navBarOffsetY;
        self.tableView.contentOffset = contentOffset;
    }];
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //在push到其他页面时候，还是会走该方法，这个时候不应该继续执行
        if (!(self.isViewLoaded && self.view.window != nil)) {
            return;
        }
        
        // 1 - 计算偏移量
        CGFloat contentOffsetY = scrollView.contentOffset.y;
        CGFloat deltaY = contentOffsetY - _previousOffsetY;
        
        // 2 - 忽略超出滑动范围的Offset
        // 1) -忽略向上滑动的Offset
        CGFloat topInset = kStatusBarHeight + kNavBarHeight;
        CGFloat start = -topInset;
        if (_previousOffsetY <= start) {
            deltaY = MAX(0, deltaY + (_previousOffsetY - start));
        }
        
        // 2) - 忽略向下滑动的Offset
        CGFloat maxContentOffset = scrollView.contentSize.height - scrollView.frame.size.height + scrollView.contentInset.bottom;
        CGFloat end = maxContentOffset;
        if (_previousOffsetY >= end) {
            deltaY = MIN(0, deltaY + (_previousOffsetY - maxContentOffset));
        }
        
        // 3 - 更新navBar和TabBar的frame
        [self.navigationController.navigationBar hk_updateOffsetY:deltaY];
        [self.tabBarController.tabBar hk_updateOffsetY:deltaY];
        
        // 4 - 更新TableView的contentInset
        [self updateScrollViewInset];
        
        // 5 - 保存当前的contentOffsetY
        self.previousOffsetY = contentOffsetY;
   
       
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    

    if (scrollView==self.hotTableView) {
    

        _previousOffsetY = scrollView.contentOffset.y;
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    
    //在拖动停止时，根据当前偏移量，决定当前NavBar和TabBar是收起还是展开
    if (scrollView==self.hotTableView) {

        [self closeOrOpenBar];
    }
   }




//请求轮播数据
- (void)getCycleImages{
    
    [[LDDNetworkTool sharedTool]GET:HOT_CYCLEIMG_API parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *dataArray=responseObject[@"ticker"];
        NSMutableArray *imageArr = [NSMutableArray array];
        
        for (NSInteger i=0; i<dataArray.count; i++) {
            NSDictionary *dict=dataArray[i];
            NSString *imageURL= dict[@"image"] ;
            NSString *webURL=dict[@"link"];
            if (![imageURL hasPrefix:@"http://"]) {
                imageURL=[NSString stringWithFormat:@"http://img2.inke.cn/%@",imageURL];
            }
            [imageArr addObject:imageURL];
            
            [self.urlArray addObject:webURL];
        }
        _cycleScrollView.imageURLStringsGroup = imageArr;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        LDDLog(@"error:%@",error);
        
    }];

}
//请求直播数据
-(void)getHotLiveData{
    // 启动系统风火轮
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [[LDDNetworkTool sharedTool]GET:HOT_LIVE_API parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 1秒后隐藏系统风火轮
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
        
    
        [self.hotEntityArr removeAllObjects];//先清空模型数组里内容
    
       // [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];//清除图片缓存
        self.hotEntityArr=[LDDHotEntity mj_objectArrayWithKeyValuesArray:responseObject[@"lives"]];
        
        [self.hotTableView reloadData];//刷新表格数据
        
        [self.tableView.mj_header endRefreshing];//结束刷新
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self.tableView.mj_header endRefreshing];//结束刷新
        // 隐藏系统风火轮
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     return 70+SCREEN_WIDTH;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.hotEntityArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LDDHotCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    cell.hotEntity=self.hotEntityArr[indexPath.row];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LDDHotEntity *hotEntity=self.hotEntityArr[indexPath.row];
    
    LDDPlayerViewController *playerVC=[[LDDPlayerViewController alloc]init];
    
    playerVC.hotEntity=hotEntity;
   
    [self.navigationController pushViewController:playerVC animated:YES];
}

//监听通知
-(void)recevieNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tabBarBtnRepectClick) name:@"LDTabbarButtonDidRepeatClickNotification" object:nil];
}


-(void)tabBarBtnRepectClick{
    
    if (self.view.window==nil)  return;//当前控制器的view不在window上，直接返回
    //NSLog(@"重复点击了%@:",self.class);
    
    if (![self.view intersectWithView:self.view.window]) return;//如果view不在当前窗口上，直接返回
    
    //下拉刷新
    [self.tableView.mj_header beginRefreshing];
}


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];//移除监听
    
    SDImageCache *canche = [SDImageCache sharedImageCache];
    canche.shouldDecompressImages = SDImageCacheOldShouldDecompressImages;
    
    SDWebImageDownloader *downloder = [SDWebImageDownloader sharedDownloader];
    downloder.shouldDecompressImages = SDImagedownloderOldShouldDecompressImages;
    
}


@end
