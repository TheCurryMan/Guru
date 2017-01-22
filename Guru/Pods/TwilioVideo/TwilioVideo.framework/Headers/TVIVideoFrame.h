//
//  TVIVideoFrame.h
//  TwilioVideo
//
//  Copyright © 2016 Twilio Inc. All rights reserved.
//

#import <CoreVideo/CoreVideo.h>

/**
 *  Specifies the orientation of video content.
 */
typedef NS_ENUM(NSUInteger, TVIVideoOrientation) {
    /**
     *  The video is rotated 0 degrees, oriented with its top side up.
     */
    TVIVideoOrientationUp = 0,
    /**
     *  The video is rotated 90 degrees, oriented with its top side to the left.
     */
    TVIVideoOrientationLeft,
    /**
     *  The video is rotated 180 degrees, oriented with its top side to bottom.
     */
    TVIVideoOrientationDown,
    /**
     *  The video is rotated 270 degrees, oriented with its top side to the right.
     */
    TVIVideoOrientationRight,
};

/**
 *  @brief A helper which constructs an affine transform for any orientation.
 *
 *  @param orientation The orientation of the video you wish to display.
 *
 *  @return A `CGAffineTransform` struct which can be applied to a renderer's view.
 */
static inline CGAffineTransform TVIVideoOrientationMakeTransform(TVIVideoOrientation orientation)
{
    return CGAffineTransformMakeRotation((CGFloat)orientation * M_PI_2);
}

/**
 *  @brief A helper which indicates if the orientation would cause the native dimensions to be flipped.
 *
 *  @param orientation The orientation to check.
 *
 *  @return `YES` if the orientation would cause the dimensions to be flipped, and `NO` otherwise.
 */
static inline BOOL TVIVideoOrientationIsRotated(TVIVideoOrientation orientation)
{
    return (orientation == TVIVideoOrientationLeft ||
            orientation == TVIVideoOrientationRight);
}

/**
 *  A video frame which has been captured or decoded.
 *
 *  @discussion `TVIVideoFrame` represents a CoreVideo buffer, along with metadata important for rendering and encoding.
 */
@interface TVIVideoFrame : NSObject

- (null_unspecified instancetype)init __attribute__((unavailable("Create using initWithTimestamp:buffer:orientation instead.")));

/**
 *  @brief A video frame which has either been captured or decoded.
 *
 *  @param timestamp The timestamp at which this frame was captured, or decoded.
 *  @param imageBuffer A `CVImageBufferRef` which conforms to one of the pixel formats defined by `TVIPixelFormat`.
 *  @param orientation The orientation at which this frame was captured, or decoded.
 */
- (null_unspecified instancetype)initWithTimestamp:(int64_t)timestamp
                                            buffer:(nonnull CVImageBufferRef)imageBuffer
                                       orientation:(TVIVideoOrientation)orientation;
/**
 *  @brief The timestamp in microseconds at which this frame was captured, or should be rendered.
 *
 *  @discussion For decoded frames this is the display time measured using the system monotomic clock.
 *  For captured frames this should be the capture time measured using the timebase of the capturer.
 */
@property (nonatomic, assign, readonly) int64_t timestamp;

/**
 *  @brief A convenience getter which returns the width of `imageBuffer`.
 */
@property (nonatomic, assign, readonly) size_t width;

/**
 *  @brief A convenience getter which returns the height of `imageBuffer`.
 */
@property (nonatomic, assign, readonly) size_t height;

/**
 *  @brief A CVImageBuffer which contains the image data for the frame.
 */
@property (nonatomic, assign, readonly, nonnull) CVImageBufferRef imageBuffer;

/**
 *  @brief The orientation metadata for the frame.
 */
@property (nonatomic, assign, readonly) TVIVideoOrientation orientation;

@end
