//
//  GuruReviewViewController.swift
//  Guru
//
//  Created by Avinash Jain on 1/30/17.
//  Copyright © 2017 Avinash Jain. All rights reserved.
//

import UIKit

class GuruReviewViewController: UIViewController {

    @IBOutlet weak var reviewLabel: UILabel!
    
    @IBOutlet weak var oneStar: UIButton!
    @IBOutlet weak var twoStar: UIButton!
    @IBOutlet weak var threeStar: UIButton!
    @IBOutlet weak var fourStar: UIButton!
    @IBOutlet weak var fiveStar: UIButton!
    
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
    }
    @IBAction func twoStarReview(_ sender: Any) {
        oneStarReview(self)
        twoStar.setImage(UIImage(named: "star filled.png"), for: .normal)
        reviewLabel.text = "Fair"
        
    }
    @IBAction func threeStarReview(_ sender: Any) {
        twoStarReview(self)
        threeStar.setImage(UIImage(named: "star filled.png"), for: .normal)
        reviewLabel.text = "Good"
    }
    @IBAction func fourStarReview(_ sender: Any) {
        threeStarReview(self)
        fourStar.setImage(UIImage(named: "star filled.png"), for: .normal)
        reviewLabel.text = "Very Good"
    }
    @IBAction func fiveStarReview(_ sender: Any) {
        fourStarReview(self)
        fiveStar.setImage(UIImage(named: "star filled.png"), for: .normal)
        reviewLabel.text = "Excellent"
    }
    
    
    
    
    @IBAction func submitReview(_ sender: Any) {
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
