//
//  TVIScreenCapturer.h
//  TwilioVideo
//
//  Copyright © 2016-2017 Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TVIVideoCapturer.h"

/**
 *  `TVIScreenCapturer` captures content from a `UIView`.
 */
@interface TVIScreenCapturer : NSObject <TVIVideoCapturer>

/**
 *  @brief Indicates that screen capture is active.
 */
@property (atomic, assign, readonly, getter = isCapturing) BOOL capturing;

/**
 *  @brief Constructs a `TVIScreenCapturer` with a `UIView`.
 *
 *  @param view The `UIView` to capture content from.
 *
 *  @return An instance of `TVIScreenCapturer` if creation was successful, and `nil` otherwise.
 *
 *  @discussion `TVIScreenCapturer` captures the contents of a single view at 1x scale.
 *  Because this class depends on UIKit and CoreGraphics to snapshot content it does not function
 *  if the application is backgrounded. This class will not respond to `TVIVideoConstraints`.
 *  Instead, it will use the dimensions of the view to determine its capture size.
 */
- (null_unspecified instancetype)initWithView:(nonnull UIView *)view;

- (null_unspecified instancetype)init __attribute__((unavailable("Initialize TVIScreenCapturer with a UIView.")));

@end
