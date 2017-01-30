//
//  SignUpViewController.swift
//  Guru
//
//  Created by Avinash Jain on 1/21/17.
//  Copyright © 2017 Avinash Jain. All rights reserved.
//

import UIKit
import Parse
import OneSignal

class SignUpViewController: UIViewController {

    @IBAction func tappedScreen(_ sender: Any) {
        username.resignFirstResponder()
        password.resignFirstResponder()
        topics.resignFirstResponder()
    }
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var topics: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let currentUser = PFUser.current()
        if currentUser != nil {
            self.performSegue(withIdentifier: "signup", sender: self)
        } else {
            // Show the signup or login screen
        }
    }
    
    @IBAction func submit(_ sender: Any) {
        signUp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func signUp() {
        let user = PFUser()
        user.username = username.text
        user.password = password.text
        // other fields can be set just like with PFObject
        user["topics"] = topics.text?.components(separatedBy: ", ")
        user["available"] = true
        user["points"] = 10
        user["asked"] = 0
        user["answered"] = 0
        user.signUpInBackground {
            (success, error) -> Void in
            if let error = error {
                let errorString = (error as NSError).userInfo["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
            } else {
                // Hooray! Let them use the app now.
                self.username.text = ""
                self.password.text = ""
                self.topics.text = ""
                OneSignal.sendTag("userID", value: PFUser.current()!.objectId!)
                self.performSegue(withIdentifier: "signup", sender: self)
            }
        }
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
