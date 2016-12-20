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
    var rizzleName: String
    var weeklyScore: NSNumber
    var totalScore: NSNumber
    var completedRizzles:Array<String>
    
    init(username: String, rizzleName: String) {
        self.username = username
        self.rizzleName = rizzleName
        self.weeklyScore = NSNumber(integerLiteral: 0)
        self.totalScore = NSNumber(integerLiteral: 0)
        self.completedRizzles = Array<String>(arrayLiteral: "")
    }
    
    
    
    
    //MARK: Archiving
    required init(coder decoder: NSCoder) {
        self.username = (decoder.decodeObject(forKey: "username") as? String)!
        self.rizzleName = (decoder.decodeObject(forKey: "rizzleName") as? String)!
        self.weeklyScore = (decoder.decodeObject(forKey: "weeklyScore") as? NSNumber)!
        self.totalScore = (decoder.decodeObject(forKey: "totalScore") as? NSNumber)!
        self.completedRizzles = (decoder.decodeObject(forKey: "compeletedRizzles") as? Array)!
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.username, forKey: "username")
        coder.encode(self.rizzleName, forKey: "rizzleName")
        coder.encode(self.weeklyScore, forKey: "weeklyScore")
        coder.encode(self.totalScore, forKey: "totalScore")
        coder.encode(self.completedRizzles, forKey: "completedRizzles")
    }
}
