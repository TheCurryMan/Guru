//
//  AcceptViewController.swift
//  Guru
//
//  Created by Avinash Jain on 1/21/17.
//  Copyright © 2017 Avinash Jain. All rights reserved.
//

import UIKit
import Parse

class AcceptViewController: UIViewController {
    
    var question: PFObject!
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var topicLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.layer.cornerRadius = 15
        questionLabel.text = question["text"] as? String
        topicLabel.text = question["topic"] as? String
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func accept(_ sender: Any) {
            question.fetchInBackground { (updatedQuestion: PFObject?, error: Error?) in
                if (updatedQuestion?["tutor"] == nil) {
                    self.question["tutor"] = PFUser.current()!
                    self.question.saveEventually()
                    self.performSegue(withIdentifier: "acceptCallSegue", sender: self)
                }
                else {
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
    }
    
    @IBAction func decline(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "acceptCallSegue") {
            let waitingScreen = segue.destination as! WaitingScreen
            waitingScreen.question = self.question
        }
    }
    
    
}
