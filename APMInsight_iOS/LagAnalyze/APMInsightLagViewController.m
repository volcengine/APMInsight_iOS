//
//  APMInsightLagViewController.m
//  APMInsight_iOS
//
//  Created by xuminghao.eric on 2020/11/12.
//

#import "APMInsightLagViewController.h"
#import "APMInsightCellItem.h"

static NSString *const kUserLagPlaceholder = @"卡顿时长，单位s";

@interface APMInsightLagViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSMutableArray *items;

@end

@implementation APMInsightLagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"APMInsightLagCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
    self.title = @"卡顿分析";
    // Do any additional setup after loading the view.
}

#pragma mark UITableViewDelegate, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"APMInsightLagCell"];
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
        
        void(^userLagBlock)(void) = ^{
            __strong typeof(self) strongSelf = weakSelf;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"自定义卡顿" message:@"输入卡顿时长，点击确定将在5s后触发卡顿，如果不输入则默认卡顿3s。注意：相同的卡顿场景只会上报一次" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSInteger lagTime = 0;
                for (UITextField *textFiled in alert.textFields) {
                    if ([textFiled.placeholder isEqualToString:kUserLagPlaceholder]) {
                        lagTime = [textFiled.text integerValue] ?: 3;
                        break;
                    }
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    sleep((unsigned int)lagTime);
                });
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:ok];
            [alert addAction:cancel];
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = kUserLagPlaceholder;
            }];
            [strongSelf presentViewController:alert animated:YES completion:nil];
        };
        APMInsightCellItem *userLagItem = [APMInsightCellItem itemWithTitle:@"触发自定义时长卡顿" block:userLagBlock];
        
        [_items addObject:userLagItem];
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
