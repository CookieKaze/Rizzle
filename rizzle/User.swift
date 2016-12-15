//
//  User.swift
//  rizzle
//
//  Created by Erin Luu on 2016-12-15.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

import UIKit

class User: NSObject {
    var username: String
    var rizzle_name: String
    var weeklyScore: NSNumber
    var totalScore: NSNumber
    
    init(username: String, rizzle_name: String) {
        self.username = username
        self.rizzle_name = rizzle_name
        self.weeklyScore = NSNumber(integerLiteral: 0)
        self.totalScore = NSNumber(integerLiteral: 0)
    }
}
