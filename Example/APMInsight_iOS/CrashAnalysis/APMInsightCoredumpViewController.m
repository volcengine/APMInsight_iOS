//
//  APMInsightCoredumpViewController.m
//  APMInsight_iOS
//
//  Created by ByteDance on 2023/2/25.
//

#import "APMInsightCoredumpViewController.h"
#import "APMInsightCellItem.h"

@interface APMInsightCoredumpViewController () <UITableViewDelegate, UITableViewDataSource>
{
    dispatch_queue_t queue;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSMutableArray *items;

@property (nonatomic, strong) NSMutableDictionary *testMultiThreadDictionary;

@end

@implementation APMInsightCoredumpViewController

#pragma mark - Test case 1
CF_INLINE void methodA() {
    methodB();
}

CF_INLINE void methodB() {
    methodC();
}

CF_INLINE void methodC() {
    int *pointer = (int *)0x01;
    *pointer = 6;
}

- (void)inlineFunctionTrigger {
    // do sth.
    methodA();
    // do sth.
}

#pragma mark - Test case 2
- (void)dispatchAsyncTrigger {
    queue = dispatch_queue_create("cn.volcengine.apmplus.testQueue", NULL);
    dispatch_queue_t queue1 = dispatch_queue_create("cn.volcengine.apmplus.testQueue1", NULL);
    __weak typeof(self) weakSelf = self;
    for (int i = 0; i < 100000; i++) {
        NSLog(@"1");
        dispatch_async(queue1,^{
            __strong typeof(self) strongSelf = weakSelf;
            NSLog(@"2");
            dispatch_async(strongSelf->queue, ^{
                NSLog(@"3");
            });
        });
    }
    
    for (int i = 0; i < 100000; i++) {
        NSLog(@"4");
        queue = dispatch_queue_create("cn.volcengine.apmplus.testQueue", NULL);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"APMInsightCrashCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
    self.title = @"Coredump相关功能测试";
}

#pragma mark UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"APMInsightCrashCell"];
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


#pragma mark Lazy-load
- (NSMutableArray *)items {
    if (!_items) {
        _items = [[NSMutableArray alloc] init];
        
        __weak typeof(self) weakSelf = self;
        void(^inlineFunctionTestBlock)(void) = ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf inlineFunctionTrigger];
            }
        };
        APMInsightCellItem *inlineFunctionTestItem = [APMInsightCellItem itemWithTitle:@"测试Coredump对内联函数的支持" block:inlineFunctionTestBlock];
        
        void(^dispatchAsyncBlock)(void) = ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf dispatchAsyncTrigger];
            }
        };
        APMInsightCellItem *dispatchAsyncItem = [APMInsightCellItem itemWithTitle:@"多线程导致dispatch_async的Crash" block:dispatchAsyncBlock];
        
        [_items addObject:inlineFunctionTestItem];
        [_items addObject:dispatchAsyncItem];
    }
    
    return _items;
}

#pragma mark - Tools

- (UIAlertController *)alertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Get it." style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    return alert;
}

- (UIAlertController *)alertWithTitle:(NSString *)title message:(NSString *)message okHandler:(void (^)(void))okHandler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        okHandler();
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:ok];
    [alert addAction:cancel];
    return alert;
}

@end
