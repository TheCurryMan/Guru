//
//  TVITrackStats.h
//  TwilioVideo
//
//  Copyright © 2017 Twilio, Inc. All rights reserved.
//

#import "TVIBaseTrackStats.h"

/**
 * `TVITrackStats` represents stats common to remote tracks.
 */
@interface TVITrackStats : TVIBaseTrackStats

/**
 * @brief Total number of bytes received.
 */
@property (nonatomic, assign, readonly) int64_t bytesReceived;

/**
 * @brief Total number of packets received.
 */
@property (nonatomic, assign, readonly) NSUInteger packetsReceived;

/**
 *  @brief Developers shouldn't initialize this class directly.
 *
 *  @discussion Track stats cannot be created explicitly.
 */
- (null_unspecified instancetype)init __attribute__((unavailable("TVITrackStats cannot be created explicitly.")));

@end
