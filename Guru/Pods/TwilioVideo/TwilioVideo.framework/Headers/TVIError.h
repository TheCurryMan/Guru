//
//  TVIError.h
//  TwilioVideo
//
//  Copyright © 2016 Twilio. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef TVIError_h
#define TVIError_h

FOUNDATION_EXPORT NSString *const kTVIErrorDomain;

/**
 * An enumeration indicating the errors that can be raised by the SDK.
 */
typedef NS_ENUM (NSUInteger, TVIError)
{
    TVIErrorUnknown = 0,                                                ///< An unknown error has occurred.
    TVIErrorInvalidAccessToken = 20101,                                 ///< The provided access token is invalid.
    TVIErrorSignalingConnection = 53000,                                ///< An error occurred with the signaling connection.
    TVIErrorClientUnableToCreateOrApplyLocalMediaDescription = 53400,   ///< Couldn't create or apply a local media description.
    TVIErrorClientUnableToApplyRemoteMediaDescription = 53402,          ///< Couldn't apply a remote media description.
    TVIErrorMediaConnection = 53405                                     ///< An error ocurred with the media connection.
};

#endif
