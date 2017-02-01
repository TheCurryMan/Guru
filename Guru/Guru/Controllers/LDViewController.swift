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
    @IBOutlet var colorButtons: [UIButton]!
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
    
    // MARK: - Init Functions
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {

        universalColorR=255
        universalColorG=0
        universalColorB=0
        pencilIcon.alpha = 0
        pencilIcon.isEnabled = false
        bigCircle.alpha=0
        self.hideButtons()

        pencilIcon.setImage(pencilIcon.image(for: .normal)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
        pencilIcon.tintColor = UIColor.init(red: universalColorR, green: universalColorG, blue: universalColorB, alpha: 1)
        
        pointQuery = (Point.query()?
            .whereKey("userID", notEqualTo: PFUser.current()!.objectId!).whereKey("questionID", equalTo: self.question.objectId!)) as! PFQuery<Point>
        self.subscribeLiveQuery()
        
        self.imageView.layer.contentsScale = UIScreen.main.scale
        
        for colorButton in self.colorButtons {
            colorButton.setRounded()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("disconnecting from live query server")
        self.disconnectFromServer()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
        }
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
    
    // MARK: - Live Query Functions

    func subscribeLiveQuery(){
        
        subscriptionQuery = liveQueryClient.subscribe(pointQuery).handle(Event.created, { (query: PFQuery<Point>, point: Point) in
            
        DispatchQueue.main.async {
                self.drawLines(fromPoint: CGPoint(x: point.fromX, y: point.fromY), toPoint: CGPoint(x: point.toX, y: point.toY))
                self.universalColorR = CGFloat(point.red)
                self.universalColorG = CGFloat(point.green)
                self.universalColorB = CGFloat(point.blue)
                
                print("BOUNCE: FROM (\(point.fromX), \(point.fromY)) \n TO (\(point.toX), \(point.toY))" )
                self.imageView.setNeedsDisplay()
            }
        })
    }
    
    func sendPointData(fromX:Double, fromY:Double, toX:Double, toY:Double)
    {
        let point = Point()
        point.fromX = fromX
        point.fromY = fromY
        point.toX = toX
        point.toY = toY
        point.userID = PFUser.current()!.objectId!
        point.questionID = self.question.objectId!
        point.red = Double(universalColorR)
        point.green = Double(universalColorG)
        point.blue = Double(universalColorB)
        
        point.saveInBackground {
            (success, error) -> Void in
            if (success) {
                print("Sent Point")
            }
        }
    }
    
    func disconnectFromServer() {
        liveQueryClient.unsubscribe(pointQuery, handler: subscriptionQuery!)
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
    
    func redrawPencilIcon()
    {
        pencilIcon.setImage(pencilIcon.image(for: .normal)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
        pencilIcon.tintColor = UIColor.init(red: universalColorR, green: universalColorG, blue: universalColorB, alpha: 1)
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
                self.pencilIcon.alpha=1
                self.pencilIcon.isEnabled=true
                self.toggleButton.setImage(UIImage(named:"white_down.png"), for: UIControlState.normal)
            })
            toggleStatus=1
        case 1:
            UIView.animate(withDuration: 1.2, animations: {
                
                self.imageView.center.y=626+(self.imageView.frame.height/2)
                self.imageView.alpha=0;
                self.resetButton.alpha=0
                self.resetButton.isEnabled=false
                self.pencilIcon.alpha=0
                self.pencilIcon.isEnabled=false
                self.toggleButton.setImage(UIImage(named:"white_up.png"), for: UIControlState.normal)
            })
            toggleStatus=0
        default:
            print("error")
        }
    }
    
    @IBAction func reset(_ sender: AnyObject) {
        self.imageView.image = nil
    }

    @IBAction func button1Pressed(_ sender: Any) {
        universalColorR=255
        universalColorG=0
        universalColorB=0
        self.redrawPencilIcon()
    }
    
    @IBAction func button2Pressed(_ sender: Any) {
        universalColorR=0
        universalColorG=255
        universalColorB=0
        self.redrawPencilIcon()

    }
    
    @IBAction func button3Pressed(_ sender: Any) {
        universalColorR=0
        universalColorG=0
        universalColorB=255
        self.redrawPencilIcon()
    }
    
    @IBAction func button4Pressed(_ sender: Any) {
        universalColorR=0
        universalColorG=0
        universalColorB=0
        self.redrawPencilIcon()
    }
    
    @IBAction func pressedPencil(_ sender: Any) {
        print("pressedPencil")
        
        switch circleOut {
        case false:
            UIView.animate(withDuration: 1, animations: {
                self.showButtons()
                self.bigCircle.alpha=1
                self.circleOut=true
            })

        case true:
            UIView.animate(withDuration: 1, animations: {
                self.hideButtons()
                self.bigCircle.alpha=0
                self.circleOut=false
            })
        }
    }
    
    
    func hideButtons() {
        for colorButton in self.colorButtons {
            colorButton.isEnabled = false
            colorButton.alpha = 0
        }
    }
    
    func showButtons() {
        for colorButton in self.colorButtons {
            colorButton.isEnabled = true
            colorButton.alpha = 1
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
