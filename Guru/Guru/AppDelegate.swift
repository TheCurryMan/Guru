//
//  AppDelegate.swift
//  Guru
//
//  Created by Avinash Jain on 1/20/17.
//  Copyright © 2017 Avinash Jain. All rights reserved.
//

import UIKit
import Parse
import OneSignal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Point.registerSubclass()
        let configuration = ParseClientConfiguration {
            $0.applicationId = "Iv8F42WDp3TtmqOXIa7D"
            $0.server = "https://theguruapp.herokuapp.com/parse"
            $0.clientKey = "b1Epo8kZhnQeWnGTOcxH"
        }
        Parse.initialize(with: configuration)
        //        OneSignal.initWithLaunchOptions(launchOptions, appId: "713d5fe7-58ab-4147-ae00-8461c5965335")
        OneSignal.initWithLaunchOptions(launchOptions, appId: "713d5fe7-58ab-4147-ae00-8461c5965335", handleNotificationReceived: { (notification: OSNotification?) in
            self.reactToNotification(notification: notification!)
        }, handleNotificationAction: { (notificationResult: OSNotificationOpenedResult?) in
            self.reactToNotification(notification: notificationResult!.notification!)
        },settings: [kOSSettingsKeyInAppAlerts: OSNotificationDisplayType.none.rawValue])
                
        return true
    }
    
    func reactToNotification(notification: OSNotification) {
        let questionID = notification.payload.additionalData["questionID"] as! String
        let questionObject = PFObject(withoutDataWithClassName: "Question", objectId: questionID)
        questionObject.fetchInBackground(block: { (question: PFObject?, error: Error?) in
            if (question != nil) {
                print("got question for notification")
                let detailVC = self.topMostController().storyboard?.instantiateViewController(withIdentifier: "detailVC") as! AcceptViewController
                detailVC.question = question!
                self.window?.makeKeyAndVisible()
                self.topMostController().present(detailVC, animated: true, completion: nil)
            }
        })
    }
    
    func topMostController() -> UIViewController {
        var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while ((topController?.presentedViewController) != nil) {
            topController = topController?.presentedViewController
        }
        return topController!
    }
    
    
}

