//
//  CreateRizzleManager.swift
//  rizzle
//
//  Created by Erin Luu on 2017-01-18.
//  Copyright © 2017 Erin Luu. All rights reserved.
//

import UIKit

class CreateRizzleManager: NSObject {
    //MARK: Shared Instance
    static let sharedInstance : CreateRizzleManager = {
        let instance = CreateRizzleManager()
        return instance
    }()
    
    var rizzleType: String?
    var title: String?
    var question: String?
    var image: UIImage?
    var answer: String?
    var explanation: String?
    var difficulty: Int?
    
    var hint1: String?
    var hint2: String?
    var hint3: String?
    
    var multipleAnswer1: String?
    var multipleAnswer2: String?
    var multipleAnswer3: String?
    var multipleAnswer4: String?
    
    private override init() {
        super.init()
        
    }
    
    func clearProperties() {
        rizzleType = nil
        title = nil
        question = nil
        image  = nil
        answer  = nil
        explanation = nil
        difficulty = nil
        hint1 = nil
        hint2 = nil
        hint3 = nil
        multipleAnswer1 = nil
        multipleAnswer2 = nil
        multipleAnswer3 = nil
        multipleAnswer4 = nil
    }
}
