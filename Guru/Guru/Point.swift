//
//  Point.swift
//  Guru
//
//  Created by Dylan Diamond on 1/21/17.
//  Copyright © 2017 Avinash Jain. All rights reserved.
//

import Foundation
import Parse

class Point: PFObject, PFSubclassing {
    @NSManaged var fromX: Double
    @NSManaged var toX: Double
    @NSManaged var fromY: Double
    @NSManaged var toY: Double
    @NSManaged var question: PFObject?
    @NSManaged var red: Double
    @NSManaged var green: Double
    @NSManaged var blue: Double
    @NSManaged var userID: String
    @NSManaged var questionID: String

    
    class func parseClassName() -> String {
        return "Point"
    }
}
