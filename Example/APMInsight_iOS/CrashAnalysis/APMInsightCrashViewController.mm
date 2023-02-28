//
//  APMInsightCrashViewController.m
//  APMInsight_iOS
//
//  Created by xuminghao.eric on 2020/11/12.
//

#import "APMInsightCrashViewController.h"
#import "APMInsightCellItem.h"
#include <pthread.h>
#import "APMInsightGWPASanViewController.h"
#import "APMInsightCoredumpViewController.h"

@interface APMInsightCrashViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSMutableArray *items;

@end

@implementation APMInsightCrashViewController

#pragma mark - Test cases

- (void)NSExceptionTrigger {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [self alertWithTitle:@"NSException" message:@"即将触发NSException类型崩溃，APP将闪退，稍后重新启动APP即可在平台上看到崩溃日志" okHandler:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSException *exception = [NSException exceptionWithName:@"TEST_EXCEPTION" reason:@"APMInsight is testing NSException" userInfo:nil];
                [exception raise];
            });
        }];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)CPPExceptionTrigger {
    throw 0;
}

static BOOL shouldRaiseException = NO;

- (void)AsyncExceptionTigger {
    shouldRaiseException = YES;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self tryRaiseException];
    });
}

- (void)tryRaiseException {
    if (shouldRaiseException) {
        [[NSException exceptionWithName:@"Test_Async_Exception" reason:@"APMInsight is testing AsyncException" userInfo:nil] raise];
    }
}

- (void)signalExceptionTrigger {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [self alertWithTitle:@"SignalException" message:@"即将触发Signal类型崩溃，APP将闪退，稍后重新启动APP即可在平台上看到崩溃日志" okHandler:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                raise(SIGABRT);
            });
        }];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)machExceptionTrigger {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [self alertWithTitle:@"MachException" message:@"即将触发Mach类型崩溃，APP将闪退，稍后重新启动APP即可在平台上看到崩溃日志" okHandler:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                int *pointer = (int *)0x01;
                *pointer = 6;
            });
        }];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)watchdogExceptionTrigger {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (TARGET_IPHONE_SIMULATOR) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"不支持的设备" message:@"WatchDog无法在模拟器触发，请使用真机进行测试" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        } else if (TARGET_OS_IPHONE) {
            UIAlertController *alert = [self alertWithTitle:@"WatchDog" message:@"即将触发WatchDog，APP将卡住一段时间后闪退，稍后重新启动APP即可在平台上看到崩溃日志" okHandler:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    dispatch_queue_t testWatchDogQueue = dispatch_queue_create("com.apminsight.testwatchdog", 0);
                    static pthread_mutex_t lock1;
                    pthread_mutex_init(&lock1, NULL);
                    static pthread_mutex_t lock2;
                    pthread_mutex_init(&lock2, NULL);
                        dispatch_async(testWatchDogQueue, ^{
                            while (1) {
                                pthread_mutex_lock(&lock1);
                                // do something
                                pthread_mutex_lock(&lock2);
                                // do something
                                pthread_mutex_unlock(&lock1);
                                // do something
                                pthread_mutex_unlock(&lock2);
                            }
                        });
                        dispatch_async(dispatch_get_main_queue(), ^{
                            while (1) {
                                pthread_mutex_lock(&lock2);
                                // do something
                                pthread_mutex_lock(&lock1);
                                // do something
                                pthread_mutex_unlock(&lock2);
                                // do something
                                pthread_mutex_unlock(&lock1);
                            }
                        });
                });
            }];
            [self presentViewController:alert animated:YES completion:nil];
        }
    });
}

