//
//  TVICameraCapturer.h
//  TwilioVideo
//
//  Copyright © 2016-2017 Twilio, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>

#import "TVIVideoCapturer.h"

@class TVICameraPreviewView;

/**
 *  The smallest possible size, yielding a 1.22:1 aspect ratio useful for multi-party.
 */
extern CMVideoDimensions const TVIVideoConstraintsSize352x288;

/**
 *  Medium quality video in a 4:3 aspect ratio.
 */
extern CMVideoDimensions const TVIVideoConstraintsSize480x360;

/**
 *  High quality 640x480 video in a 4:3 aspect ratio.
 */
extern CMVideoDimensions const TVIVideoConstraintsSize640x480;

/**
 *  540p Quarter HD video in a 16:9 aspect ratio.
 */
extern CMVideoDimensions const TVIVideoConstraintsSize960x540;

/**
 *  720p HD video in a 16:9 aspect ratio.
 */
extern CMVideoDimensions const TVIVideoConstraintsSize1280x720;

/**
 *  HD quality 1280x960 video in a 4:3 aspect ratio.
 */
extern CMVideoDimensions const TVIVideoConstraintsSize1280x960;

/**
 *  Default 30fps video, giving a smooth video look.
 */
extern NSUInteger const TVIVideoConstraintsFrameRate30;

/**
 *  Cinematic 24 fps video. Not yet recommended for iOS recipients using `TVIVideoViewRenderer`, since it
 *  operates on a 60 Hz timer.
 */
extern NSUInteger const TVIVideoConstraintsFrameRate24;

/**
 *  @brief Battery efficient 20 fps video.
 */
extern NSUInteger const TVIVideoConstraintsFrameRate20;

/**
 *  Battery efficient 15 fps video. This setting can be useful if you prefer spatial to temporal resolution.
 */
extern NSUInteger const TVIVideoConstraintsFrameRate15;

/**
 *  Battery saving 10 fps video.
 */
extern NSUInteger const TVIVideoConstraintsFrameRate10;

/**
 *  The capture source you wish to use.
 */
typedef NS_ENUM(NSUInteger, TVIVideoCaptureSource) {
    /**
     *  Capture video from the front facing camera.
     */
    TVIVideoCaptureSourceFrontCamera = 0,
    /**
     *  Capture video from the wide rear facing camera.
     */
    TVIVideoCaptureSourceBackCameraWide,
    /**
     *  Capture video from the telephoto rear facing camera. For the iPhone 7 Plus this is close to a "normal" lens.
     */
    TVIVideoCaptureSourceBackCameraTelephoto,
};

@class TVICameraCapturer;

/**
 *  `TVICameraCapturerDelegate` receives important lifecycle events related to the capturer.
 *  By implementing these methods you can override default behaviour, or handle errors that may occur.
 */
@protocol TVICameraCapturerDelegate <NSObject>

@optional
/**
 *  @brief The camera capturer has started producing a local preview feed.
 *
 *  @param capturer The capturer which started.
 */
- (void)cameraCapturerPreviewDidStart:(nonnull TVICameraCapturer *)capturer;

/**
 *  @brief The camera capturer has started capturing live video.
 *
 *  @discussion By default `TVICameraCapturer` mirrors (only) `TVIVideoViewRenderer` views when the source
 *  is `TVIVideoCaptureSourceFrontCamera`. If you respond to this delegate method then it is your 
 *  responsibility to apply mirroring to renderers as you see fit.
 *
 *  @param capturer The capturer which started.
 *  @param source   The source which is now being captured.
 */
- (void)cameraCapturer:(nonnull TVICameraCapturer *)capturer
    didStartWithSource:(TVIVideoCaptureSource)source;

/**
 *  @brief The camera capturer was temporarily interrupted. Respond to this method to override the default behaviour.
 *
 *  @discussion You may wish to pause your `TVILocalVideoTrack`, or update your UI in repsonse to an interruption.
 *
 *  @param capturer The capture which was interrupted.
 */
