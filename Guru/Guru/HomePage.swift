//
//  HomePage.swift
//  Guru
//
//  Created by Brian Lin on 1/20/17.
//  Copyright © 2017 Avinash Jain. All rights reserved.
//

import UIKit
import Parse

class HomePage: UIViewController, UITextViewDelegate {

    @IBOutlet weak var questionField: UITextField!
    @IBOutlet weak var subjectsEntered: UITextView!

    @IBAction func tapped(_ sender: Any) {
        questionField.resignFirstResponder()
        subjectsEntered.resignFirstResponder()
    }
    @IBAction func pressedCamera(_ sender: Any) {
        
    }
    
    @IBAction func pressedAsk(_ sender: Any) {
        submitQuestion()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.subjectsEntered.delegate = self;

        // Do any additional setup after loading the view.
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
