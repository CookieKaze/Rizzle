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
    var objectId:String?
    
    init(title: String, question: String, answer: String, creator: String, hints: Array<String>) {
        //
        self.title = title as String?
        self.question = question as String?
        self.answer = answer as String?
        self.creator = creator as String?
        self.hints = hints
        
    }
    
    //MARK: Archiving
    required init(coder decoder: NSCoder) {
        self.title = (decoder.decodeObject(forKey: "title") as? String)!
        self.type = answerType(rawValue: (decoder.decodeObject(forKey: "answerType") as? Int)!)
        self.answer = (decoder.decodeObject(forKey: "answer") as? String)!
        self.creator = (decoder.decodeObject(forKey: "creator") as? String)!
        self.createdOn = (decoder.decodeObject(forKey: "createdOn") as? NSDate)!
        self.updatedOn = (decoder.decodeObject(forKey: "updatedOn") as? NSDate)!
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.type, forKey:"answerType")
        coder.encode(self.title, forKey: "title")
        coder.encode(self.question, forKey: "question")
        coder.encode(self.answer, forKey: "answer")
        coder.encode(self.creator, forKey: "creator")
        coder.encode(self.createdOn, forKey: "createdOn")
        coder.encode(self.updatedOn, forKey: "updatedOn")
        
    }
}
