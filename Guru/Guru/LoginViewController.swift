//
//  LoginViewController.swift
//  Guru
//
//  Created by Avinash Jain on 1/29/17.
//  Copyright © 2017 Avinash Jain. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UITextField!
    
    @IBOutlet weak var passwordLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func login(_ sender: Any) {
        if usernameLabel.text != "" && passwordLabel.text != "" {
            PFUser.logInWithUsername(inBackground: usernameLabel.text!, password: passwordLabel.text!)
            { (user, error) -> Void in
                if error == nil {
                    self.performSegue(withIdentifier: "login", sender: self)
                } else {
                    print("whoops")
                }
            }
        
        }

    }
}
