//
//  ViewController.m
//  APMInsight_iOS
//
//  Created by xuminghao.eric on 2020/11/12.
//

#import "APMHomeViewController.h"
#import "APMInsightCellItem.h"
#import "APMInsightCrashViewController.h"
#import "APMInsightExceptionViewController.h"
#import "APMInsightLagViewController.h"
#import "APMInsightPerformanceViewController.h"
#import "APMInsightHybridViewController.h"
#import "APMInsightMemoryViewController.h"
#import "APMInsightNetworkViewController.h"
#import "APMInsightEventViewController.h"
#import "APMInsightALogViewController.h"
#import "APMInsightProtectorViewController.h"

@implementation APMHomeViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellIdentifier = @"APMInsightHomeCell";
        self.vcTitle = @"APMInsight";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)setupItems {
    [super setupItems];
    
    [self.items addObject:[self itemWithTitle:@"崩溃分析" viewController:[[APMInsightCrashViewController alloc] init]]];
    [self.items addObject:[self itemWithTitle:@"错误分析" viewController:[[APMInsightExceptionViewController alloc] init]]];
    [self.items addObject:[self itemWithTitle:@"卡顿分析" viewController:[[APMInsightLagViewController alloc] init]]];
    [self.items addObject:[self itemWithTitle:@"事件分析" viewController:[[APMInsightEventViewController alloc] init]]];
    [self.items addObject:[self itemWithTitle:@"用户体验" viewController:[[APMInsightPerformanceViewController alloc] init]]];
    [self.items addObject:[self itemWithTitle:@"页面监控" viewController:[[APMInsightHybridViewController alloc] init]]];
    [self.items addObject:[self itemWithTitle:@"网络优化" viewController:[[APMInsightNetworkViewController alloc] init]]];
    [self.items addObject:[self itemWithTitle:@"日志回捞" viewController:[[APMInsightALogViewController alloc] init]]];
    [self.items addObject:[self itemWithTitle:@"异常防护 - 崩溃防护" viewController:[[APMInsightProtectorViewController alloc] init]]];
}

- (APMInsightCellItem *)itemWithTitle:(NSString *)title viewController:(UIViewController *)viewController {
    __weak typeof(self) weakSelf = self;
    
    void(^block)(void) = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf.navigationController pushViewController:viewController animated:YES];
            }
        });
    };
    APMInsightCellItem *item = [APMInsightCellItem itemWithTitle:title block:block];
    return item;
}

@end
