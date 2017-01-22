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
    
    var questions = [PFObject]()
    
    var selectedQuestion: PFObject?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "RequestTableViewCell", bundle: nil), forCellReuseIdentifier: "request")
        
        
        let query = PFQuery(className: "Requests")
        query.whereKey("tutor", equalTo: PFUser.current()!)
        query.order(byAscending: "createdAt")
        query.includeKeys(["question", "question.student"])
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            for object in objects! {
                self.questions.append(object["question"] as! PFObject)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "accept") {
            let vc = segue.destination as! AcceptViewController
            vc.question = self.selectedQuestion
        }
    }
    
    @IBAction func dismissView(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
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
