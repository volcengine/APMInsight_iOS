//
//  APMInsightEventViewController.m
//  APMInsight_iOS
//
//  Created by xuminghao.eric on 2021/2/28.
//

#import "APMInsightEventViewController.h"
#import "EventRecordManager.h"
#import "APMInsightCellItem.h"

static NSString *const kEventNamePlaceholder = @"EventName, Default:eventNameDemoTest";
static NSString *const kMetricKeyPlaceholder = @"MetricKey, Default:metricKeyDemoTest";
static NSString *const kMetricValuePlaceholder = @"MetricValue, Default:0";
static NSString *const kDimensionKeyPlaceholder = @"DimensionKey, Default:DimensionKeyDemoTest";
static NSString *const kDimensionValuePlaceholder = @"DimensionValue, Default:DimensionValueDemoTest";

@interface APMInsightEventViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSMutableArray *items;

@end

@implementation APMInsightEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"APMInsightEventCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIView *footerView = [[UIView alloc] init];
    
    UILabel *footerViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.view.frame.size.width - 40, 0)];
    footerViewLabel.text = @"事件分析的日志，在APP启动之后会触发一次上报，之后每两分钟或者APP退到后台时上报一次，如果需要立即上报查看数据，可以尝试把APP切换到后台来触发上报";
    footerViewLabel.textColor = [UIColor grayColor];
    footerViewLabel.lineBreakMode = NSLineBreakByWordWrapping;
    footerViewLabel.numberOfLines = 0;
    footerViewLabel.font = [UIFont systemFontOfSize:13];
    [footerViewLabel sizeToFit];
    
    CGFloat height = footerViewLabel.frame.size.height;
    [footerView setFrame:CGRectMake(0, 0, 0, height)];
    [footerView addSubview:footerViewLabel];
    
    self.tableView.tableFooterView = footerView;

    [self.view addSubview:self.tableView];
    
    self.title = @"事件分析";
}

#pragma mark UITableViewDelegate, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"APMInsightEventCell"];
    if (indexPath.row < self.items.count) {
        APMInsightCellItem *item = [self.items objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",item.title];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.items.count) {
        APMInsightCellItem *item = [self.items objectAtIndex:indexPath.row];
        if (item.selectBlock) {
            item.selectBlock();
        }
    }
}

#pragma mark Lazy-load
- (NSMutableArray *)items {
    if (!_items) {
        _items = [[NSMutableArray alloc] init];
        
        __weak typeof(self) weakSelf = self;
        
        void(^customEventBlock)(void) = ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"自定义事件" message:@"⚠️只有在平台事件管理配置开启的事件才能成功记录" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"记录事件" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSString *eventName = @"eventNameDemoTest";
                    NSString *metricKey = @"metricKeyDemoTest";
                    NSNumber *metricValue = @(0);
                    NSString *dimensionKey = @"dimensionKeyDemoTest";
                    NSString *dimensionValue = @"dimensionValueDemoTest";
                    for (UITextField *textField in alert.textFields) {
                        NSString *placeholder = textField.placeholder;
                        NSString *text = textField.text;
                        if ([placeholder isEqualToString:kEventNamePlaceholder]) {
                            eventName = text.length > 0 ? text : eventName;
                        } else if ([placeholder isEqualToString:kMetricKeyPlaceholder]) {
                            metricKey = text.length > 0 ? text : metricKey;
                        } else if ([placeholder isEqualToString:kMetricValuePlaceholder]) {
                            metricValue = text.length > 0 ? @([text integerValue]) : metricValue;
                        } else if ([placeholder isEqualToString:kDimensionKeyPlaceholder]) {
                            dimensionKey = text.length > 0 ? text : dimensionKey;
                        } else if ([placeholder isEqualToString:kDimensionValuePlaceholder]) {
                            dimensionValue = text.length > 0 ? text : dimensionValue;
                        }
                    }
                    [EventRecordManager recordEvent:eventName metrics:@{metricKey:metricValue} dimension:@{dimensionKey:dimensionValue} extraValue:nil];
                }];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:ok];
                [alert addAction:cancel];
                [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = kEventNamePlaceholder;
                }];
                [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = kMetricKeyPlaceholder;
                }];
                [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = kMetricValuePlaceholder;
                }];
                [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = kDimensionKeyPlaceholder;
                }];
                [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = kDimensionValuePlaceholder;
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf presentViewController:alert animated:YES completion:nil];
                });
            }
        };
        APMInsightCellItem *customEventItem = [APMInsightCellItem itemWithTitle:@"记录一条自定义事件" block:customEventBlock];
        
        [_items addObject:customEventItem];
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
