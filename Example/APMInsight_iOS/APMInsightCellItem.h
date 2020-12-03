//
//  APMInsightCellItem.h
//  APMInsight_iOS
//
//  Created by xuminghao.eric on 2020/11/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APMInsightCellItem : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) dispatch_block_t selectBlock;

+ (instancetype)itemWithTitle:(NSString *)title block:(dispatch_block_t)block;

@end

NS_ASSUME_NONNULL_END
