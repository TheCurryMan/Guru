//
//  LDViewController.swift
//  Guru
//
//  Created by Brian Lin on 1/21/17.
//  Copyright © 2017 Avinash Jain. All rights reserved.
//

import UIKit
import Parse

class LDViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var swipeUpRec: UISwipeGestureRecognizer!
    @IBOutlet var swipeDownRec: UISwipeGestureRecognizer!
    @IBOutlet var resetButton: UIButton!
    @IBOutlet weak var toggleButton: UIButton!

    var lastPoint = CGPoint.zero
    var swiped = false
    var red:CGFloat = 0.0
    var green:CGFloat = 0.0
    var blue:CGFloat = 0.0
    var tool:UIImageView!
    var isDrawing = true
    var selectedImage:UIImage!
    var Drawing=false
    var toggleStatus=0
    
    @IBAction func togglePressed(_ sender: Any) {
        switch toggleStatus {
        case 0:
            UIView.animate(withDuration: 1.2, animations: {
                self.imageView.center.y=0+(self.imageView.frame.height/2)
                self.imageView.alpha=0.6;
                self.Drawing=true
                self.resetButton.alpha=1
                self.resetButton.isEnabled=true
                self.toggleButton.setImage(UIImage(named:"white_down.png"), for: UIControlState.normal)
            })
            toggleStatus=1

        case 1:
            UIView.animate(withDuration: 1.2, animations: {

                self.imageView.center.y=626+(self.imageView.frame.height/2)
                self.imageView.alpha=0.1;
                self.Drawing=false
                self.resetButton.alpha=0
                self.resetButton.isEnabled=false
                self.toggleButton.setImage(UIImage(named:"white_up.png"), for: UIControlState.normal)
            })
            toggleStatus=0

        default:
            print("error")
        }
    }
 
    @IBAction func swipedUp(_ sender: Any) {
        print("SwipedUp")
        UIView.animate(withDuration: 1.2, animations: {
            self.imageView.center.y=0+(self.imageView.frame.height/2)
            self.Drawing=true
            self.resetButton.alpha=1
            self.resetButton.isEnabled=true
        })
    }
    
    @IBAction func swipedDown(_ sender: Any) {
        print("swipedDown")
        UIView.animate(withDuration: 1.2, animations: {
            self.imageView.center.y=545+(self.imageView.frame.height/2)
            self.Drawing=false
            self.resetButton.alpha=0
            self.resetButton.isEnabled=false
        })
    }
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
        }
        
    }
    
    func drawLines(fromPoint:CGPoint,toPoint:CGPoint) {
        if Drawing {
      
        UIGraphicsBeginImageContext(self.view.frame.size)
        imageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        let context = UIGraphicsGetCurrentContext()
        
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y/self.view.frame.height*imageView.frame.height))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y/self.view.frame.height*imageView.frame.height))
        
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y/self.view.frame.height*imageView.frame.height))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y/self.view.frame.height*imageView.frame.height))
        
        context?.setBlendMode(CGBlendMode.normal)
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(3)
        context?.setStrokeColor(UIColor(red: 255, green: 0, blue: 0, alpha: 1.0).cgColor)
        
        context?.strokePath()
        
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
            
            
        }
    }
    
    func subscribeLiveQuery(){
        let myQuery = Message.query()!.where(....)
        let subscription: Subscription<Message> = myQuery.subscribe()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        
        if let touch = touches.first {
            let currentPoint = touch.location(in: self.view)
            drawLines(fromPoint: lastPoint, toPoint: currentPoint)
            
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            drawLines(fromPoint: lastPoint, toPoint: lastPoint)
        }
    }
    @IBAction func reset(_ sender: AnyObject) {
        self.imageView.image = nil
    }
    
//    func save(_ sender: AnyObject) {
//        
//        let actionSheet = UIAlertController(title: "Pick your option", message: "", preferredStyle: .actionSheet)
//        actionSheet.addAction(UIAlertAction(title: "Pick an image", style: .default, handler: { (_) in
//            
//            let imagePicker = UIImagePickerController()
//            imagePicker.sourceType = .photoLibrary
//            imagePicker.allowsEditing = false
//            
//            self.present(imagePicker, animated: true, completion: nil)
//            
//        }))
//        actionSheet.addAction(UIAlertAction(title: "Save your drawing", style: .default, handler: { (_) in
//            if let image = self.imageView.image {
//                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//            }
//        }))
//        
//        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
//        
//        present(actionSheet, animated: true, completion: nil)
//        
//    }
//    @IBAction func erase(_ sender: AnyObject) {
//        
//        if (isDrawing) {
//            (red,green,blue) = (1,1,1)
//            
//        } else {
//            (red,green,blue) = (0,0,0)
//        }
//        
//        isDrawing = !isDrawing
//        
//    }
//
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
