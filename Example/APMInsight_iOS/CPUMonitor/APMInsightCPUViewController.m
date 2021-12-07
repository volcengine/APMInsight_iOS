//
//  APMInsightCPUViewController.m
//  APMInsight_iOS
//
//  Created by xuminghao.eric on 2021/12/6.
//

#import "APMInsightCPUViewController.h"
#import "APMInsightCellItem.h"
#include <sys/sysctl.h>

unsigned int countOfCPUCores(void) {
    unsigned int cpuCount;
    size_t len = sizeof(cpuCount);
    if(sysctlbyname("hw.ncpu", &cpuCount, &len, NULL, 0) != 0) { // 系统调用失败，返回1
        return 1;
    }

    return cpuCount;
}


@interface APMInsightCPUViewController ()

@end

@implementation APMInsightCPUViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellIdentifier = @"APMInsightCPUCell";
        self.vcTitle = @"CPU监控";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupItems {
    APMInsightCellItem *item = [[APMInsightCellItem alloc] init];
    item.title = @"触发CPU异常";
    item.selectBlock = ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"触发CPU异常" message:@"触发CPU异常后，等待1~2分钟之后退出APP，然后重新启动，即可上报CPU异常日志" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            int queueCount = countOfCPUCores();
            for (int i = 0; i < queueCount; i++) {
                NSString *queueName = [NSString stringWithFormat:@"com.apminsight.testcpu%d",i];
                dispatch_queue_t queue = dispatch_queue_create([queueName UTF8String], DISPATCH_QUEUE_SERIAL);
                dispatch_async(queue, ^{
                    int sum = 0;
                    while (1) {
                        sum++;
                    }
                });
            }
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:ok];
        [alert addAction:cancel];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alert animated:YES completion:nil];
        });
    };
    [self.items addObject:item];
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
