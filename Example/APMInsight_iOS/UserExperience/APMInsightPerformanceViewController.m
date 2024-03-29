//
//  APMInsightPerformanceViewController.m
//  APMInsight_iOS
//
//  Created by xuminghao.eric on 2020/11/12.
//

#import "APMInsightPerformanceViewController.h"
#import "APMInsightCellItem.h"

@interface APMInsightPerformanceViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSMutableArray *items;

@end

@implementation APMInsightPerformanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"APMInsightPerformanceCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIView *footerView = [[UIView alloc] init];
    
    UILabel *footerViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.view.frame.size.width - 40, 0)];
    footerViewLabel.text = @"用户体验产生的日志，在APP启动之后会触发一次上报，之后每两分钟或者APP退到后台时上报一次，如果需要立即上报查看数据，可以尝试把APP切换到后台来触发上报";
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
    
    self.title = @"用户体验";
    // Do any additional setup after loading the view.
}

#pragma mark UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"APMInsightPerformanceCell"];
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
- (NSMutableArray *)items
{
    if (!_items) {
        _items = [[NSMutableArray alloc] init];
        
        __weak typeof(self) weakSelf = self;
        void(^startBlock)(void) = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"启动分析" message:@"冷启动日志在APP启动时自动记录，如果需要测试热启动，可以把APP进行前后台切换来产生日志" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:ok];
                    [strongSelf presentViewController:alert animated:YES completion:nil];
                }
            });
        };
        APMInsightCellItem *startItem = [APMInsightCellItem itemWithTitle:@"启动分析" block:startBlock];
        
        void(^pageLoadBlock)(void) = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"页面响应" message:@"页面响应日志在页面切换时自动记录，可以尝试在不同的ViewController之间切换来产生日志" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:ok];
                    [strongSelf presentViewController:alert animated:YES completion:nil];
                }
            });
        };
        APMInsightCellItem *pageLoadItem = [APMInsightCellItem itemWithTitle:@"页面响应" block:pageLoadBlock];
        
        void(^fpsBlock)(void) = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"FPS" message:@"FPS日志在页面切换或滑动时自动记录，可以尝试在不同的ViewController之间切换或滑动View来产生日志" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:ok];
                    [strongSelf presentViewController:alert animated:YES completion:nil];
                }
            });
        };
        APMInsightCellItem *fpsItem = [APMInsightCellItem itemWithTitle:@"流畅性和丢帧分析" block:fpsBlock];
        
        [_items addObject:startItem];
        [_items addObject:pageLoadItem];
        [_items addObject:fpsItem];
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
