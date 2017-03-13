//
//  TVIRoom.h
//  TwilioVideo
//
//  Copyright © 2016-2017 Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TVILocalParticipant;
@class TVIParticipant;
@class TVIStatsReport;

@protocol TVIRoomDelegate;

/**
 *  TVIRoomState represents the current state of a TVIRoom.
 *
 *  @discussion All TVIRoom instances start in `TVIRoomStateConnecting`, before transitioning to `TVIRoomStateConnected` or
 *  `TVIRoomStateDisconnected`.
 */
typedef NS_ENUM(NSUInteger, TVIRoomState) {
    /**
     *  The `TVIRoom` is attempting a connection based upon the TVIConnectOptions provided.
     */
    TVIRoomStateConnecting = 0,
    /**
     * The `TVIRoom` is connected, and ready to interact with other Participants.
     */
    TVIRoomStateConnected,
    /**
     *  The `TVIRoom` has been disconnected, and interaction with other Participants is no longer possible.
     */
    TVIRoomStateDisconnected
};

/**
 * `TVIRoomGetStatsBlock` is invoked asynchronously when the results of the `TVIRoom getStatsWithBlock:` method are available.
 *
 * @param statsReports A collection of `TVIStatsReport` objects
 */
typedef void (^TVIRoomGetStatsBlock)(NSArray<TVIStatsReport *> * _Nonnull statsReports);

/**
 *  `TVIRoom` represents a media session with zero or more remote Participants. Media shared by any one Participant is 
 *  distributed equally to all other Participants.
 */
@interface TVIRoom : NSObject

/**
 *  @brief The `TVIRoomDelegate`. Set this property to be notified about Room events such as connection status, and 
 *  Participants joining and leaving.
 */
@property (nonatomic, weak, readonly, nullable) id<TVIRoomDelegate> delegate;

/**
 *  @brief A representation of your local Client in the Room.
 *
 *  @discussion `TVILocalParticipant` is available once the delegate method `didConnectToRoom` is called.
 *  If you have not yet connected to the Room, or your attempt fails then this property will return `nil`.
 */
@property (nonatomic, strong, readonly, nullable) TVILocalParticipant *localParticipant;

/**
 *  @brief The name of the Room.
 * 
 *  @discussion `name` will return the `sid` if the Room was created without a name.
 */
@property (nonatomic, copy, readonly, nonnull) NSString *name;

/**
 *  @brief A collection of connected participants to `TVIRoom`.
 */
@property (nonatomic, copy, readonly, nonnull) NSArray<TVIParticipant *> *participants;

/**
 *  @brief Indicates if the Room is being recorded.
 */
@property (nonatomic, assign, readonly, getter=isRecording) BOOL recording;

/**
 *  @brief The sid of the Room.
 */
@property (nonatomic, copy, readonly, nonnull) NSString *sid;

/**
 *  @brief The Room's current state. Use `TVIRoomDelegate` to know about changes in `TVIRoomState`.
 */
@property (nonatomic, assign, readonly) TVIRoomState state;

/**
 *  @brief Developers shouldn't initialize this class directly.
 *
 *  @discussion `TVIRoom` can not be created with init
 */
- (null_unspecified instancetype)init __attribute__((unavailable("TVIRoom can not be created with init")));

/**
 *  @brief Utility method which gets a Participant using its sid.
 *
 *  @param sid The sid.
 *
 *  @return An instance of `TVIParticipant` if successful, or `nil` if not.
 */
- (nullable TVIParticipant *)getParticipantWithSid:(nonnull NSString *)sid;

/**
 *  @brief Disconnects from the Room.
 */
- (void)disconnect;

/**
 * @brief Retrieve stats for all media tracks.
 *
 * @param block The block to be invoked when the stats are available.
 *
 * @discussion Stats are retrieved asynchronously. In the case where the room is the `TVIRoomStateDisconnected` state,
 *             reports won't be delivered.
 */
- (void)getStatsWithBlock:(nonnull TVIRoomGetStatsBlock)block;

@end

/**
 *  CallKit specific additions.
 */
@interface TVIRoom (CallKit)

/**
 *  @brief The CallKit identifier for the Room.
 *
 *  @discussion Use this UUID as an argument to CallKit methods.
 */
@property (nonatomic, readonly, nullable) NSUUID *uuid;

@end

/**
 *  `TVIRoomDelegate` provides callbacks when important changes to a `TVIRoom` occur.
 */
@protocol TVIRoomDelegate <NSObject>

@optional
/**
 *  @brief This method is invoked on successful completion of connect.
 *
 *  @param  room The Room for which connection succeeded.
 */
- (void)didConnectToRoom:(nonnull TVIRoom *)room;

/**
 *  @brief This method is invoked when connecting to the Room succeeds.
 *
 *  @param room The Room to which connect failed.
 *  @param error The error encountered.
 */
- (void)room:(nonnull TVIRoom *)room didFailToConnectWithError:(nonnull NSError *)error;

/**
 *  @brief This method is invoked when the Client disconnects from a Room.
 *
 *  @param room The Room from which the Client disconnected.
 *  @param  error An NSError describing why disconnect occurred, or nil if the disconnect was initiated locally.
 */
- (void)room:(nonnull TVIRoom *)room didDisconnectWithError:(nullable NSError *)error;

/**
 *  @brief This method is invoked when a participant connects to the Room.
 *
 *  @param room The Room to which a participant got connected.
 *  @param participant The participant who connected to the Room.
 */
- (void)room:(nonnull TVIRoom *)room participantDidConnect:(nonnull TVIParticipant *)participant;

/**
 *  @brief This method is invoked when a participant disconnects from the Room.
 *
 *  @param room The Room from which a participant got disconnected.
 *  @param participant The participant who disconnected from the Room.
 */
- (void)room:(nonnull TVIRoom *)room participantDidDisconnect:(nonnull TVIParticipant *)participant;

/**
 *  @brief Called when the media being shared to a `Room` is being recorded.
 *
 *  @param  room The Room for which recording has been started.
 */
- (void)roomDidStartRecording:(nonnull TVIRoom *)room;

/**
 *  @brief This method is invoked when the recording of media shared to a `Room` has stopped.
 *
 *  @param  room The Room for which recording has been stopped.
 */
- (void)roomDidStopRecording:(nonnull TVIRoom *)room;

@end
