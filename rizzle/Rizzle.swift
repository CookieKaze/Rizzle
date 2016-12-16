//
//  Rizzle.swift
//  rizzle
//
//  Created by Matthew Mauro on 2016-12-16.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

import UIKit

public enum answerType : Int {
    
    case multipleChoice = 0
    case stringAnswer = 1
    case numberAnswer = 2
    
}

class Rizzle: NSObject {
    
    var type:answerType?
    var title:String?
    var question:String?
    var answer:String?
    var creator:String?
    var createdOn:NSDate?
    var updatedOn:NSDate?
    var hints:Array<String>?
    
    init(title: String, question: String, answer: String, creator: String, hints: Array<String>) {
        //
        self.title = title as String?
        self.question = question as String?
        self.answer = answer as String?
        self.creator = creator as String?
        self.hints = hints
        
    }
    
}
