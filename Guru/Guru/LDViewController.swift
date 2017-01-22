//
//  LDViewController.swift
//  Guru
//
//  Created by Brian Lin on 1/21/17.
//  Copyright © 2017 Avinash Jain. All rights reserved.
//

import UIKit
import Parse
import ParseLiveQuery


let liveQueryClient = ParseLiveQuery.Client()

class LDViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var swipeUpRec: UISwipeGestureRecognizer!
    @IBOutlet var swipeDownRec: UISwipeGestureRecognizer!
    @IBOutlet var resetButton: UIButton!
    @IBOutlet weak var toggleButton: UIButton!
    var question: PFObject!
    
    var lastPoint = CGPoint.zero
    var swiped = false
    var red:CGFloat = 0.0
    var green:CGFloat = 0.0
    var blue:CGFloat = 0.0
    var tool:UIImageView!
    var selectedImage:UIImage!
    var toggleStatus=0
    
    var subscriptionQuery: Subscription<Point>?
    
    var pointQuery: PFQuery<Point>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        pointQuery = (Point.query()?
            .whereKey("userID", notEqualTo: PFUser.current()!.objectId!).whereKey("questionID", equalTo: self.question.objectId!)) as! PFQuery<Point>
        self.subscribeLiveQuery()
        self.imageView.layer.contentsScale = UIScreen.main.scale
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("disconnecting from live query server")
        self.disconnectFromServer()
    }
    
    func subscribeLiveQuery(){
        
        subscriptionQuery = liveQueryClient.subscribe(pointQuery).handle(Event.created, { (query: PFQuery<Point>, point: Point) in
            
            DispatchQueue.main.async {
                self.drawLines(fromPoint: CGPoint(x: point.fromX, y: point.fromY), toPoint: CGPoint(x: point.toX, y: point.toY))
                print("BOUNCE: FROM (\(point.fromX), \(point.fromY)) \n TO (\(point.toX), \(point.toY))" )
                self.imageView.setNeedsDisplay()
            }
        })
    }
    
    func sendPointData(fromX:Double, fromY:Double, toX:Double, toY:Double)
    {
        //        print("INITIATED POINT SENDING")
        
        let Point_PFOBJ = PFObject(className:"Point")
        Point_PFOBJ["fromX"] = fromX
        Point_PFOBJ["fromY"] = fromY
        Point_PFOBJ["toX"] = toX
        Point_PFOBJ["toY"] = toY
        Point_PFOBJ["userID"] = PFUser.current()!.objectId!
        Point_PFOBJ["questionID"] = self.question.objectId!
        
        Point_PFOBJ.saveInBackground {
            (success, error) -> Void in
            if (success) {
                print("SP")
            } else {
            }
        }
    }
    
    
    func disconnectFromServer() {
        liveQueryClient.unsubscribe(pointQuery, handler: subscriptionQuery!)
    }
    
    // MARK: - IBACTIONS
    
    @IBAction func togglePressed(_ sender: Any) {
        switch toggleStatus {
        case 0:
            UIView.animate(withDuration: 1, animations: {
                self.imageView.center.y=0+(self.imageView.frame.height/2)
                self.imageView.alpha=1;
                self.resetButton.alpha=1
                self.resetButton.isEnabled=true
                self.toggleButton.setImage(UIImage(named:"white_down.png"), for: UIControlState.normal)
            })
            toggleStatus=1
            
        case 1:
            UIView.animate(withDuration: 1.2, animations: {
                
                self.imageView.center.y=626+(self.imageView.frame.height/2)
                self.imageView.alpha=0;
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
        UIView.animate(withDuration: 1, animations: {
            self.imageView.center.y=0+(self.imageView.frame.height/2)
            self.resetButton.alpha=1
            self.resetButton.isEnabled=true
        })
    }
    
    @IBAction func swipedDown(_ sender: Any) {
        print("swipedDown")
        UIView.animate(withDuration: 1.2, animations: {
            self.imageView.center.y=545+(self.imageView.frame.height/2)
            self.resetButton.alpha=0
            self.resetButton.isEnabled=false
        })
    }
    
    // MARK: - Init Functions
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
        }
        
    }
    
    func drawLines(fromPoint:CGPoint,toPoint:CGPoint) {
        
        print("drawing points")
        UIGraphicsBeginImageContext(self.view.frame.size)
        imageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        let context = UIGraphicsGetCurrentContext()
        
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y/self.view.frame.height*imageView.frame.height))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y/self.view.frame.height*imageView.frame.height))
        
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y/self.view.frame.height*imageView.frame.height))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y/self.view.frame.height*imageView.frame.height))
        
        context?.setBlendMode(CGBlendMode.normal)
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(5)
        context?.setStrokeColor(UIColor(red: 255, green: 0, blue: 0, alpha: 1.0).cgColor)
        
        context?.strokePath()
        
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        
        if let touch = touches.first {
            let currentPoint = touch.location(in: self.view)
            if (self.toggleStatus == 1) {
                sendPointData(fromX: Double(lastPoint.x), fromY: Double(lastPoint.y), toX: Double(currentPoint.x), toY: Double(currentPoint.y))
                drawLines(fromPoint: lastPoint, toPoint: currentPoint)
            }
            
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
    //
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
