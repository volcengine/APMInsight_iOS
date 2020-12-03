//
//  RangersAddressRange.h
//  Pods
//
//  Created by who on 2020/5/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RangersAddressRange : NSObject

/**
 startAddress 直接传当前加载进去的函数地址就好了
 endAddress 直接传当前加载进去的函数地址就好了
 */
@property(nonatomic, assign)int64_t startAddress;
@property(nonatomic, assign)int64_t endAddress;

+ (instancetype)addressRangeWithStartAddress:(int64_t)startAddress endAddress:(int64_t)endAddress;

@end

NS_ASSUME_NONNULL_END
