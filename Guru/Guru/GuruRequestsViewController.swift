//
//  GuruRequestsViewController.swift
//  Guru
//
//  Created by Avinash Jain on 1/21/17.
//  Copyright © 2017 Avinash Jain. All rights reserved.
//

import UIKit
import Parse

class RequestTableViewCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel!

    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
}

class GuruRequestsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var topics = [String]()
    
    var questions = [String]()
    var qTopics = [String]()
    var usernames = [String]()
    
    var finalQ = String()
    var finalT = String()
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "RequestTableViewCell", bundle: nil), forCellReuseIdentifier: "request")
        
        if let currentUser = PFUser.current() {
            topics = currentUser["topics"] as! [String]
        }
        
        let query = PFQuery(className: "Requests")
        query.whereKey("tutor", equalTo: PFUser.current()!)
        query.order(byAscending: "createdAt")
        query.includeKeys(["question", "question.student"])
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            for i in objects! {
                let ques = (i["question"] as! PFObject)["text"]! as! String
                let topic = (i["question"] as! PFObject)["topic"]! as! String
                let username = ((i["question"] as! PFObject)["student"]! as! PFUser)["username"] as! String
                
                self.questions.append(ques)
                self.qTopics.append(topic)
                self.usernames.append(username)
                
            }
            
            self.tableView.reloadData()
            
            
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "request", for: indexPath) as! RequestTableViewCell
        cell.selectionStyle = .none
        cell.questionLabel.text = questions[indexPath.row]
        cell.topicLabel.text = qTopics[indexPath.row]
        cell.usernameLabel.text = usernames[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! RequestTableViewCell
        self.tableView.deselectRow(at: indexPath, animated: false)
        
        finalQ = cell.questionLabel.text!
        finalT = cell.topicLabel.text!
        performSegue(withIdentifier: "accept", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "accept") {
            var vc = segue.destination as! AcceptViewController
            vc.question = finalQ
            vc.topic = finalT
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
