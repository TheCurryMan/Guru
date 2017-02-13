//
//  HomePage.swift
//  Guru
//
//  Created by Brian Lin on 1/20/17.
//  Copyright © 2017 Avinash Jain. All rights reserved.
//

import UIKit
import Parse
import PopupController

class HomePage: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var questionField: UITextField!
    //@IBOutlet weak var subjectsEntered: UITextField!
    @IBOutlet weak var acceptButton: UIButton!
    var avail = true
    var question: PFObject?
    var questions = [PFObject]()
    var selectedQuestion: PFObject?
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var emptyTableViewLabel: UILabel!
    @IBOutlet weak var topicButton: UIButton!
    var popup = PopupController()
    var finalTopic = ""
    
    //    override var prefersStatusBarHidden: Bool{
    //        return true
    //    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundView.layer.cornerRadius = 15
        
        let nc = NotificationCenter.default
        nc.addObserver(forName:Notification.Name(rawValue:"topic"),
                       object:nil, queue:nil,
                       using:catchNotification)
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "RequestTableViewCell", bundle: nil), forCellReuseIdentifier: "request")
        
        
    }
    
    //    override var preferredStatusBarStyle: UIStatusBarStyle {
    //        return .lightContent
    //    }
    
    override func viewDidAppear(_ animated: Bool) {
        let currentUser = PFUser.current()
        if currentUser == nil {
            self.presentSignup()
        }
        else {
            self.loadData()
        }
        
    }
    
    func loadData() {
        let user = PFUser.current()
        avail = user?["available"] as! Bool
        if(avail)
        {   acceptButton.setImage(UIImage(named: "Guru_trans.png"), for: .normal)
            
        }
        else {
            acceptButton.setImage(UIImage(named: "red.png"), for: .normal)
        }
        
        let query = PFQuery(className: "Requests")
        query.whereKey("tutor", equalTo: PFUser.current()!)
        query.whereKeyDoesNotExist("question.tutor")
        query.order(byAscending: "createdAt")
        query.includeKeys(["question", "question.student"])
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            for object in objects! {
                self.questions.append(object["question"] as! PFObject)
            }
            self.tableView.reloadData()
            if (self.questions.count == 0)
            {
                self.tableView.isHidden = true
                self.emptyTableViewLabel.isHidden = false
            }
            else {
                self.tableView.isHidden = false
                self.emptyTableViewLabel.isHidden = true
            }
        }
    }
    @IBAction func logout(_ sender: Any) {
        PFUser.logOut()
        self.presentSignup()
    }
    
    func presentSignup() {
        let signupVC = self.storyboard?.instantiateViewController(withIdentifier: "signupVC")
        self.present(signupVC!, animated: true, completion: nil)
    }
    
    func catchNotification(notification:Notification) -> Void {
        print("Catch notification")
        
        guard let userInfo = notification.userInfo,
            let topic  = userInfo["topic"] as? String else {
                print("No userInfo found in notification")
                return
        }
        finalTopic = topic
        self.topicButton.setTitle(self.finalTopic, for: UIControlState.normal)
        self.topicButton.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        popup.dismiss()
        
        //let alert = UIAlertController(title: "Notification!",
        //                        message:"\(message) received at \(date)",
        //preferredStyle: UIAlertControllerStyle.alert)
        //alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        //self.present(alert, animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        questionField.text = ""
        self.topicButton.setTitle("Calculus", for: UIControlState.normal)
        self.topicButton.setTitleColor(UIColor(red:0.73, green:0.73, blue:0.76, alpha:1.0), for: UIControlState.normal)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func showTopics(_ sender: AnyObject) {
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
        
        _ = popup.show(DemoPopupViewController2.instance())
        
    }
    
    
    func submitQuestion(sender: UIButton) {
        let user = PFUser.current()
        
        let question = PFObject(className:"Question")
        question["text"] = questionField.text
        question["topic"] = topicButton.titleLabel?.text
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
    
    @IBAction func tapped(_ sender: Any) {
        questionField.resignFirstResponder()
        //subjectsEntered.resignFirstResponder()
    }
    
    @IBAction func pressedAsk(_ sender: UIButton) {
        sender.isEnabled = false
        submitQuestion(sender: sender)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "request", for: indexPath) as! RequestTableViewCell
        cell.selectionStyle = .none
        let currentQuestion = questions[indexPath.row]
        cell.questionLabel.text = currentQuestion["text"] as? String
        cell.topicLabel.text = currentQuestion["topic"] as? String
        cell.usernameLabel.text = (currentQuestion["student"] as! PFUser).username!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
        
        self.selectedQuestion = self.questions[indexPath.row]
        performSegue(withIdentifier: "accept", sender: self)
        
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "loading") {
            let waitingScreen = segue.destination as! WaitingScreen
            waitingScreen.question = self.question!
        }
        if (segue.identifier == "accept") {
            let vc = segue.destination as! AcceptViewController
            vc.question = self.selectedQuestion
        }
    }
    
    
}
