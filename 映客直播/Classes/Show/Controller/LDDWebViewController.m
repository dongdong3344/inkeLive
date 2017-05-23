//
//  LDDWebViewController.m
//  映客直播
//
//  Created by Ringo on 2017/1/8.
//  Copyright © 2017年 omni. All rights reserved.
//

#import "LDDWebViewController.h"
#import "LDDTabBar.h"
#import "HXWebView.h"


static const CGFloat kProgressBarHeight=2.0;
@interface LDDWebViewController ()<HXWebViewDelegate>
@property (weak, nonatomic) IBOutlet HXWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *retryBtn;
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation LDDWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.retryBtn.adjustsImageWhenHighlighted=NO;//取消点击高亮
    self.retryBtn.hidden=YES;
    self.webView.delegate=self;
    [self setupNav];
    [self initProgress];
    [self loadData];
    
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.opaque=NO;//加上这句话，背景色才能起作用
    
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
    [self.navigationController.navigationBar bringSubviewToFront:_progressView];
    self.navigationController.navigationBar.clipsToBounds = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
}

- (void)initProgress{

    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height , navigationBarBounds.size.width, kProgressBarHeight);
    self.progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.frame = barFrame;
    self.progressView.backgroundColor =[UIColor clearColor] ;
    self.progressView.trackTintColor=RGB(0, 228, 210);
    self.progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.progressView setProgress:0 animated:NO];
}

-(void)webView:(HXWebView *)webView updateProgress:(double)progress
{
    if (progress>=1.f) {
        [self.progressView setProgress:0.f animated:NO];
    }else{
        [self.progressView setProgress:progress animated:YES];
    }
}


- (IBAction)retryClick:(id)sender {

    [self loadData];

}

- (void)webViewDidStartLoad:(HXWebView *)webView{
    
     self.retryBtn.hidden=YES;
    
    
}



//获取网页标题
- (void)webViewDidFinishLoad:(HXWebView *)webView{
    
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
}



//加载成败，处理方式

-(void)webView:(HXWebView *)webView didFailLoadWithError:(NSError *)error{
    
    self.retryBtn.hidden=NO;
    [self setBtn];
}



//加载网页
-(void)loadData{
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    
}


//设置按钮，上图下文样式
-(void)setBtn{
    CGFloat spacing = 3.0;
    CGSize imageSize = self.retryBtn.imageView.image.size;
    self.retryBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, -(imageSize.height + spacing), 0.0);
    
    CGSize titleSize = [self.retryBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.retryBtn.titleLabel.font}];
    self.retryBtn.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0.0, 0.0, -titleSize.width);
    
    CGFloat edgeOffset = fabs(titleSize.height - imageSize.height) / 2.0;
    self.retryBtn.contentEdgeInsets = UIEdgeInsetsMake(edgeOffset, 0.0, edgeOffset, 0.0);

}
-(void)setupNav{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];//设置文字颜色、大小
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"title_button_back"] style:UIBarButtonItemStyleDone target:self action:@selector(popAction)];
 
}

-(void)popAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
