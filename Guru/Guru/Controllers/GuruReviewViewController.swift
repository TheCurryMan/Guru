//
//  GuruReviewViewController.swift
//  Guru
//
//  Created by Avinash Jain on 1/30/17.
//  Copyright © 2017 Avinash Jain. All rights reserved.
//

import UIKit
import Parse
import Cosmos

class GuruReviewViewController: UIViewController {

    @IBOutlet weak var reviewLabel: UILabel!
    
    @IBOutlet weak var reviewBar: CosmosView!
    
    var question: PFObject!
    var rating = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewBar.rating = 0

        // Do any additional setup after loading the view.
        
        reviewBar.didFinishTouchingCosmos = { rating in
            self.rating = rating
            
            if (rating <= 1) {
                self.reviewLabel.text = "Poor"
            } else if (rating <= 2){
                self.reviewLabel.text = "Fair"
            } else if (rating <= 3){
                self.reviewLabel.text = "Good"
            } else if (rating <= 4){
                self.reviewLabel.text = "Very Good"
            } else {
                self.reviewLabel.text = "Excellent"
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitReview(_ sender: Any) {
        
        question["review"] = self.rating
        question.saveInBackground {
            (success, error) -> Void in
            if (success) {
                print("Sent Review")
                self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
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
