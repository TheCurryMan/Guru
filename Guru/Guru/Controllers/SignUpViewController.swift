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
import PopupController

class SignUpViewController: UIViewController {
    
    @IBAction func tappedScreen(_ sender: Any) {
        username.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var guruLabel: UILabel!
    @IBOutlet weak var guruLogoImg: UIImageView!
    @IBOutlet var underlineLabels: [UIView]!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var loginSubLabel: UIButton!
    @IBOutlet weak var topicButton: UIButton!
    
    var popup = PopupController()
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nc = NotificationCenter.default
        nc.addObserver(forName:Notification.Name(rawValue:"topicSignUp"),
                       object:nil, queue:nil,
                       using:catchNotification)
        
        GuruManager.sharedInstance.selectedTopics.removeAll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1.5, animations: {
            self.guruLabel.alpha=1
            self.guruLogoImg.alpha=1
            for underline in self.underlineLabels {
                underline.alpha=1;
            }
        })
        UIView.animate(withDuration: 2.5, animations: {
            self.goButton.alpha=1
            self.loginSubLabel.alpha=1
        })
    }
    
    @IBAction func submit(_ sender: Any) {
        signUp()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func signUp() {
        if (username.text == nil) {
            showAlert("Please enter a username")
        }
        else if (password.text == nil) {
            showAlert("Please enter a password")
        }
        else if (GuruManager.sharedInstance.selectedTopics.count == 0) {
            showAlert("Please select up to 3 topics")
        }
        else {
            let user = PFUser()
            user.username = username.text
            user.password = password.text
            // other fields can be set just like with PFObject
            user["topics"] = GuruManager.sharedInstance.selectedTopics
            user["available"] = true
            user["points"] = 10
            user["asked"] = 0
            user["answered"] = 0
            user.signUpInBackground {
                (success, error) -> Void in
                if let error = error {
                    print("error signing up user: \(error.localizedDescription)")
                    // Show the errorString somewhere and let the user try again.
                } else {
                    // Hooray! Let them use the app now.
                    self.username.text = ""
                    self.password.text = ""
                    OneSignal.sendTag("userID", value: PFUser.current()!.objectId!)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func selectTopics(_ sender: Any) {
        self.popup = PopupController
            .create(self)
            .customize(
                [
                    .animation(.slideUp),
                    .scrollable(false),
                    .backgroundStyle(.blackFilter(alpha: 0.7))
                ]
            )
            .didShowHandler { popup in
                print("showed popup!")
            }
            .didCloseHandler { _ in
                print("closed popup!")
                
        }
        
        _ = popup.show(DemoPopupViewController2.instance(withMultipleSelection: true))
    }
    
    func catchNotification(notification:Notification) -> Void {
        print("Catch notification")
        
        guard let userInfo = notification.userInfo,
            let topics  = userInfo["topics"] as? [String] else {
                print("No userInfo found in notification")
                return
        }
        GuruManager.sharedInstance.selectedTopics = topics
        self.topicButton.setTitle(GuruManager.sharedInstance.selectedTopics.joined(separator: ", "), for: UIControlState.normal)
        self.topicButton.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        popup.dismiss()
        
        //let alert = UIAlertController(title: "Notification!",
        //                        message:"\(message) received at \(date)",
        //preferredStyle: UIAlertControllerStyle.alert)
        //alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        //self.present(alert, animated: true, completion: nil)
        
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