- (void)OOMExceptionTrigger {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (TARGET_IPHONE_SIMULATOR) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"不支持的设备" message:@"OOM无法在模拟器触发，请使用真机进行测试" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        } else if (TARGET_OS_IPHONE) {
            UIAlertController *alert = [self alertWithTitle:@"Out of Memory" message:@"即将触发OOM，APP将闪退，稍后重新启动APP即可在平台上看到崩溃日志" okHandler:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    while (1) {
                        CGSize size = CGSizeMake(1024 * 8, 1024 * 8 * 9.0f/16.0);
                        const size_t bitsPerComponent = 8;
                        const size_t bytesPerRow = size.width * 4;
                        CGContextRef ctx = CGBitmapContextCreate(calloc(sizeof(unsigned char), bytesPerRow * size.height), size.width, size.height,
                                                                 bitsPerComponent, bytesPerRow,
                                                                 CGColorSpaceCreateDeviceRGB(),
                                                                 kCGImageAlphaPremultipliedLast);
                        CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1.0);
                        CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));
                    }
                });
            }];
            [self presentViewController:alert animated:YES completion:nil];
        }
    });
}

- (void)GWPASanPageTrigger {
    APMInsightGWPASanViewController *GWPASanVC = [[APMInsightGWPASanViewController alloc] init];
    [self.navigationController pushViewController:GWPASanVC animated:YES];
}

- (void)coredumpPageTrigger {
    APMInsightCoredumpViewController *coredumpVC = [[APMInsightCoredumpViewController alloc] init];
    [self.navigationController pushViewController:coredumpVC animated:YES];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"APMInsightCrashCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
    self.title = @"崩溃分析";
    // Do any additional setup after loading the view.
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
        void(^NSExceptionBlock)(void) = ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf NSExceptionTrigger];
            }
        };
        APMInsightCellItem *NSExceptionItem = [APMInsightCellItem itemWithTitle:@"触发NSException类型崩溃" block:NSExceptionBlock];
        
        void(^cppExceptionBlock)(void) = ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf CPPExceptionTrigger];
            }
        };
        APMInsightCellItem *cppExceptionItem = [APMInsightCellItem itemWithTitle:@"Hightlights -- 触发CPP类型崩溃" block:cppExceptionBlock];
        
        void(^machExceptionBlock)(void) = ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf machExceptionTrigger];
            }
        };
        APMInsightCellItem *machExceptionItem = [APMInsightCellItem itemWithTitle:@"触发Mach(EXC_BAD_ACCESS)类型崩溃" block:machExceptionBlock];
        
        void(^fatalSignalBlock)(void) = ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf signalExceptionTrigger];
            }
        };
        APMInsightCellItem *fatalSignalItem = [APMInsightCellItem itemWithTitle:@"触发SIGNAL类型崩溃" block:fatalSignalBlock];
        
        void(^watchDogBlock)(void) = ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf watchdogExceptionTrigger];
            }
        };
        APMInsightCellItem *watchDogItem = [APMInsightCellItem itemWithTitle:@"Highlights -- 触发卡死" block:watchDogBlock];
        
        void(^OOMBlock)(void) = ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [self OOMExceptionTrigger];
            }
        };
        APMInsightCellItem *OOMItem = [APMInsightCellItem itemWithTitle:@"触发OOM" block:OOMBlock];
        
        void(^AsyncBlock)(void) = ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [self AsyncExceptionTigger];
            }
        };
        APMInsightCellItem *AsyncItem = [APMInsightCellItem itemWithTitle:@"Highlights -- 触发AsyncException" block:AsyncBlock];
        
        void(^GWPASanPageBlock)(void) = ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf GWPASanPageTrigger];
            }
        };
        APMInsightCellItem *GWPASanPageItem = [APMInsightCellItem itemWithTitle:@"GWPASan相关功能测试" block:GWPASanPageBlock];
        
        void(^coredumpPageBlock)(void) = ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf coredumpPageTrigger];
            }
        };
        APMInsightCellItem *coredumpPageItem = [APMInsightCellItem itemWithTitle:@"Coredump相关功能测试" block:coredumpPageBlock];

        [_items addObject:NSExceptionItem];
        [_items addObject:cppExceptionItem];
        [_items addObject:machExceptionItem];
        [_items addObject:fatalSignalItem];
        [_items addObject:watchDogItem];
        [_items addObject:OOMItem];
        [_items addObject:AsyncItem];
        [_items addObject:GWPASanPageItem];
        [_items addObject:coredumpPageItem];
    }
    
    return _items;
}

#pragma mark - Tools

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
