//
//  APMInsightGWPASanViewController.m
//  APMInsight_iOS
//
//  Created by ByteDance on 2023/2/22.
//

#import "APMInsightGWPASanViewController.h"
#import "APMInsightCellItem.h"

bool __attribute__((noinline)) __attribute__((weak)) pointerInGWPASan(const void *Ptr) {
    assert(false && "Please add GWPASan subspec in Podfile.");
    
    return YES;
}

#define kMallocSize (13)
static char *g_default_char = "Volcengine Volcengine Volcengine Volcengine Volcengine Volcengine Volcengine";

@interface APMInsightGWPASanViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSMutableArray *items;

@end

@implementation APMInsightGWPASanViewController

#pragma mark - Test cases
char *g_heap_buffer_overflow_str = NULL;

- (void)prepareHeapBufferOverflow {
    for (int i = 0; i < 1000000; i++) {
        char *heap_buffer_overflow_str = (char *)malloc(kMallocSize);
        memset(heap_buffer_overflow_str, '\0', kMallocSize);
        
        if (pointerInGWPASan(heap_buffer_overflow_str)) {
            g_heap_buffer_overflow_str = heap_buffer_overflow_str;
            
            UIAlertController *alertVC = [self alertWithTitle:@"提示" message:@"Heap Buffer Overflow环境已经准备好了，可以开始测试"];
            [self presentViewController:alertVC animated:YES completion:nil];
            
            return;
        }
        
        free(heap_buffer_overflow_str);
    }
}

- (void)heapBufferOverflowTrigger {
    if (g_heap_buffer_overflow_str == NULL) {
        UIAlertController *alertVC = [self alertWithTitle:@"提示" message:@"请先执行\"准备Heap Buffer Overflow类型崩溃环境\""];
        [self presentViewController:alertVC animated:YES completion:nil];
        
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [self alertWithTitle:@"Heap Buffer OverFlow" message:@"尝试触发Heap Buffer Overflow类型崩溃" okHandler:^{
            
            strcpy(g_heap_buffer_overflow_str, g_default_char);
        }];
        [self presentViewController:alert animated:YES completion:nil];
    });
}


char *g_heap_buffer_underflow_str = NULL;
- (void)prepareHeapBufferUnderflow {
    for (int i = 0; i < 1000000; i++) {
        char *heap_buffer_underflow_str = (char *)malloc(kMallocSize);
        memset(heap_buffer_underflow_str, '\0', kMallocSize);
        if (pointerInGWPASan(heap_buffer_underflow_str)) {
            g_heap_buffer_underflow_str = heap_buffer_underflow_str;

            UIAlertController *alertVC = [self alertWithTitle:@"提示" message:@"Heap Buffer Underflow环境已经准备好了，可以开始测试"];
            [self presentViewController:alertVC animated:YES completion:nil];

            return;
        }
        free(heap_buffer_underflow_str);
    }
}

- (void)heapBufferUnderflowTrigger {
    if (g_heap_buffer_underflow_str == NULL) {
        UIAlertController *alertVC = [self alertWithTitle:@"提示" message:@"请先执行\"准备Heap Buffer Underflow类型崩溃环境\""];
        [self presentViewController:alertVC animated:YES completion:nil];

        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [self alertWithTitle:@"Heap Buffer Underflow" message:@"尝试触发Heap Buffer Underflow类型崩溃" okHandler:^{
            char *pointer = g_heap_buffer_underflow_str - sizeof(char) * 8;

            strcpy(pointer, g_default_char);

        }];
        [self presentViewController:alert animated:YES completion:nil];
    });
}


char *g_double_free_str = NULL;
- (void)prepareDoubleFree {
    for (int i = 0; i < 1000000; i++) {
        char *double_free_str = (char *)malloc(kMallocSize);
        memset(double_free_str, '\0', kMallocSize);
        if (pointerInGWPASan(double_free_str)) {
            g_double_free_str = double_free_str;
            free(double_free_str);

            UIAlertController *alertVC = [self alertWithTitle:@"提示" message:@"Double Free环境已经准备好了，可以开始测试"];
            [self presentViewController:alertVC animated:YES completion:nil];

            return;
        }
        free(double_free_str);
    }
}

