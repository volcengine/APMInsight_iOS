//
//  RangersCrashTrackerRestrict.h
//  Pods
//
//  Created by who on 2020/5/18.
//

#import <Foundation/Foundation.h>
#import "RangersAddressRange.h"

NS_ASSUME_NONNULL_BEGIN

@interface RangersAPMAddressConfig : NSObject

@property (nonatomic, copy, readonly) NSArray<RangersAddressRange *> * adressRanges;

+ (instancetype)configWithAddressRanges:(NSArray<RangersAddressRange *> *)adressRanges;

@end

NS_ASSUME_NONNULL_END
