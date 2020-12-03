//
//  APMInsightWebViewController.m
//  APMInsight_iOS
//
//  Created by xuminghao.eric on 2020/11/18.
//

#import "APMInsightWebViewController.h"
#import <WebKit/WebKit.h>

@interface APMInsightWebViewController ()<WKNavigationDelegate>

@property (nonatomic, copy) NSString *urlString;

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation APMInsightWebViewController

+ (instancetype)webViewControllerWithURLString:(NSString *)urlString title:(NSString *)title {
    APMInsightWebViewController *webViewController = [[APMInsightWebViewController alloc] init];
    webViewController.urlString = urlString;
    webViewController.title = title;
    return webViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    [self.view addSubview:self.webView];
    self.webView.navigationDelegate = self;
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
}

#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {

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
