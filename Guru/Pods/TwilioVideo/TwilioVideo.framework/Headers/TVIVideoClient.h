//
//  TVIVideoClient.h
//  TwilioVideo
//
//  Copyright © 2016-2017 Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TVIConnectOptions;
@class TVIRoom;
@protocol TVIRoomDelegate;

/**
 *  Different logging levels.
 */
typedef NS_ENUM(NSUInteger, TVILogLevel) {
    /**
     *  Turn off logging.
     */
    TVILogLevelOff = 0,
    /**
     *  Log very severe error events that will presumably lead the application to abort.
     */
    TVILogLevelFatal,
    /**
     *  Log error events that might still allow the application to continue running.
     */
    TVILogLevelError,
    /**
     *  Log warning events that may indicate potentially harmful situations.
     */
    TVILogLevelWarning,
    /**
     *  Log the progress of the application at coarse-grained level.
     */
    TVILogLevelInfo,
    /**
     *  Log fine-grained informational events that are most useful to debug an application.
     */
    TVILogLevelDebug,
    /**
     *  Log finer-grained informational events than the debug.
     */
    TVILogLevelTrace,
    /**
     *  Turn on all logging.
     */
    TVILogLevelAll
};

/**
 *  Different logging modules.
 */
typedef NS_ENUM(NSUInteger, TVILogModule) {
    /**
     *  Video Core SDK.
     */
    TVILogModuleCore = 0,
    /**
     *  Video iOS SDK.
     */
    TVILogModulePlatform,
    /**
     *  Signaling Module.
     */
    TVILogModuleSignaling,
    /**
     *  Webrtc Module.
     */
    TVILogModuleWebRTC
};

/**
 *  `TVIVideoClient` is the root class of the TwilioVideo SDK. You can connect to a Room using an instance of this class.
 */
@interface TVIVideoClient : NSObject

/**
 *  @brief Developers shouldn't initialize this class directly.
 *
 *  @discussion Use `TVIVideoClient` class factory methods to create a `TVIRoom`.
 */
- (null_unspecified instancetype)init __attribute__((unavailable("Use TVIVideoClient class factory methods to create a TVIRoom.")));

/**
 *  @brief Connect to a Room with options and a delegate.
 *
 *  @param options  The connect options.
 *  @param delegate A delegate conforming to `TVIRoomDelegate` for handling Room related events.
 *
 *  @return An instance of `TVIRoom` if successful and `nil` otherwise.
 */
+ (nonnull TVIRoom *)connectWithOptions:(nonnull TVIConnectOptions *)options
                               delegate:(nullable id<TVIRoomDelegate>)delegate;

/**
 *  @brief Returns the SDK version.
 *
 *  @return Video sdk version of type string.
 */
+ (nonnull NSString *)version;

/**
 *  @brief Retrieve the log level for the Video SDK. The default log level is `TVILogLevelError`.
 *
 *  @return The current log level.
 */
+ (TVILogLevel)logLevel;

/**
 *  @brief Set the log level for the TwilioVideo SDK.
 *
 *  @param logLevel The `TVILogLevel` in use by the system.
 */
+ (void)setLogLevel:(TVILogLevel)logLevel;

/**
 *  @brief Set the log level for a specific module in the TwilioVideo SDK.
 *
 *  @param logLevel The `TVILogLevel` to be used by the module.
 *  @param module   The `TVILogModule` for which the log level needs to be set.
 */
+ (void)setLogLevel:(TVILogLevel)logLevel module:(TVILogModule)module;

@end