- (void)doubleFreeTrigger {
    if (g_double_free_str == NULL) {
        UIAlertController *alertVC = [self alertWithTitle:@"提示" message:@"请先执行\"准备Double Free类型崩溃环境\""];
        [self presentViewController:alertVC animated:YES completion:nil];
        
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [self alertWithTitle:@"Double Free" message:@"尝试触发Double Free类型崩溃" okHandler:^{
            free(g_double_free_str);
        }];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

char *g_use_after_free_str = NULL;
- (void)prepareUseAfterFree {
    for (int i = 0; i < 1000000; i++) {
        char *use_after_free_str = (char *)malloc(kMallocSize);
        memset(use_after_free_str, '\0', kMallocSize);
        if (pointerInGWPASan(use_after_free_str)) {
            g_use_after_free_str = use_after_free_str;
            free(use_after_free_str);
            
            UIAlertController *alertVC = [self alertWithTitle:@"提示" message:@"Use After Free环境已经准备好了，可以开始测试"];
            [self presentViewController:alertVC animated:YES completion:nil];
            
            return;
        }
        free(use_after_free_str);
    }
}

- (void)useAfterFreeTrigger {
    if (g_use_after_free_str == NULL) {
        UIAlertController *alertVC = [self alertWithTitle:@"提示" message:@"请先执行\"准备Use After Free类型崩溃环境\""];
        [self presentViewController:alertVC animated:YES completion:nil];
        
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [self alertWithTitle:@"Use After Free" message:@"尝试触发Use After Free类型崩溃" okHandler:^{
            strcpy(g_use_after_free_str, g_default_char);
        }];
        [self presentViewController:alert animated:YES completion:nil];
    });
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"APMInsightCrashCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
    self.title = @"GWPASan相关功能测试";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
        void(^prepareHeapBufferOverflowBlock)(void) = ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf prepareHeapBufferOverflow];
            }
        };
        APMInsightCellItem *prepareHeapBufferOverflowItem = [APMInsightCellItem itemWithTitle:@"准备Heap Buffer Overflow类型崩溃环境" block:prepareHeapBufferOverflowBlock];
        
        void(^heapBufferOverflowBlock)(void) = ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf heapBufferOverflowTrigger];
            }
        };
        APMInsightCellItem *heapBufferOverflowItem = [APMInsightCellItem itemWithTitle:@"Heap Buffer Overflow类型崩溃" block:heapBufferOverflowBlock];
        
        
        void(^prepareHeapBufferUnderflowBlock)(void) = ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf prepareHeapBufferUnderflow];
            }
        };
        APMInsightCellItem *prepareHeapBufferUnderflowItem = [APMInsightCellItem itemWithTitle:@"准备Heap Buffer Underflow类型崩溃环境" block:prepareHeapBufferUnderflowBlock];

        void(^heapBufferUnderflowBlock)(void) = ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf heapBufferUnderflowTrigger];
            }
        };
        APMInsightCellItem *heapBufferUnderflowItem = [APMInsightCellItem itemWithTitle:@"Heap Buffer Underflow类型崩溃" block:heapBufferUnderflowBlock];


        void(^prepareDoubleFreeBlock)(void) = ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf prepareDoubleFree];
            }
        };
        APMInsightCellItem *prepareDoubleFreeItem = [APMInsightCellItem itemWithTitle:@"准备Double Free类型崩溃环境" block:prepareDoubleFreeBlock];

        void(^doubleFreeBlock)(void) = ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf doubleFreeTrigger];
            }
        };
        APMInsightCellItem *doubleFreeItem = [APMInsightCellItem itemWithTitle:@"Double Free类型崩溃" block:doubleFreeBlock];


        void(^prepareUseAfterFreeBlock)(void) = ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf prepareUseAfterFree];
            }
        };
        APMInsightCellItem *prepareUseAfterFreeItem = [APMInsightCellItem itemWithTitle:@"准备Use After Free类型崩溃环境" block:prepareUseAfterFreeBlock];

        void(^useAfterFreeBlock)(void) = ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf useAfterFreeTrigger];
            }
        };
        APMInsightCellItem *useAfterFreeItem = [APMInsightCellItem itemWithTitle:@"Use After Free类型崩溃" block:useAfterFreeBlock];
        
        [_items addObject:prepareHeapBufferOverflowItem];
        [_items addObject:heapBufferOverflowItem];
        
        [_items addObject:prepareHeapBufferUnderflowItem];
        [_items addObject:heapBufferUnderflowItem];

        [_items addObject:prepareDoubleFreeItem];
        [_items addObject:doubleFreeItem];

        [_items addObject:prepareUseAfterFreeItem];
        [_items addObject:useAfterFreeItem];
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

