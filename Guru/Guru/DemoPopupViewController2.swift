//
//  DemoPopupViewController2.swift
//  PopupController
//
//  Created by 佐藤 大輔 on 2/4/16.
//  Copyright © 2016 Daisuke Sato. All rights reserved.
//

import UIKit
import PopupController

class DemoPopupViewController2: UIViewController, PopupContentViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var topics = [
        ("Algebra"),
        ("Geometry"),
        ("Precalculus"),
        ("Calculus"),
        ("Chemistry"),
        ("Biology"),
        ("Physics"),
        ("History"),
        ("Geography"),
        ("Economics"),
        ("Government"),
        ("Programming")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.layer.cornerRadius = 4
    }
    
    class func instance() -> DemoPopupViewController2 {
        let storyboard = UIStoryboard(name: "DemoPopupViewController2", bundle: nil)
        return storyboard.instantiateInitialViewController() as! DemoPopupViewController2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSize(width: 300, height: 500)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DemoPopup2Cell
        
        let (text) = topics[(indexPath as NSIndexPath).row]
        cell.titleLabel.text = text
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DemoPopup2Cell
        let topic = cell.titleLabel.text
        let nc = NotificationCenter.default
        nc.post(name:Notification.Name(rawValue:"topic"),
                object: nil,
                userInfo: ["topic":topic])
        
    }

    
    
    
}

class DemoPopup2Cell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
}
