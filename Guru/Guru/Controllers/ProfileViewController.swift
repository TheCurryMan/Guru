//
//  ProfileViewController.swift
//  Guru
//
//  Created by Avinash Jain on 2/1/17.
//  Copyright © 2017 Avinash Jain. All rights reserved.
//

import UIKit
import Cosmos
import Parse

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var reviewBar: CosmosView!
    @IBOutlet weak var topicsBar: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var answeredLabel: UILabel!
    @IBOutlet weak var askedLabel: UILabel!
    
    var allQuestions = [PFObject]()
    var selectedQuestions = [PFObject]()
    var averageRating = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reviewBar.isUserInteractionEnabled = false
        
        var count = 0
        self.topicsBar.removeAllSegments()
        for topic in (PFUser.current()?["topics"] as! [String]) {
            self.topicsBar.insertSegment(withTitle: topic, at: count, animated: false)
            count += 1
        }
        self.topicsBar.selectedSegmentIndex = 0
        
        tableView.register(UINib(nibName: "RequestTableViewCell", bundle: nil), forCellReuseIdentifier: "request")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUserStats()
    }
    
    func updateUserStats() {
        let user = PFUser.current()
        self.usernameLabel.text = user!.username!
        self.pointsLabel.text = String(user?["points"] as! Int)
        self.answeredLabel.text = String(user?["answered"] as! Int)
        self.askedLabel.text = String(user?["asked"] as! Int)
        let questionQuery = PFQuery(className: "Question")
        questionQuery.whereKey("tutor", equalTo: PFUser.current()!)
        questionQuery.includeKey("student")
        questionQuery.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if (error == nil && objects != nil) {
                self.allQuestions = objects!
                var totalRatingCount = 0.0
                for question in self.allQuestions {
                    if let rating = question["rating"] as? Double {
                        totalRatingCount += rating
                    }
                }
                self.averageRating = totalRatingCount/Double(self.allQuestions.count)
                self.reviewBar.rating = self.averageRating
                self.sortQuestions()
            }
            else {
                print("error finding questions: \(error?.localizedDescription)")
            }
        }
        
    }
    @IBAction func changedSegment(_ sender: UISegmentedControl) {
        self.sortQuestions()
    }
    
    func sortQuestions() {
        let topics = PFUser.current()!["topics"] as! [String]
        self.selectedQuestions.removeAll()
        self.selectedQuestions = self.allQuestions.filter{($0["topic"] as! String) == (topics[self.topicsBar.selectedSegmentIndex])}
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func exitView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    //MARK: UITableView Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "request", for: indexPath) as! RequestTableViewCell
        cell.selectionStyle = .none
        let currentQuestion = self.selectedQuestions[indexPath.row]
        cell.questionLabel.text = currentQuestion["text"] as? String
        cell.topicLabel.text = currentQuestion["topic"] as? String
        cell.usernameLabel.text = (currentQuestion["student"] as! PFUser).username!
        cell.isUserInteractionEnabled = false
        
        cell.contentView.backgroundColor = UIColor.clear
        cell.questionLabel.textColor = UIColor.black
        cell.topicLabel.textColor = UIColor.darkGray
        cell.usernameLabel.textColor = UIColor.lightGray
        
        return cell
    }

}
