//
//  BDAutoTrackConfig+RangersAPM.h
//  HeimdallrFinder
//
//  Created by xuminghao.eric on 2020/4/27.
//


#import "BDAutoTrackConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface BDAutoTrackConfig (RangersAPM)

/*! @abstract channel, 非空，必须设置*/
@property (nonatomic, copy) NSString *channel;

/*! @abstract AppID，非空，必须设置 */
@property (nonatomic, copy) NSString *appID;

@end

NS_ASSUME_NONNULL_END
