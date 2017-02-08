//
//  LoginViewController.swift
//  Guru
//
//  Created by Avinash Jain on 1/29/17.
//  Copyright © 2017 Avinash Jain. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameField.delegate = self
        self.passwordField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.usernameField.text = nil
        self.passwordField.text = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func tappedScreen(_ sender: Any) {
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goButtonPressed(_ sender: Any) {
        self.login(sender)
    }
    
    @IBAction func login(_ sender: Any) {
        if usernameField.text != "" && passwordField.text != "" {
            PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!)
            { (user, error) -> Void in
                if error == nil {
                    self.performSegue(withIdentifier: "login", sender: self)
                } else {
                    print("whoops")
                    self.passwordField.backgroundColor = UIColor.red
                    self.passwordField.shake()
                }
            }
            
        }
        
    }
    //MARK: UITextFieldDelegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("next button pressed")
        if (textField == self.usernameField) {
            print("password field becoming responder")
            self.passwordField.becomeFirstResponder()
        }
        else if (textField == self.passwordField) {
            self.view.endEditing(true)
            self.login(textField)
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.passwordField) {
            textField.text = nil
        }
    }
   
}
