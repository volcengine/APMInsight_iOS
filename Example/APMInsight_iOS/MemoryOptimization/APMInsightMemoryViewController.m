//
//  APMInsightMemoryViewController.m
//  APMInsight_iOS
//
//  Created by xuminghao.eric on 2020/11/12.
//

#import "APMInsightMemoryViewController.h"
#import "APMInsightCellItem.h"
#import <mach/mach.h>
#import "APMInsightCaptureUITestViewController.h"
#import "APMInsightLeakedObject.h"
#import "APMInsightAutoreleaseObject.h"

static float dangerousMemoryThreshold = 512.0;

bool overMemoryThreshold(void)
{
    kern_return_t kr;

    task_vm_info_data_t task_vm;
    mach_msg_type_number_t task_vm_count = TASK_VM_INFO_COUNT;
    kr = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &task_vm, &task_vm_count);

    if (kr == KERN_SUCCESS) {
        printf("APMInsight Debug Log : Current App Memory is :%f\n\n", task_vm.phys_footprint / (1024.0 * 1024.0));
        if (task_vm.phys_footprint / (1024.0 * 1024.0) > dangerousMemoryThreshold) {
            return true;
        } else {
            return false;
        }
    }

    return false;
}

@interface APMInsightMemoryViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSMutableArray *items;

@end

@implementation APMInsightMemoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"APMInsightMemoryCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
    self.title = @"内存优化";
    // Do any additional setup after loading the view.
}

#pragma mark UITableViewDelegate, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"APMInsightMemoryCell"];
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

#pragma mark - Lazy-load
- (NSMutableArray *)items {
    if (!_items) {
        _items = [[NSMutableArray alloc] init];
        
        __weak typeof(self) weakSelf = self;
        
        void(^memoryTriggerBlock)(void) = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"触发内存泄漏" message:@"点击确定开始触发内存泄漏，当APP占用内存超过512MB时会触发内存分析，在某些情况下，可能APP内存没有达到512MB就被系统KILL，如果未收到内存分析成功提示（大概5s之后），请重新启动APP触发泄漏。" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        while (1) {
                            if (!overMemoryThreshold()) {
                                CGSize size = CGSizeMake(1024 * 8, 1024 * 8 * 9.0f/16.0);
                                const size_t bitsPerComponent = 8;
                                const size_t bytesPerRow = size.width * 4;
                                CGContextRef ctx = CGBitmapContextCreate(calloc(sizeof(unsigned char), bytesPerRow * size.height), size.width, size.height, bitsPerComponent, bytesPerRow, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaPremultipliedLast);
                                CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1.0);
                                CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));
                            } else {
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:@"内存分析完成" message:@"请重新启动APP，然后APP会自动上报内存日志，由于存在采样，可能需要多次启动才可成功上报，具体可以查看帮助文档。" preferredStyle:UIAlertControllerStyleAlert];
                                    UIAlertAction *okk = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                                    [successAlert addAction:okk];
                                    [strongSelf presentViewController:successAlert animated:YES completion:nil];
                                });
                                break;
                            }
                        }
                    }];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:ok];
                    [alert addAction:cancel];
                    [strongSelf presentViewController:alert animated:YES completion:nil];
                });
            }
        };
        APMInsightCellItem *memoryTriggerItem = [APMInsightCellItem itemWithTitle:@"测试内存优化（泄漏、大对象、单设备查询）" block:memoryTriggerBlock];
        
        [_items addObject:memoryTriggerItem];
        
        void(^captureUITestBlock)(void) = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                APMInsightCaptureUITestViewController *captureUITest = [[APMInsightCaptureUITestViewController alloc] initWithNibName:@"APMInsightCaptureUITestViewController" bundle:nil];
                [strongSelf.navigationController pushViewController:captureUITest animated:YES];
            }
        };
        APMInsightCellItem *captureUITestItem = [APMInsightCellItem itemWithTitle:@"视图层级" block:captureUITestBlock];
        [_items addObject:captureUITestItem];
        
        
        void(^leakedTriggerBlock)(void) = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"触发内存泄漏" message:@"点击确定开始触发Leaked类型OOM崩溃，APP将闪退，稍后重新启动APP即可在平台上看到崩溃日志" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        for (int index = 0; index < 500; index++) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
                            APMInsightLeakedObject *leakedObject = [[APMInsightLeakedObject alloc] initWithName:[NSString stringWithFormat:@"APMInsightLeakedObject index = %d", index]];
#pragma clang diagnostic pop
                            
                            if (0 != index && 0 == index % 100) {
                                sleep(1);
                            }
                        }
                    }];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:ok];
                    [alert addAction:cancel];
                    [strongSelf presentViewController:alert animated:YES completion:nil];
                });
            }
        };
        APMInsightCellItem *leakedTriggerItem = [APMInsightCellItem itemWithTitle:@"内存泄露问题" block:leakedTriggerBlock];
        
        [_items addObject:leakedTriggerItem];
        
        
        void(^autoreleaseTriggerBlock)(void) = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"触发内存问题" message:@"点击确定开始触发AutoreleasePool类型OOM崩溃，APP将闪退，稍后重新启动APP即可在平台上看到崩溃日志" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        for (int index = 0; index < 500; index++) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
                            __autoreleasing APMInsightAutoreleaseObject *autoreleaseObject = [[APMInsightAutoreleaseObject alloc] initWithName:[NSString stringWithFormat:@"APMInsightAutoreleaseObject index %d", index]];
#pragma clang diagnostic pop
                            
                            if (0 != index && 0 == index % 100) {
                                sleep(1);
                            }
                        }
                    }];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:ok];
                    [alert addAction:cancel];
                    [strongSelf presentViewController:alert animated:YES completion:nil];
                });
            }
        };
        APMInsightCellItem *autoreleaseTriggerItem = [APMInsightCellItem itemWithTitle:@"自动释放池问题" block:autoreleaseTriggerBlock];
        
        [_items addObject:autoreleaseTriggerItem];
    }
    return _items;
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
