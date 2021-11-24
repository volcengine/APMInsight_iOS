//
//  APMInsightProtectorViewController.m
//  APMInsight_iOS
//
//  Created by bytedance on 2021/9/30.
//

#import "APMInsightProtectorViewController.h"
#import "APMInsightCellItem.h"
#import "APMInsightProtectorObject.h"
#include <objc/message.h>

@interface APMInsightProtectorViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSMutableArray *items;

@end

@implementation APMInsightProtectorViewController

#pragma mark - Test cases
- (void)USELProblemTrigger {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [self alertWithTitle:@"Container Problem" message:@"5秒后触发Urecognized Selector类型问题，若APP闪退，请检测安全气垫开关是否开启" okHandler:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // objc_msgSend
                SEL aSEL = sel_registerName("TEST_INVALID_SELECTOR");
                ((void (*)(Class, SEL))objc_msgSend)(NSObject.class, aSEL);
                
                // performSelector
                UIWebView *web = [UIWebView new];
                [web performSelector:@selector(cut:)];
            });
        }];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)ContainerProblemTrigger {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [self alertWithTitle:@"Container Problem" message:@"5秒后触发容器类型问题，若APP闪退，请检测安全气垫开关是否开启" okHandler:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // Array
                NSMutableArray *array = [@[@"A", @"B", @"C"] mutableCopy];
                [array addObject:nil];
                [array removeObject:nil];
                
                [array removeObjectAtIndex:3];
                
                // Dictionary
                NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                [dictionary setObject:nil forKey:@"NIL-KEY"];
                [dictionary removeObjectForKey:nil];
                
                // Set
                NSMutableSet *set = [NSMutableSet setWithObjects:@"1", @"2", nil];
                [set addObject:nil];
            });
        }];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)KVCProblemTrigger {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [self alertWithTitle:@"KVC Problem" message:@"5秒后触发KVC类型问题，若APP闪退，请检测安全气垫开关是否开启" okHandler:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                APMInsightProtectorObject *object = [APMInsightProtectorObject new];
                [object setValue:nil forKey:nil];
                [object setValue:nil forKeyPath:nil];
                [object setValue:nil forUndefinedKey:nil];
                
                [object valueForKey:nil];
            });
        }];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)KVOProblemTrigger {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [self alertWithTitle:@"KVO Problem" message:@"5秒后触发KVO类型问题，若APP闪退，请检测安全气垫开关是否开启" okHandler:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                APMInsightProtectorObject *aObject = [APMInsightProtectorObject new];
                
                @autoreleasepool {
                    APMInsightProtectorObject *bObject = [APMInsightProtectorObject new];
                    [aObject addObserver:bObject forKeyPath:@"number" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:0];
                    [aObject addObserver:bObject forKeyPath:@"subview.frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:0];
                    bObject = nil;
                }
                
                aObject.number = @(1);
                aObject.subview.frame = CGRectMake(0, 0, 100, 100);
            });
        }];
        [self presentViewController:alert animated:YES completion:nil];
    });
                
}

- (void)NSUserDefaultsProblemTrigger {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [self alertWithTitle:@"NSUserDefaults Problem" message:@"5秒后触发NSUserDefaults类型问题，若APP闪退，请检测安全气垫开关是否开启" okHandler:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud setBool:nil forKey:[NSObject new]];
                [ud boolForKey:[NSObject new]];
            });
        }];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"APMInsightProtectorCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
    self.title = @"异常防护 - 崩溃防护分析";
}

#pragma mark UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"APMInsightProtectorCell"];
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
        void(^USELProblemBlock)(void) = ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf USELProblemTrigger];
            }
        };
        APMInsightCellItem *USELProblemItem = [APMInsightCellItem itemWithTitle:@"Urecognized Selector类型问题" block:USELProblemBlock];
        
        void(^ContainerProblemBlock)(void) = ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf ContainerProblemTrigger];
            }
        };
        APMInsightCellItem *ContainerProblemItem = [APMInsightCellItem itemWithTitle:@"触发容器类型问题" block:ContainerProblemBlock];
        
        void(^KVCProblemBlock)(void) = ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf KVCProblemTrigger];
            }
        };
        APMInsightCellItem *KVCProblemItem = [APMInsightCellItem itemWithTitle:@"触发KVC类型问题" block:KVCProblemBlock];
        
        void(^KVOProblemBlock)(void) = ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf KVOProblemTrigger];
            }
        };
        APMInsightCellItem *KVOProblemItem = [APMInsightCellItem itemWithTitle:@"触发KVO类型问题" block:KVOProblemBlock];
        
        void(^NSUserDefaultsProblemBlock)(void) = ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf NSUserDefaultsProblemTrigger];
            }
        };
        APMInsightCellItem *NSUserDefaultsProblemItem = [APMInsightCellItem itemWithTitle:@"触发NSUserDefaults类型问题" block:NSUserDefaultsProblemBlock];
        
        [_items addObject:USELProblemItem];
        [_items addObject:ContainerProblemItem];
        [_items addObject:KVCProblemItem];
        [_items addObject:KVOProblemItem];
        [_items addObject:NSUserDefaultsProblemItem];
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
