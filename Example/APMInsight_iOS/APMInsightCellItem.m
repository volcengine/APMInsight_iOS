//
//  APMInsightCellItem.m
//  APMInsight_iOS
//
//  Created by xuminghao.eric on 2020/11/12.
//

#import "APMInsightCellItem.h"

@implementation APMInsightCellItem

+ (instancetype)itemWithTitle:(NSString *)title block:(dispatch_block_t)block
{
    APMInsightCellItem *item = [[APMInsightCellItem alloc] init];
    item.title = title;
    item.selectBlock = block;
    return item;
}

@end
