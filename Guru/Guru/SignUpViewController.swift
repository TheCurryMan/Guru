//
//  SignUpViewController.swift
//  Guru
//
//  Created by Avinash Jain on 1/21/17.
//  Copyright © 2017 Avinash Jain. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var topics: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var currentUser = PFUser.current()
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
        var user = PFUser()
        user.username = username.text
        user.password = password.text
        // other fields can be set just like with PFObject
        user["topics"] = topics.text?.components(separatedBy: ",")
        user.signUpInBackground {
            (success, error) -> Void in
            if let error = error {
                let errorString = (error as NSError).userInfo["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
            } else {
                // Hooray! Let them use the app now.
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
