//
//  WaitingScreen.swift
//  Guru
//
//  Created by Brian Lin on 1/21/17.
//  Copyright © 2017 Avinash Jain. All rights reserved.
//

import UIKit
import TwilioVideo
import Parse

protocol WaitingScreenDelegate: class {
    func toggleMic(sender: AnyObject)
    func disconnect(sender: AnyObject)
    func toggleCamera()
}

class WaitingScreen: UIViewController, WaitingScreenDelegate {
    
    var accessToken = ""
    
    // Configure remote URL to fetch token from
    var tokenUrl = "https://theguruapp.herokuapp.com/token?username=\(PFUser.current()!.username!)"
    
    // Video SDK components
    var client: TVIVideoClient?
    var room: TVIRoom?
    var localMedia: TVILocalMedia?
    var camera: TVICameraCapturer?
    var localVideoTrack: TVILocalVideoTrack?
    var localAudioTrack: TVILocalAudioTrack?
    var participant: TVIParticipant?
    
    var question: PFObject!
    var tutor = false
    // MARK: UI Element Outlets and handles
    @IBOutlet weak var circles: UIImageView!
    @IBOutlet weak var guru: UIImageView!
    @IBOutlet var dismissButton: UIButton!
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var loadingLabel: UILabel!
    
    var videoScreen: VideoVC!

//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.videoScreen = self.storyboard?.instantiateViewController(withIdentifier: "videoVC") as! VideoVC
        self.addChildViewController(self.videoScreen)
        self.view.addSubview(self.videoScreen.view)
        self.videoScreen.view.alpha = 0
        self.videoScreen.view.isUserInteractionEnabled = false
        self.videoScreen.question = question
        self.videoScreen.delegate = self
        
        self.questionLabel.text = self.question["text"] as? String
        
        if (self.tutor == false) {
            self.loadingLabel.text = "Finding a guru..."
        }
        else {
            self.loadingLabel.text = "Connecting to student..."
        }
        
        localMedia = TVILocalMedia()
        let audioController = localMedia?.audioController
        audioController?.audioOutput = .videoChatSpeaker
        
        if PlatformUtils.isSimulator {
            self.videoScreen.previewView.removeFromSuperview()
        } else {
            // Preview our local camera track in the local video preview view.
            self.startPreview()
        }
        
        // Disconnect and mic button will be displayed when the Client is connected to a Room.
        self.videoScreen.disconnectButton.isHidden = true
        self.videoScreen.micButton.isHidden = true
        
        self.guru.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI/8))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 1.5, delay: 0, options: [.repeat, .autoreverse] , animations: {
            self.guru.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI/8))
            self.circles.transform=CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.connect()
            
        }, completion: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.videoScreen.liveDrawVC?.removeFromParentViewController()
        self.videoScreen.removeFromParentViewController()
    }
    
    func connect() {
        // Configure access token either from server or manually.
        // If the default wasn't changed, try fetching from server.
        if (accessToken.characters.count == 0) {
            do {
                accessToken = try TokenUtils.fetchToken(url: tokenUrl)
            } catch {
                let message = "Failed to fetch access token"
                logMessage(messageText: message)
                return
            }
        }
        
        // Create a Client with the access token that we fetched (or hardcoded).
        if (client == nil) {
            client = TVIVideoClient(token: accessToken)
            if (client == nil) {
                logMessage(messageText: "Failed to create video client")
                return
            }
        }
        
        // Prepare local media which we will share with Room Participants.
        self.prepareLocalMedia()
        
        // Preparing the connect options
        let connectOptions = TVIConnectOptions { (builder) in
            
            // Use the local media that we prepared earlier.
            builder.localMedia = self.localMedia
            
            // The name of the Room where the Client will attempt to connect to. Please note that if you pass an empty
            // Room `name`, the Client will create one for you. You can get the name or sid from any connected Room.
            builder.name = self.question.objectId!
        }
        
        // Connect to the Room using the options we provided.
        room = client?.connect(with: connectOptions, delegate: self)
        
        logMessage(messageText: "Attempting to connect to room \(self.question.objectId!)")
        
        self.videoScreen.showRoomUI(inRoom: true)
    }

    func disconnect(sender: AnyObject) {
        self.room!.disconnect()
        logMessage(messageText: "Attempting to disconnect from room \(room!.name)")
    }
    
    func toggleMic(sender: AnyObject) {
        if (self.localAudioTrack != nil) {
            self.localAudioTrack?.isEnabled = !(self.localAudioTrack?.isEnabled)!
            
            // Update the button title
            if (self.localAudioTrack?.isEnabled == true) {
                self.videoScreen.micButton.setTitle("Mute", for: .normal)
            } else {
                self.videoScreen.micButton.setTitle("Unmute", for: .normal)
            }
        }
    }
    
    // MARK: Private
    func startPreview() {
        if PlatformUtils.isSimulator {
            return
        }
        
        // Preview our local camera track in the local video preview view.
        camera = TVICameraCapturer()
        localVideoTrack = localMedia?.addVideoTrack(true, capturer: camera!)
        if (localVideoTrack == nil) {
            logMessage(messageText: "Failed to add video track")
        } else {
            // Attach view to video track for local preview
            localVideoTrack!.attach(self.videoScreen.previewView)
            
            logMessage(messageText: "Video track added to localMedia")
            
        }
    }
    
    func toggleCamera() {
        self.flipCamera()
    }
    
    func flipCamera() {
        if (self.camera?.source == .frontCamera) {
            self.camera?.selectSource(.backCameraWide)
        } else {
            self.camera?.selectSource(.frontCamera)
        }
    }
    
    func prepareLocalMedia() {
        
        // We will offer local audio and video when we connect to room.
        
        // Adding local audio track to localMedia
        if (localAudioTrack == nil) {
            localAudioTrack = localMedia?.addAudioTrack(true)
        }
        
        // Adding local video track to localMedia and starting local preview if it is not already started.
        if (localMedia?.videoTracks.count == 0) {
            self.startPreview()
        }
    }
    
    // Update our UI based upon if we are in a Room or not

    
    func cleanupRemoteParticipant() {
        if ((self.participant) != nil) {
            if ((self.participant?.media.videoTracks.count)! > 0) {
                self.participant?.media.videoTracks[0].detach(self.videoScreen.remoteView)
            }
        }
        self.participant = nil
    }
    
    func logMessage(messageText: String) {
        videoScreen.messageLabel.text = messageText
        print(messageText)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func dismissView(_ sender: Any) {
        print("dismissing view")
        self.dismiss(animated: true, completion: nil)
    }

}

