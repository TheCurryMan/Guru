//
//  TVIVideoTrackStats.h
//  TwilioVideo
//
//  Copyright © 2017 Twilio, Inc. All rights reserved.
//

#import "TVITrackStats.h"
#import <CoreMedia/CoreMedia.h>

/**
 * `TVIVideoTrackStats` represents stats about a remote video track.
 */
@interface TVIVideoTrackStats : TVITrackStats

/**
 * @brief Received frame dimensions. 
 */
@property (nonatomic, assign, readonly) CMVideoDimensions dimensions;

/**
 * @brief Received frame rate.
 */
@property (nonatomic, assign, readonly) NSUInteger frameRate;

/**
 *  @brief Developers shouldn't initialize this class directly.
 *
 *  @discussion Video track stats cannot be created explicitly.
 */
- (null_unspecified instancetype)init __attribute__((unavailable("TVIVideoTrackStats cannot be created explicitly.")));

@end
