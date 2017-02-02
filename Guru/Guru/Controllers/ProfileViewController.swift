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

class ProfileViewController: UIViewController {

    @IBOutlet weak var reviewBar: CosmosView!
    @IBOutlet weak var topicsBar: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var answeredLabel: UILabel!
    @IBOutlet weak var askedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var user = PFUser.current()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUserStats()
    }
    
    func updateUserStats() {
        let user = PFUser.current()
        self.pointsLabel.text = String(user?["points"] as! Int)
        self.answeredLabel.text = String(user?["answered"] as! Int)
        self.askedLabel.text = String(user?["asked"] as! Int)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func exitView(_ sender: Any) {
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