// MARK: TVIRoomDelegate
extension WaitingScreen: TVIRoomDelegate {
    func didConnect(to room: TVIRoom) {
        
        // At the moment, this example only supports rendering one Participant at a time.
        
        logMessage(messageText: "Connected to room \(room.name) as \(room.localParticipant?.identity)")
        
        if (room.participants.count > 0) {
            self.participant = room.participants[0]
            self.participant?.delegate = self
            UIView.animate(withDuration: 0.5) {
                self.videoScreen.view.alpha = 1
            }
            self.videoScreen.view.isUserInteractionEnabled = true
            self.dismissButton.isEnabled = false
        }
    }
    
    func room(_ room: TVIRoom, didDisconnectWithError error: Error?) {
        logMessage(messageText: "Disconncted from room \(room.name), error = \(error)")
        
        self.cleanupRemoteParticipant()
        self.room = nil
        
        self.videoScreen.showRoomUI(inRoom: false)
        if (self.tutor == false)
        {
            self.performSegue(withIdentifier: "review", sender: self)
        } else {
            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        }
    }
    
    func room(_ room: TVIRoom, didFailToConnectWithError error: Error) {
        logMessage(messageText: "Failed to connect to room with error")
        self.room = nil
        
        self.videoScreen.showRoomUI(inRoom: false)
    }
    
    func room(_ room: TVIRoom, participantDidConnect participant: TVIParticipant) {
        if (self.participant == nil) {
            self.participant = participant
            self.participant?.delegate = self
        }
        logMessage(messageText: "Room \(room.name), Participant \(participant.identity) connected")
        
        UIView.animate(withDuration: 0.5) { 
            self.videoScreen.view.alpha = 1
        }
        self.videoScreen.view.isUserInteractionEnabled = true
        self.dismissButton.isEnabled = false
    }
    
    func room(_ room: TVIRoom, participantDidDisconnect participant: TVIParticipant) {
        if (self.participant == participant) {
            cleanupRemoteParticipant()
        }
        logMessage(messageText: "Room \(room.name), Participant \(participant.identity) disconnected")
        self.room!.disconnect()
    }
}

// MARK: TVIParticipantDelegate
extension WaitingScreen : TVIParticipantDelegate {
    func participant(_ participant: TVIParticipant, addedVideoTrack videoTrack: TVIVideoTrack) {
        logMessage(messageText: "Participant \(participant.identity) added video track")
        
        if (self.participant == participant) {
            print("THIS IS THE HEIGHT: \(videoTrack.videoDimensions.height)")
            videoTrack.attach(self.videoScreen.remoteView)
        }
    }
    
    func participant(_ participant: TVIParticipant, removedVideoTrack videoTrack: TVIVideoTrack) {
        logMessage(messageText: "Participant \(participant.identity) removed video track")
        
        if (self.participant == participant) {
            videoTrack.detach(self.videoScreen.remoteView)
        }
    }
    
    func participant(_ participant: TVIParticipant, addedAudioTrack audioTrack: TVIAudioTrack) {
        logMessage(messageText: "Participant \(participant.identity) added audio track")
        
    }
    
    func participant(_ participant: TVIParticipant, removedAudioTrack audioTrack: TVIAudioTrack) {
        logMessage(messageText: "Participant \(participant.identity) removed audio track")
    }
    
    func participant(_ participant: TVIParticipant, enabledTrack track: TVITrack) {
        var type = ""
        if (track is TVIVideoTrack) {
            type = "video"
        } else {
            type = "audio"
        }
        logMessage(messageText: "Participant \(participant.identity) enabled \(type) track")
    }
    
    func participant(_ participant: TVIParticipant, disabledTrack track: TVITrack) {
        var type = ""
        if (track is TVIVideoTrack) {
            type = "video"
        } else {
            type = "audio"
        }
        logMessage(messageText: "Participant \(participant.identity) disabled \(type) track")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "review")
        {
            let vc = segue.destination as! GuruReviewViewController
            vc.question = question
        }
    }
}

