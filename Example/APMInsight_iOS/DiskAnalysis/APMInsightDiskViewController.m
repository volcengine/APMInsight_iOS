//
//  APMInsightDiskViewController.m
//  APMInsight_iOS
//
//  Created by Jerry on 2022/10/13.
//

#import "APMInsightDiskViewController.h"

@interface APMInsightDiskViewController ()

@property (nonatomic, strong) UILabel *remarkLabel;

@end

@implementation APMInsightDiskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.remarkLabel];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

#pragma mark - Lazy Loading
- (UILabel *)remarkLabel {
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [_remarkLabel setTextAlignment:NSTextAlignmentCenter];
        [_remarkLabel setNumberOfLines:0];
        [_remarkLabel setFont:[UIFont systemFontOfSize:12]];
        
        [_remarkLabel setText:@"磁盘监控启动的情况下，她会在程序后台时，检索沙盒文件并上报。\n 详细配置文档：https://www.volcengine.com/docs/6431/126085#%E7%A3%81%E7%9B%98%E7%9B%91%E6%8E%A7"];
    }
    return _remarkLabel;
}

@end
