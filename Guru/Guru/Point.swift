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
    @NSManaged var fromX: Int
    @NSManaged var toX: Int
    @NSManaged var fromY: Int
    @NSManaged var toY: Int
    @NSManaged var question: PFObject?
    
    class func parseClassName() -> String {
        return "Point"
    }
}
