//
//  GuruReviewViewController.swift
//  Guru
//
//  Created by Avinash Jain on 1/30/17.
//  Copyright © 2017 Avinash Jain. All rights reserved.
//

import UIKit
import Parse

class GuruReviewViewController: UIViewController {

    @IBOutlet weak var reviewLabel: UILabel!
    
    @IBOutlet weak var oneStar: UIButton!
    @IBOutlet weak var twoStar: UIButton!
    @IBOutlet weak var threeStar: UIButton!
    @IBOutlet weak var fourStar: UIButton!
    @IBOutlet weak var fiveStar: UIButton!
    
    var question: PFObject!
    var rating = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func clearAllStars() {
        oneStar.setImage(UIImage(named: "star (1).png"), for: .normal)
        twoStar.setImage(UIImage(named: "star (1).png"), for: .normal)
        threeStar.setImage(UIImage(named: "star (1).png"), for: .normal)
        fourStar.setImage(UIImage(named: "star (1).png"), for: .normal)
        fiveStar.setImage(UIImage(named: "star (1).png"), for: .normal)

    }
    
    @IBAction func oneStarReview(_ sender: Any) {
        clearAllStars()
        oneStar.setImage(UIImage(named: "star filled.png"), for: .normal)
        reviewLabel.text = "Poor"
        rating = 1
    }
    @IBAction func twoStarReview(_ sender: Any) {
        oneStarReview(self)
        twoStar.setImage(UIImage(named: "star filled.png"), for: .normal)
        reviewLabel.text = "Fair"
        rating = 2
    }
    @IBAction func threeStarReview(_ sender: Any) {
        twoStarReview(self)
        threeStar.setImage(UIImage(named: "star filled.png"), for: .normal)
        reviewLabel.text = "Good"
        rating = 3
    }
    @IBAction func fourStarReview(_ sender: Any) {
        threeStarReview(self)
        fourStar.setImage(UIImage(named: "star filled.png"), for: .normal)
        reviewLabel.text = "Very Good"
        rating = 4
    }
    @IBAction func fiveStarReview(_ sender: Any) {
        fourStarReview(self)
        fiveStar.setImage(UIImage(named: "star filled.png"), for: .normal)
        reviewLabel.text = "Excellent"
        rating = 5
    }
    
    
    
    
    @IBAction func submitReview(_ sender: Any) {
        
        let review = Review()
        review.question = question;
        review.rating = rating
        review.saveInBackground {
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
