//
//  BDAutoTrackConfig+RangersAPMForSDK.h
//  Pods
//
//  Created by who on 2020/5/18.
//

#import "BDAutoTrackConfig.h"
#import "RangersAPMAddressConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface BDAutoTrackConfig (RangersAPMForSDK)

/*! @abstract AppID，非空，必须设置 */
@property (nonatomic, copy) NSString *sdkAid;

/*! @abstract hostAppID，宿主appID */
@property (nonatomic, copy) NSString *hostAppID;

/*! @abstract sdkVersion，sdk版本号*/
@property (nonatomic, copy) NSString *sdkVersion;

/*! @abstract addressConfig，非空，必须设置 */
@property (nonatomic, strong) RangersAPMAddressConfig *addressConfig;

@end

NS_ASSUME_NONNULL_END
