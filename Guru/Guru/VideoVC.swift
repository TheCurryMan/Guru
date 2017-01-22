//
//  VideoVC.swift
//  Guru
//
//  Created by Dylan Diamond on 1/21/17.
//  Copyright © 2017 Avinash Jain. All rights reserved.
//

import UIKit
import Parse

class VideoVC: UIViewController {
    
    @IBOutlet weak var remoteView: UIView!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var disconnectButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var micButton: UIButton!
    
    weak var delegate:WaitingScreenDelegate?
    var question: PFObject!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let liveDrawVC = self.storyboard?.instantiateViewController(withIdentifier: "LiveDrawing") as! LDViewController
        liveDrawVC.question = question
        self.addChildViewController(liveDrawVC)
        self.view.addSubview(liveDrawVC.view)
        self.view.bringSubview(toFront: disconnectButton)
        self.view.bringSubview(toFront: micButton)
    }
    
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showRoomUI(inRoom: Bool) {
        self.micButton.isHidden = !inRoom
        self.disconnectButton.isHidden = !inRoom
        UIApplication.shared.isIdleTimerDisabled = inRoom
    }
    
    
    @IBAction func disconnect(sender: AnyObject) {
        print("disconnecting user")
        self.delegate?.disconnect(sender: sender)
        self.performSegue(withIdentifier: "home", sender: self)
    }
    @IBAction func toggleMic(sender: AnyObject) {
        print("toggle mic")
        self.delegate?.toggleMic(sender: sender)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
