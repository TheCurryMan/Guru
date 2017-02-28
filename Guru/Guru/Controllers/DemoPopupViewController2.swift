//
//  DemoPopupViewController2.swift
//  PopupController
//
//  Created by 佐藤 大輔 on 2/4/16.
//  Copyright © 2016 Daisuke Sato. All rights reserved.
//

import UIKit
import PopupController
import M13Checkbox

class DemoPopupViewController2: UIViewController, PopupContentViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomButton: UIButton!
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
    
    var selectedTopics: [String] = []
    
    var multipleSelection = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bottomButton.setTitle("Select up to 3 topics", for: .disabled)
        self.bottomButton.setTitle("Done", for: .normal)
        self.disableBottomButton()
        tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.layer.cornerRadius = 4
    }
    
    class func instance(withMultipleSelection multipleSelection: Bool) -> DemoPopupViewController2 {
        let storyboard = UIStoryboard(name: "DemoPopupViewController2", bundle: nil)
        let popupVC = storyboard.instantiateInitialViewController() as! DemoPopupViewController2
        popupVC.multipleSelection = multipleSelection
        return popupVC
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
        
        let text = topics[(indexPath as NSIndexPath).row]
        cell.titleLabel.text = text
        
        if (multipleSelection) {
            cell.checkbox.isHidden = false
            if (selectedTopics.contains(text)) {
                cell.checkbox.setCheckState(.checked, animated: false)
            }
            else {
                cell.checkbox.setCheckState(.unchecked, animated: false)
            }
        }
        else {
            cell.checkbox.isHidden = true
        }
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DemoPopup2Cell
        let topic = cell.titleLabel.text
        self.tableView.deselectRow(at: indexPath, animated: false)
        print("adding topic")
        if (!multipleSelection) {
            let nc = NotificationCenter.default
            nc.post(name:Notification.Name(rawValue:"topic"),
                    object: nil,
                    userInfo: ["topic": topic as Any])
        }
        else {
            print("selected row")
            if (selectedTopics.contains(topic!)) {
                //remove selected topic
                if let i = selectedTopics.index(of: topic!) {
                    selectedTopics.remove(at: i)
                }
                cell.checkbox.setCheckState(.unchecked, animated: true)
                if (selectedTopics.count == 0) {
                    self.disableBottomButton()
                }
            }
            else {
                //add selected topic
                if (selectedTopics.count <= 3) {
                    selectedTopics.append(topic!)
                    cell.checkbox.setCheckState(.checked, animated: true)
                    self.enableBottomButton()
                }
            }
        }
    }
    @IBAction func dismissView(_ sender: Any) {
        let nc = NotificationCenter.default
        nc.post(name:Notification.Name(rawValue:"topicSignUp"),
                object: nil,
                userInfo: ["topics": self.selectedTopics])
    }
    
    func enableBottomButton() {
        self.bottomButton.backgroundColor = UIColor(red:1.0, green:0.5, blue:0.0, alpha:1.0)
        self.bottomButton.isEnabled = true
    }
    
    func disableBottomButton() {
        self.bottomButton.backgroundColor = UIColor(white:0.3, alpha:1.0)
        self.bottomButton.isEnabled = false
    }
    
}

class DemoPopup2Cell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var checkbox: M13Checkbox!
    override func awakeFromNib() {
        checkbox.animationDuration = 0.5
        checkbox.stateChangeAnimation = .spiral
        for subview in subviews {
            for recognizer in subview.gestureRecognizers ?? [] {
                print("removing")
                subview.removeGestureRecognizer(recognizer)
            }
        }
    }
}
