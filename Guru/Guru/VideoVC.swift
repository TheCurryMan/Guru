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
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var disconnectButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var micButton: UIButton!
    
    weak var delegate:WaitingScreenDelegate?
    var question: PFObject!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let liveDrawVC = self.storyboard?.instantiateViewController(withIdentifier: "LiveDrawing") as! LDViewController
        liveDrawVC.question = question
        self.addChildViewController(liveDrawVC)
        self.view.addSubview(liveDrawVC.view)
        
        // Do any additional setup after loading the view.
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
        self.connectButton.isHidden = inRoom
        self.micButton.isHidden = !inRoom
        self.disconnectButton.isHidden = !inRoom
        UIApplication.shared.isIdleTimerDisabled = inRoom
    }
    
    
    @IBAction func disconnect(sender: AnyObject) {
        self.delegate?.disconnect(sender: sender)
    }
    @IBAction func toggleMic(sender: AnyObject) {
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
