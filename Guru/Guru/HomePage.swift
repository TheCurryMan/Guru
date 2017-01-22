//
//  HomePage.swift
//  Guru
//
//  Created by Brian Lin on 1/20/17.
//  Copyright © 2017 Avinash Jain. All rights reserved.
//

import UIKit
import Parse

class HomePage: UIViewController {

    @IBOutlet weak var questionField: UITextField!
    @IBOutlet weak var subjectsEntered: UITextField!
    @IBOutlet weak var acceptButton: UIButton!
    var avail = true
    var question: PFObject?
	@IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var answeredLabel: UILabel!
    @IBOutlet weak var askedLabel: UILabel!
    
    @IBAction func tapped(_ sender: Any) {
        questionField.resignFirstResponder()
        subjectsEntered.resignFirstResponder()
    }
    
    @IBAction func pressedAsk(_ sender: UIButton) {
        sender.isEnabled = false
        submitQuestion(sender: sender)
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundView.layer.cornerRadius = 15
        let user = PFUser.current()
        avail = user?["available"] as! Bool
        if(avail)
        {   acceptButton.setImage(UIImage(named: "Guru_trans.png"), for: .normal)
            
        }
        else {
            acceptButton.setImage(UIImage(named: "red.png"), for: .normal)
        }
        
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        questionField.text = ""
        subjectsEntered.text = ""
        
        pointsLabel.text = String(PFUser.current()?["points"] as! Int)
        answeredLabel.text = String(PFUser.current()?["answered"] as! Int)
        askedLabel.text = String(PFUser.current()?["asked"] as! Int)
        
    }
    
    func submitQuestion(sender: UIButton) {
        let user = PFUser.current()

        let question = PFObject(className:"Question")
        question["text"] = questionField.text
        question["topic"] = subjectsEntered.text
        question["student"] = user
        question.saveInBackground {
            (success, error) -> Void in
            if (success) {
                self.question = question
                self.performSegue(withIdentifier: "loading", sender: self)
                
            } else {
                // There was a problem, check error.description
            }
            sender.isEnabled = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func accept(_ sender: Any) {
       avail = !avail
        if(avail)
        {   acceptButton.setImage(UIImage(named: "Guru_trans.png"), for: .normal)
            
        }
        else {
            acceptButton.setImage(UIImage(named: "red.png"), for: .normal)
        }
        if let currentUser = PFUser.current(){
            currentUser["available"] = avail
            currentUser.saveInBackground()
        }

        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "loading") {
            let waitingScreen = segue.destination as! WaitingScreen
            waitingScreen.question = self.question!
        }
    }
 

}
