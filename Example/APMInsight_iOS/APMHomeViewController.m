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

@interface APMHomeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSMutableArray *items;

@end

@implementation APMHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"APMInsightCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
    self.title = @"APMInsight";
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark Lazy-load
- (NSArray *)items {
    if (!_items) {
        _items = [[NSMutableArray alloc] init];
        
        __weak typeof(self) weakSelf = self;
        void(^crashBlock)(void) = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    APMInsightCrashViewController *viewController = [[APMInsightCrashViewController alloc] init];
                    [strongSelf.navigationController pushViewController:viewController animated:YES];
                }
            });
        };
        APMInsightCellItem *crashItem = [APMInsightCellItem itemWithTitle:@"崩溃分析" block:crashBlock];
        
        void(^exceptionBlock)(void) = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    APMInsightExceptionViewController *viewController = [[APMInsightExceptionViewController alloc] init];
                    [strongSelf.navigationController pushViewController:viewController animated:YES];
                }
            });
        };
        APMInsightCellItem *exceptionItem = [APMInsightCellItem itemWithTitle:@"错误分析" block:exceptionBlock];
        
        void(^lagBlock)(void) = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    APMInsightLagViewController *viewController = [[APMInsightLagViewController alloc] init];
                    [strongSelf.navigationController pushViewController:viewController animated:YES];
                }
            });
        };
        APMInsightCellItem *lagItem = [APMInsightCellItem itemWithTitle:@"卡顿分析" block:lagBlock];
        
        void(^eventBlock)(void) = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    APMInsightEventViewController *viewController = [[APMInsightEventViewController alloc] init];
                    [strongSelf.navigationController pushViewController:viewController animated:YES];
                }
            });
        };
        APMInsightCellItem *eventItem = [APMInsightCellItem itemWithTitle:@"事件分析" block:eventBlock];

        void(^performanceBlock)(void) = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    APMInsightPerformanceViewController *viewController = [[APMInsightPerformanceViewController alloc] init];
                    [strongSelf.navigationController pushViewController:viewController animated:YES];
                }
            });
        };
        APMInsightCellItem *performanceItem = [APMInsightCellItem itemWithTitle:@"用户体验" block:performanceBlock];
        
        void(^hybridBlock)(void) = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    APMInsightHybridViewController *viewController = [[APMInsightHybridViewController alloc] init];
                    [strongSelf.navigationController pushViewController:viewController animated:YES];
                }
            });
        };
        APMInsightCellItem *hybridItem = [APMInsightCellItem itemWithTitle:@"页面监控" block:hybridBlock];
        
        void(^memoryBlock)(void) = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    APMInsightMemoryViewController *viewController = [[APMInsightMemoryViewController alloc] init];
                    [strongSelf.navigationController pushViewController:viewController animated:YES];
                }
            });
        };
        APMInsightCellItem *memoryItem = [APMInsightCellItem itemWithTitle:@"内存优化" block:memoryBlock];
        
        void(^networkBlock)(void) = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    APMInsightNetworkViewController *viewController = [[APMInsightNetworkViewController alloc] init];
                    [strongSelf.navigationController pushViewController:viewController animated:YES];
                }
            });
        };
        APMInsightCellItem *networkItem = [APMInsightCellItem itemWithTitle:@"网络分析" block:networkBlock];

        [_items addObject:crashItem];
        [_items addObject:exceptionItem];
        [_items addObject:lagItem];
        [_items addObject:eventItem];
        [_items addObject:performanceItem];
        [_items addObject:hybridItem];
        [_items addObject:memoryItem];
        [_items addObject:networkItem];
    }
    
    return _items;
}

#pragma mark UITableViewDelegate, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"APMInsightCell"];
    APMInsightCellItem *item = [self.items objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",item.title];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    APMInsightCellItem *item = [self.items objectAtIndex:indexPath.row];
    if (item.selectBlock) {
        item.selectBlock();
    } 
}

@end
