//
//  Review.swift
//  Guru
//
//  Created by Avinash Jain on 1/31/17.
//  Copyright © 2017 Avinash Jain. All rights reserved.
//

import Foundation
import Parse

class Review: PFObject, PFSubclassing {
    @NSManaged var rating: Int
    @NSManaged var question: PFObject?
    
    class func parseClassName() -> String {
        return "Review"
    }
}
