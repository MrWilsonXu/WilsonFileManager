//
//  WilsonWebVC.m
//  WilsonFileManager
//
//  Created by Wilson on 08/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

#import "WilsonWebVC.h"
#import <WebKit/WebKit.h>

@interface WilsonWebVC ()

@property (strong, nonatomic) WKWebView *webView;

@end

@implementation WilsonWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor ColorWithHex:@"F2F2F2"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.webView];
    
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

#pragma mark - Getter

- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.allowsInlineMediaPlayback = YES;
        self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:config];
        _webView.allowsBackForwardNavigationGestures = YES;
    }
    return _webView;
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
