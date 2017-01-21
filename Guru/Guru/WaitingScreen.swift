//
//  WaitingScreen.swift
//  Guru
//
//  Created by Brian Lin on 1/21/17.
//  Copyright © 2017 Avinash Jain. All rights reserved.
//

import UIKit

class WaitingScreen: UIViewController {

    @IBOutlet weak var circles: UIImageView!

    @IBOutlet weak var guru: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.guru.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI/8))
        
        UIView.animate(withDuration: 1.5, delay: 0, options: [.repeat, .autoreverse] , animations: {
            self.guru.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI/8))
            self.circles.transform=CGAffineTransform(scaleX: 0.95, y: 0.95)
            
            
        }, completion: nil)

    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
