//
//  RizzleManager.swift
//  rizzle
//
//  Created by Erin Luu on 2016-12-22.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

import UIKit
import Parse

class RizzleManager: NSObject {
    //MARK: Shared Instance
    
    static let sharedInstance : RizzleManager = {
        let instance = RizzleManager()
        return instance
    }()
    var currentUser: PFUser!
    var currentRizzlePFObject: PFObject?
    var currentrizzle: Rizzle?
    var currentTracker: PFObject?
    
    var letterBankLimit = 0
    
    private override init() {
        super.init()
        guard let user = PFUser.current() else{
            print("No current user")
            return
        }
        self.currentUser = user
    }
    
    func getRizzle () -> Rizzle? {
        if currentRizzlePFObject != nil {
            //continue rizzle
        }else {
            generateNewRizzle()
            return currentrizzle
        }
        return nil
    }
    
    //MARK: New Rizzle
    func generateNewRizzle() {
        //Declare array of all the rizzle solved by the user
        var solvedRizzleID = [String]()
        // Get all Rizzle trackers with current user
        let query = PFQuery(className: "SolvedRizzle")
        query.includeKey("rizzle")
        query.whereKey("user", equalTo: currentUser)
        
        //Try finding the rizzles solve by the user
        do {
            let trackers = try query.findObjects()
            //For all the user trackers get the rizzle ID of each and put it into an array
            for tracker in trackers {
                let rizzle = tracker.object(forKey: "rizzle") as! PFObject
                solvedRizzleID.append(rizzle.objectId!)
            }
            // Get 100 oldest Rizzles that haven't been started
            let query2 = PFQuery(className: "Rizzle")
            query2.whereKey("objectId", notContainedIn: solvedRizzleID)
            query2.order(byAscending: "createdAt")
            query2.limit = 100
            
            let rizzles = try query2.findObjects()
            //Pick a random rizzle from the bunch and set it as current
            let randomNumber = Int(arc4random_uniform(UInt32(rizzles.count)))
            self.currentRizzlePFObject = rizzles[randomNumber]
            //Create a new tracker for this rizzle and user
            self.createSolvedRizzleTracker()
            self.generateRizzleObject()
        } catch {
            print(error)
        }
        
    }
    
    func createSolvedRizzleTracker() {
        //Check if there is a current Rizzle
        if currentRizzlePFObject != nil {
            //Create a new rizzle trackers for current user
            let solvedRizzleTracker = PFObject(className:"SolvedRizzle")
            solvedRizzleTracker["user"] = currentUser
            solvedRizzleTracker["rizzle"] = currentRizzlePFObject
            solvedRizzleTracker["hint1Used"] = false
            solvedRizzleTracker["hint2Used"] = false
            solvedRizzleTracker["hint3Used"] = false
            solvedRizzleTracker["completed"] = false
            solvedRizzleTracker["score"] = 0
            
            solvedRizzleTracker.saveInBackground(block: { (success, error) in
                if (success) {
                    print("Rizzle tracker saved")
                }else {
                    print("Rizzle tracker no saved")
                }
            })
        }
    }
    
    func generateRizzleObject() {
        let rizzle = Rizzle(title: (currentRizzlePFObject?.object(forKey: "title") as? String)!,
                            question: (currentRizzlePFObject?.object(forKey: "question") as? String)!,
                            answer: (currentRizzlePFObject?.object(forKey: "question") as? String)!,
                            hint1: (currentRizzlePFObject?.object(forKey: "hint1") as? String)!,
                            hint2: (currentRizzlePFObject?.object(forKey: "hint2") as? String)!,
                            hint3: (currentRizzlePFObject?.object(forKey: "hint3") as? String)!,
                            letterBanks: generateLetterBanks()
        )
        currentrizzle = rizzle
    }
    
    func generateLetterBanks () -> Dictionary<String, Array<String>> {
        //Get answer from PFObject
        let answer = currentRizzlePFObject?.object(forKey: "answer") as! String
        
        //Set Letter Limit of how many letters to show in collection view
        if answer.characters.count <= 12 {
            letterBankLimit = 12
        } else {
            letterBankLimit = answer.characters.count
        }
        
        //Take answer and break into array of uppercase characters
        var letterBank = answer.characters.map({ (character) -> String in
            let letter = String(character).uppercased()
            return letter})
        
        //Remove all spaces from letterBank
        letterBank = letterBank.filter { $0 != " " }
        
        //Scramble the letterBank
        let scrambledAnswer = scrambleLetters(array: letterBank)
        
        //Breaking letterBank into starter and feeder sets
        var letterSets = [String: Array<String>]()
        letterSets = createStartingAndFeedingBanks(scramabledAnswer: scrambledAnswer)
        letterSets["answerLetterBank"] = letterBank
        
        return letterSets
    }
    
    
    //MARK: Letter Handlers
    func scrambleLetters(array: Array<String>) -> Array<String> {
        var letterBank = [String]()
        for _ in 0..<50
        {
            letterBank = array.sorted { (_,_) in arc4random() < arc4random() }
        }
        return letterBank
    }
    
    func createStartingAndFeedingBanks (scramabledAnswer: Array<String>) -> Dictionary<String, Array<String>> {
        //Create empty start and feeder arrays
        var feedingLetters = [String]()
        var startingLetters = [String]()
        
        //Based on length of the string, set how many letters to take out
        let removeCount: Int!
        if scramabledAnswer.count <= 5 {
            removeCount = 0
        }else if scramabledAnswer.count <= 6 {
            removeCount = 1
        }else if scramabledAnswer.count <= 10 {
            removeCount = 2
        }else {
            removeCount = 3
        }
        
        //Remove letters from starting and put into feeder
        feedingLetters += scramabledAnswer.suffix(removeCount)
        startingLetters += scramabledAnswer.prefix(scramabledAnswer.count-removeCount)
        
        //Create return dictionary
        let banks: [String: Array] = ["feedingLetterBank": feedingLetters, "startingLetterBank": startingLetters]
        return banks
    }
    
    //MARK: Continue Rizzle

}
