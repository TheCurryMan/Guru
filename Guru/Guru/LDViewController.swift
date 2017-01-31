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
    @IBOutlet weak var pencilIcon: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var bigCircle: UIImageView!

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var swipeUpRec: UISwipeGestureRecognizer!
    @IBOutlet var swipeDownRec: UISwipeGestureRecognizer!
    @IBOutlet var resetButton: UIButton!
    @IBOutlet weak var toggleButton: UIButton!
    var question: PFObject!
    
    var lastPoint = CGPoint.zero
    var swiped = false
    var circleOut = false
    var red:CGFloat = 0.0
    var green:CGFloat = 0.0
    var blue:CGFloat = 0.0
    var tool:UIImageView!
    var selectedImage:UIImage!
    var toggleStatus=0
    var universalColorR:CGFloat=0;
    var universalColorG:CGFloat=0;
    var universalColorB:CGFloat=0;

    
    var subscriptionQuery: Subscription<Point>?
    
    var pointQuery: PFQuery<Point>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {

        universalColorR=255;
        universalColorG=0;
        universalColorB=0;
        button1.alpha=0;
        button2.alpha=0;
        button3.alpha=0;
        button4.alpha=0;
//        button1.isEnabled = false
//        button2.isEnabled = false
//        button3.isEnabled = false
//        button4.isEnabled = false
        bigCircle.alpha=0

        pencilIcon.setImage(pencilIcon.image(for: .normal)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
        pencilIcon.tintColor = UIColor.init(red: universalColorR, green: universalColorG, blue: universalColorB, alpha: 1)
        
        
//        pointQuery = (Point.query()?
//            .whereKey("userID", notEqualTo: PFUser.current()!.objectId!).whereKey("questionID", equalTo: self.question.objectId!)) as! PFQuery<Point>
//        self.subscribeLiveQuery()
        
        self.imageView.layer.contentsScale = UIScreen.main.scale
        
        self.setUpColorBubbles()
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
        context?.setStrokeColor(UIColor(red: universalColorR, green: universalColorG, blue: universalColorB, alpha: 1.0).cgColor)
        
        context?.strokePath()
        
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        
        if let touch = touches.first {
            let currentPoint = touch.location(in: self.view)
            if (self.toggleStatus == 1) {
                
//                sendPointData(fromX: Double(lastPoint.x), fromY: Double(lastPoint.y), toX: Double(currentPoint.x), toY: Double(currentPoint.y))
                drawLines(fromPoint: lastPoint, toPoint: currentPoint)
            }
            
            lastPoint = currentPoint
        }
    }
    
    func setUpColorBubbles()
    {
        button1.setImage(button1.image(for: .normal)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
        button1.tintColor = UIColor.init(red: 255, green: 0, blue: 0, alpha: 1)
        
        button2.setImage(button2.image(for: .normal)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
        button2.tintColor = UIColor.init(red: 0, green: 255, blue: 0, alpha: 1)
        
        button3.setImage(button3.image(for: .normal)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
        button3.tintColor = UIColor.init(red: 0, green: 0, blue: 255, alpha: 1)
        
        button4.setImage(button4.image(for: .normal)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
        button4.tintColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            drawLines(fromPoint: lastPoint, toPoint: lastPoint)
        }
    }
    @IBAction func reset(_ sender: AnyObject) {
        self.imageView.image = nil
    }

    @IBAction func button1Pressed(_ sender: Any) {
        //255,0,0
        universalColorR=255;
        universalColorG=0;
        universalColorB=0;
        self.redrawPencilIcon()
    }
    
    @IBAction func button2Pressed(_ sender: Any) {
        //0,255,0
        universalColorR=0;
        universalColorG=255;
        universalColorB=0;
        self.redrawPencilIcon()

    }
    
    @IBAction func button3Pressed(_ sender: Any) {
        //0,0,255
        universalColorR=0;
        universalColorG=0;
        universalColorB=255;
        self.redrawPencilIcon()

    }
    
    @IBAction func button4Pressed(_ sender: Any) {
        //0,0,0
        universalColorR=0;
        universalColorG=0;
        universalColorB=0;
        self.redrawPencilIcon()

    }
    
    @IBAction func pressedPencil(_ sender: Any) {
        print("pressedPencil")
        
        switch circleOut {
        case false:
            UIView.animate(withDuration: 1, animations: {
                self.button1.alpha=1;
                self.button2.alpha=1;
                self.button3.alpha=1;
                self.button4.alpha=1;
                self.button1.isEnabled = true
                self.button2.isEnabled = true
                self.button3.isEnabled = true
                self.button4.isEnabled = true
                self.bigCircle.alpha=1
                self.circleOut=true
            })

        case true:
            UIView.animate(withDuration: 1, animations: {
         
                self.circleOut=false
                self.button1.isEnabled = false
                self.button2.isEnabled = false
                self.button3.isEnabled = false
                self.button4.isEnabled = false
                self.button1.alpha=0;
                self.button2.alpha=0;
                self.button3.alpha=0;
                self.button4.alpha=0;
                self.bigCircle.alpha=0
            })
        }
    }
    
    func redrawPencilIcon()
    {
        pencilIcon.setImage(pencilIcon.image(for: .normal)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
        pencilIcon.tintColor = UIColor.init(red: universalColorR, green: universalColorG, blue: universalColorB, alpha: 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
