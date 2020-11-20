//
//  APMInsightCrashViewController.m
//  APMInsight_iOS
//
//  Created by xuminghao.eric on 2020/11/12.
//

#import "APMInsightCrashViewController.h"
#import "APMInsightCellItem.h"

@interface APMInsightCrashViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSMutableArray *items;

@end

@implementation APMInsightCrashViewController

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

#pragma mark UITableViewDelegate, UITableViewDelegate
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
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    UIAlertController *alert = [self alertWithTitle:@"NSException" message:@"即将触发NSException类型崩溃，APP将闪退，稍后重新启动APP即可在平台上看到崩溃日志" okHandler:^{
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            NSException *exception = [NSException exceptionWithName:@"TEST_EXCEPTION" reason:@"APMInsight is testing NSException" userInfo:nil];
                            [exception raise];
                        });
                    }];
                    [strongSelf presentViewController:alert animated:YES completion:nil];
                }
            });
        };
        APMInsightCellItem *NSExceptionItem = [APMInsightCellItem itemWithTitle:@"触发NSException类型崩溃" block:NSExceptionBlock];
        
        void(^cppExceptionBlock)(void) = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    UIAlertController *alert = [self alertWithTitle:@"CPPException" message:@"即将触发CPP类型崩溃，APP将闪退，稍后重新启动APP即可在平台上看到崩溃日志" okHandler:^{
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            throw 0;
                        });
                    }];
                    [strongSelf presentViewController:alert animated:YES completion:nil];
                }
            });
        };
        APMInsightCellItem *cppExceptionItem = [APMInsightCellItem itemWithTitle:@"触发CPP类型崩溃" block:cppExceptionBlock];
        
        void(^machExceptionBlock)(void) = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    UIAlertController *alert = [self alertWithTitle:@"MachException" message:@"即将触发Mach类型崩溃，APP将闪退，稍后重新启动APP即可在平台上看到崩溃日志" okHandler:^{
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            int *pointer = (int *)0x01;
                            *pointer = 6;
                        });
                    }];
                    [strongSelf presentViewController:alert animated:YES completion:nil];
                }
            });
        };
        APMInsightCellItem *machExceptionItem = [APMInsightCellItem itemWithTitle:@"触发Mach(EXC_BAD_ACCESS)类型崩溃" block:machExceptionBlock];
        
        void(^fatalSignalBlock)(void) = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    UIAlertController *alert = [self alertWithTitle:@"SignalException" message:@"即将触发Signal类型崩溃，APP将闪退，稍后重新启动APP即可在平台上看到崩溃日志" okHandler:^{
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            raise(SIGABRT);
                        });
                    }];
                    [strongSelf presentViewController:alert animated:YES completion:nil];
                }
            });
        };
        APMInsightCellItem *fatalSignalItem = [APMInsightCellItem itemWithTitle:@"触发SIGNAL类型崩溃" block:fatalSignalBlock];
        
        void(^watchDogBlock)(void) = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    if (TARGET_IPHONE_SIMULATOR) {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"不支持的设备" message:@"WatchDog无法在模拟器触发，请使用真机进行测试" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                        [alert addAction:action];
                        [strongSelf presentViewController:alert animated:YES completion:nil];
                    } else if (TARGET_OS_IPHONE) {
                        UIAlertController *alert = [self alertWithTitle:@"WatchDog" message:@"即将触发WatchDog，APP将卡住一段时间后闪退，稍后重新启动APP即可在平台上看到崩溃日志" okHandler:^{
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                dispatch_queue_t testWatchDogQueue = dispatch_queue_create("com.apminsight.testwatchdog", 0);
                                dispatch_async(testWatchDogQueue, ^{
                                    dispatch_sync(dispatch_get_main_queue(), ^{
                                        dispatch_sync(testWatchDogQueue, ^{
                                            
                                        });
                                    });
                                });
                            });
                        }];
                        [strongSelf presentViewController:alert animated:YES completion:nil];
                    }
                }
            });
        };
        APMInsightCellItem *watchDogItem = [APMInsightCellItem itemWithTitle:@"触发卡死" block:watchDogBlock];
        
        void(^OOMBlock)(void) = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    if (TARGET_IPHONE_SIMULATOR) {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"不支持的设备" message:@"OOM无法在模拟器触发，请使用真机进行测试" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                        [alert addAction:action];
                        [strongSelf presentViewController:alert animated:YES completion:nil];
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
                        [strongSelf presentViewController:alert animated:YES completion:nil];
                    }
                }
            });
        };
        APMInsightCellItem *OOMItem = [APMInsightCellItem itemWithTitle:@"触发OOM" block:OOMBlock];
        
        [_items addObject:NSExceptionItem];
        [_items addObject:cppExceptionItem];
        [_items addObject:machExceptionItem];
        [_items addObject:fatalSignalItem];
        [_items addObject:watchDogItem];
        [_items addObject:OOMItem];
    }
    
    return _items;
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
