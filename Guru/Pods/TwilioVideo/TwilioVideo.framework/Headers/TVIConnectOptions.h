//
//  TVIConnectOptions.h
//  TwilioVideo
//
//  Copyright © 2016 Twilio Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TVILocalMedia;
@class TVIIceOptions;
@class TVICodecOptions;

/**
 *  `TVIConnectOptionsBuilder` is a builder class for `TVIConnectOptions`.
 */
@interface TVIConnectOptionsBuilder : NSObject

/**
 *  @brief A custom ICE configuration used to connect to a Room.
 *
 *  @discussion You can set this to `nil` if you've already provided IceOptions with `TVIClientOptions`.
 */
@property (nonatomic, strong, nullable) TVIIceOptions *iceOptions;

/**
 *  @brief The LocalMedia used to connect to a Room.
 *
 *  @discussion If you set this property to `nil` then a default instance of `TVILocalMedia` with no audio or video tracks
 *  will be provided instead.
 *
 */
@property (nonatomic, strong, nullable) TVILocalMedia *localMedia;

/**
 *  @brief The name of the Room which you want to connect to.
 *
 *  @discussion You can provide the name of new or existing Room. The default value of `nil` indicates that a new Room will be created.
 */
@property (nonatomic, copy, nullable) NSString *name;

@end

/**
 *  CallKit specific additions.
 */
@interface TVIConnectOptionsBuilder (CallKit)

/**
 *  @brief The CallKit identifier for the Room.
 *
 *  @discussion This property allows you to provide your CallKit UUID as part of `TVIConnectOptions`. This is offered
 *  as a convenience if you wish to use `TVIRoom` for CallKit book keeping. The UUID set here will be reflected on any
 *  `TVIRoom` instance created with these options.
 */
@property (nonatomic, strong, nullable) NSUUID *uuid;

@end

/**
 *  `TVIConnectOptionsBuilderBlock` allows you to construct `TVIConnectOptions` using the builder pattern.
 *
 *  @param builder The builder
 */
typedef void (^TVIConnectOptionsBuilderBlock)(TVIConnectOptionsBuilder * _Nonnull builder);

/**
 *  `TVIConnectOptions` represents a custom configuration to use when connecting to a Room.
 *
 *  @discussion This configuration overrides what was provided in `TVIClilentOptions`.
 */
@interface TVIConnectOptions : NSObject

/**
 *  @brief A custom ICE configuration used to connect to a Room.
 *
 *  @discussion You can set this to `nil` if you've already provided IceOptions with `TVIClientOptions`.
 */
@property (nonatomic, strong, readonly, nullable) TVIIceOptions *iceOptions;

/**
 *  @brief The LocalMedia used to connect to a Room.
 *
 *  @discussion If you set this property to `nil` then a default instance of `TVILocalMedia` with no audio or video tracks
 *  will be provided instead.
 *
 */
@property (nonatomic, strong, readonly, nullable) TVILocalMedia *localMedia;

/**
 *  @brief The name of the Room which you want to connect to.
 *
 *  @discussion You can provide the name of new or existing Room. The default value of `nil` indicates that a new Room will be created.
 */
@property (nonatomic, copy, readonly, nullable) NSString *name;

/**
 *  @brief Creates the default `TVIConnectOptions`.
 *
 *  @return An instance of `TVIConnectOptions`.
 */
+ (nonnull instancetype)options;

/**
 *  @brief Creates an instance of `TVIConnectOptions` using a builder block.
 *
 *  @param block The builder block which will be used to configure the `TVIConnectOptions` instance.
 *
 *  @return An instance of `TVIConnectOptions`.
 */
+ (nonnull instancetype)optionsWithBlock:(nonnull TVIConnectOptionsBuilderBlock)block;

@end

/**
 *  CallKit specific additions.
 */
@interface TVIConnectOptions (CallKit)

/**
 *  @brief The CallKit identifier for the Room.
 *
 *  @discussion This property allows you to provide your CallKit UUID as part of `TVIConnectOptions`. This is offered 
 *  as a convenience if you wish to use `TVIRoom` for CallKit book keeping. The UUID set here will be reflected on any 
 *  `TVIRoom` instance created with these options.
 */
@property (nonatomic, strong, readonly, nullable) NSUUID *uuid;

@end
