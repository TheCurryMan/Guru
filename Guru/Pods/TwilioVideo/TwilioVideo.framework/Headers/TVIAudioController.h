//
//  TVIAudioController.h
//  TwilioVideo
//
//  Copyright © 2016-2017 Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Describes audio output configurations. `TVIAudioOutputVideoChatDefault` is the default setting used by the sdk.
 *
 *  @discussion Real time, full-duplex audio requires a very specific AVAudioSession configuration. The Video SDK
 *  will set the category to `AVAudioSessionCategoryPlayAndRecord` with `AVAudioSessionCategoryOptionAllowBluetooth`.
 *  Properties such as the preferred IO buffer duration, sample rate, and the number of input and output of channels 
 *  will be set appropriately. You should not call AVAudioSession APIs directly.
 */
typedef NS_ENUM(NSUInteger, TVIAudioOutput) {
    /**
     *  Mode `AVAudioSessionModeVideoChat` with override `AVAudioSessionPortOverrideNone` will be used.
     *  This is the default setting.
     */
    TVIAudioOutputVideoChatDefault = 0,
    /**
     *  Mode `AVAudioSessionModeVideoChat` with override `AVAudioSessionPortOverrideSpeaker` will be used.
     */
    TVIAudioOutputVideoChatSpeaker,
    /**
     *  Mode `AVAudioSessionModeVoiceChat` with override `AVAudioSessionPortOverrideNone`  will be used.
     */
    TVIAudioOutputVoiceChatDefault,
    /**
     *  Mode `AVAudioSessionModeVoiceChat` with override `AVAudioSessionPortOverrideSpeaker` will be used.
     */
    TVIAudioOutputVoiceChatSpeaker
};

/**
 *  `TVIAudioController` allows you to manage audio usage in the TwilioVideo SDK.
 */
@interface TVIAudioController : NSObject

/**
 *  @brief Developers shouldn't initialize this class directly.
 *
 *  @discussion `TVIAudioController` can not be created with init.
 */
- (null_unspecified instancetype)init __attribute__((unavailable("TVIAudioController can not be created with init")));

/**
 *  @brief The audio output configuration for the sdk. Use this property to customize audio behavior for your particular 
 *  use case. The default value is `TVIAudioOutputVideoChatDefault`.
 */
@property (nonatomic, assign) TVIAudioOutput audioOutput;

@end

/**
 *  CallKit specific additions. You should not call these methods unless your app is using CallKit.
 */
@interface TVIAudioController (CallKit)

/**
 *  @brief Configures, but does not activate the `AVAudioSession`.
 *
 *  @discussion If you are using CallKit, you must call this API before reporting a new incoming/outgoing call to CallKit
 *  or in CXProviderDelegate's provider:performStartCallAction: or provider:performAnswerCallAction:.
 *  If you are not using CallKit then this method will be invoked on your behalf by the SDK.
 *
 *  @param audioOutput The audio output.
 */
- (void)configureAudioSession:(TVIAudioOutput)audioOutput;

/**
 *  @brief Starts the audio device.
 *
 *  @discussion If you are using CallKit, you must call this API on CXProviderDelegate's provider:didActivateAudioSession:.
 *  and hold action provider:performSetHeldCallAction: method.
 *  If you are not using CallKit then this method will be invoked on your behalf by the SDK.
 *
 *  @return `YES` if the starting audio succeeds, and `NO` if it fails.
 */
- (BOOL)startAudio;

/**
 *  @brief Stops the audio device.
 *
 *  @discussion If you are using CallKit, you must call this API on CXProviderDelegate's providerDidReset:, unhold action
 *  provider:performSetHeldCallAction: and provider:performEndCallAction: method.
 *  If you are not using CallKit then this method will be invoked on your behalf by the SDK.
 */
- (void)stopAudio;

@end