- (void)cameraCapturerWasInterrupted:(nonnull TVICameraCapturer *)capturer;

/**
 *  @brief The camera capturer failed to start or stopped running with a fatal error.
 *
 *  @param capturer The capturer which stopped.
 *  @param error    The error which caused the capturer to stop.
 */
- (void)cameraCapturer:(nonnull TVICameraCapturer *)capturer
      didFailWithError:(nonnull NSError *)error;

@end

/**
 *  `TVICameraCapturer` allows you to preview and share video captured from the device's built in camera(s).
 */
@interface TVICameraCapturer : NSObject <TVIVideoCapturer>

/** 
 *  @brief Obtains the camera that is being shared.
 */
@property (nonatomic, assign, readonly) TVIVideoCaptureSource source;

/**
 *  @brief Indicates that video capture (including preview) is active.
 *
 *  @discussion While interrupted, this property will return `NO`.
 */
@property (atomic, assign, readonly, getter=isCapturing) BOOL capturing;

/**
 *  @brief The capturer's delegate.
 */
@property (nonatomic, weak, nullable) id<TVICameraCapturerDelegate> delegate;

/**
 *  @brief The dimensions of the preview feed, in the frame of reference specified by the previewView's `orientation`.
 *
 *  @discussion With default constraints the dimensions would be 640x480 in landscape, and 480x640 in portrait.
 *  If capture is not started then 0x0 will be returned.
 */
@property (nonatomic, assign, readonly) CMVideoDimensions previewDimensions;

/**
 *  @brief A view which allows you to preview the camera source.
 *
 *  @discussion Camera preview will not begin until the `cameraCapturerPreviewDidStart` delegate method is called.
 */
@property (nonatomic, strong, readonly, nonnull) TVICameraPreviewView *previewView;

/**
 *  Returns `YES` if the capturer is currently interrupted, and `NO` otherwise.
 */
@property (nonatomic, assign, readonly, getter=isInterrupted) BOOL interrupted;

/**
 *  @brief Initializes the capturer with a source.
 *
 *  @param source The `TVIVideoCaptureSource` to select initially.
 *
 *  @return A camera capturer which can be used to create a `TVILocalVideoTrack` if video capture source is available, 
 *  `nil` if it is not.
 */
- (nullable instancetype)initWithSource:(TVIVideoCaptureSource)source;

/**
 *  @brief Creates the capturer with a source and delegate.
 *
 *  @param source The `TVIVideoCaptureSource` to select initially.
 *  @param delegate An object which conforms to `TVICameraCapturerDelegate` that will receive callbacks from the capturer.
 *
 *  @return A camera capturer which can be used to create a `TVILocalVideoTrack` if video capture source is available,
 *  `nil` if it is not.
 */
- (nullable instancetype)initWithSource:(TVIVideoCaptureSource)source
                               delegate:(nullable id<TVICameraCapturerDelegate>)delegate;


/**
 *  @brief Selects a new camera source.
 *
 *  @param source The camera source to select.
 */
- (void)selectSource:(TVIVideoCaptureSource)source;

/**
 *  @brief Selects the next available camera source, based upon the ordering of `TVIVideoCaptureSource`.
 */
- (void)selectNextSource;

/**
 *  @brief Checks if a `TVIVideoCaptureSource` is available on your device.
 *
 *  @param source The source to check.
 *
 *  @return `YES` if the source is available, or `NO` if it is not.
 */
+ (BOOL)isSourceAvailable:(TVIVideoCaptureSource)source;

/**
 *  @brief Returns all of the sources which are available on your device.
 *
 *  @discussion If you are on an iOS simulator you should not expect any sources to be returned.
 *
 *  @return An `NSArray` containing zero or more `NSNumber` objects which wrap `TVIVideoCaptureSource`.
 */
+ (nonnull NSArray<NSNumber *> *)availableSources;


@end
