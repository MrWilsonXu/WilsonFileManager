//
//  WilsonWebVC.m
//  WilsonFileManager
//
//  Created by Wilson on 08/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

#import "WilsonWebVC.h"
#import <WebKit/WebKit.h>

@interface WilsonWebVC ()<WKNavigationDelegate, WKUIDelegate>

@property (strong, nonatomic) WKWebView *webView;

@property (strong, nonatomic) UIProgressView * progressView;

@end

@implementation WilsonWebVC

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor ColorWithHex:@"F2F2F2"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)setWebUrl:(NSURL *)webUrl {
    _webUrl = webUrl;

    if ([_webUrl.absoluteString hasPrefix:@"file:"]) {
        [self.webView loadFileURL:_webUrl allowingReadAccessToURL:_webUrl];
    } else {
        [self.webView loadRequest:[NSURLRequest requestWithURL:_webUrl]];
    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    self.progressView.hidden = NO;
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view bringSubviewToFront:self.progressView];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.progressView.hidden = YES;
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    if (error.code == -1009) {
        NSDictionary *dict = error.userInfo;
        NSString *urlStr = dict[@"NSErrorFailingURLStringKey"];
        NSLog(@"----%@----",urlStr);
    } else if (error.code == -1003) {
        NSLog(@"服务器连接错误");
    } else if (error.code == -999) {
        NSLog(@"请求未配置 https ");
    } else {
        NSString *errorCode = [NSString stringWithFormat:@"错误码：%ld",(long)error.code];
        NSLog(@"----%@----",errorCode);
    }
    self.progressView.hidden = YES;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    
    @try{
        if (decisionHandler) {
            if (navigationAction.navigationType ==WKNavigationTypeLinkActivated) {
                decisionHandler(WKNavigationActionPolicyCancel);
            }else{
                decisionHandler(WKNavigationActionPolicyAllow);
            }
        }
    }@catch (NSException *exception){
       
        NSLog(@"decisionHandler");
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.progressView.hidden = YES;
    });
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context {
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(title))] && object == self.webView) {
        if (self.webView.title) {
            self.title =  self.webView.title;
        }
    } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]) {
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
            }];
        }
    } else {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

#pragma mark - Getter

- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.allowsInlineMediaPlayback = YES;
        self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:config];
        _webView.allowsBackForwardNavigationGestures = YES;
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _webView;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 5);
        [_progressView setTrackTintColor:[UIColor colorWithRed:240.0/255
                                                         green:240.0/255
                                                          blue:240.0/255
                                                         alpha:1.0]];
        _progressView.progressTintColor = [UIColor greenColor];
        _progressView.hidden = YES;
        _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    }
    return _progressView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
