//
//  TVIAudioTrackStats.h
//  TwilioVideo
//
//  Copyright © 2017 Twilio, Inc. All rights reserved.
//

#import "TVITrackStats.h"

/**
 * `TVIAudioTrackStats` represents stats about a remote audio track.
 */
@interface TVIAudioTrackStats : TVITrackStats

/**
 * @brief Audio output level.
 */
@property (nonatomic, assign, readonly) NSUInteger audioLevel;

/**
 * @brief Packet jitter measured in milliseconds.
 */
@property (nonatomic, assign, readonly) NSUInteger jitter;

/**
 *  @brief Developers shouldn't initialize this class directly.
 *
 *  @discussion Audio track stats cannot be created explicitly.
 */
- (null_unspecified instancetype)init __attribute__((unavailable("TVIAudioTrackStats cannot be created explicitly.")));

@end
