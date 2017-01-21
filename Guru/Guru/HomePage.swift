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

    @IBAction func tapped(_ sender: Any) {
        questionField.resignFirstResponder()
        subjectsEntered.resignFirstResponder()
    }
    
    @IBAction func pressedAsk(_ sender: Any) {
        submitQuestion()
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    func submitQuestion() {
        let user = PFUser.current()

        var question = PFObject(className:"Question")
        question["text"] = questionField.text
        question["topic"] = subjectsEntered.text
        question["student"] = user
        question.saveInBackground {
            (success, error) -> Void in
            if (success) {
                self.performSegue(withIdentifier: "loading", sender: self)
                
            } else {
                // There was a problem, check error.description
            }
        
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
