//
//  RizzleManager.swift
//  rizzle
//
//  Created by Erin Luu on 2016-12-22.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

import UIKit
import Parse

protocol RizzleSolverDelegate {
    func setCurrentRizzle(rizzle: Rizzle)
    func updateLoadStatus(update: String)
    func setCurrentScore()
    func noRizzleDismiss()
}

class RizzleManager: NSObject {
    //MARK: Shared Instance
    
    static let sharedInstance : RizzleManager = {
        let instance = RizzleManager()
        return instance
    }()
    
    //MARK: Properties
    let defaultScore = 50
    let hintUnlockCost = 10
    let incorrectScoreDeduction = 2
    let minimumScore = 10
    var letterBankLimit = 0
    
    var currentScore = 0
    var maxScore = 0
    var difficultyLevel = 1
    
    var delegate: RizzleSolverDelegate?
    var currentUser: PFUser!
    var currentRizzlePFObject: PFObject?
    var currentRizzle: Rizzle?
    var currentTracker: PFObject?
    var solvedRizzleIDs: Array<String>?
    
    
    
    private override init() {
        super.init()
        guard let user = PFUser.current() else{
            print("No current user")
            return
        }
        self.currentUser = user
    }
    
    func resetManager() {
        currentScore = 0
        maxScore = 0
        difficultyLevel = 1
        
        currentRizzlePFObject = nil
        currentRizzle = nil
        currentTracker = nil
        solvedRizzleIDs = nil
        
        
    }
    
    //MARK: New Rizzle
    func generateNewRizzle() {
        resetManager()
        let rizzleQueue = DispatchQueue(label: "rizzleQueue", qos: .userInitiated)
        
        //Get solved Rizzles
        rizzleQueue.async {
            self.findSolvedRizzleIDs()
        }
        
        //Get Unsolved Rizzles
        rizzleQueue.async {
            if self.solvedRizzleIDs != nil {
                if self.findRandomUnsolvedRizzle() {
                    //Create a new tracker for this rizzle and user.
                    if self.currentRizzlePFObject != nil {
                        
                        //Setup original score.
                        self.difficultyLevel = self.currentRizzlePFObject?["difficultyLevel"] as! Int
                        self.currentScore = self.defaultScore * self.difficultyLevel
                        self.maxScore = self.defaultScore * self.difficultyLevel
                        
                        self.createSolvedRizzleTracker()
                        self.generateRizzleObject()
                        //Set Rizzle in SolverDelegate
                        if self.currentRizzle != nil {
                            DispatchQueue.main.async {
                                self.delegate?.setCurrentRizzle(rizzle: self.currentRizzle!)
                            }
                        }
                    }
                    
                }
            }
        }
        
        
    }
    
    func findSolvedRizzleIDs(){
        // Get all Rizzle trackers with current user
        let query = PFQuery(className: "SolvedRizzle")
        query.includeKey("rizzle")
        query.whereKey("user", equalTo: currentUser)
        
        //Try finding the rizzles solve by the user
        do {
            let objects = try query.findObjects()
            
            //Declare array of all the rizzle solved by the user
            var solvedRizzleID = [String]()
            
            //For all the user trackers get the rizzle ID of each and put it into an array
            for tracker in objects {
                let rizzle = tracker.object(forKey: "rizzle") as! PFObject
                solvedRizzleID.append(rizzle.objectId!)
            }
            
            self.solvedRizzleIDs = solvedRizzleID
            
        } catch {
            print("Problem finding solved rizzles \(error)")
        }
    }
    
    func findRandomUnsolvedRizzle() -> Bool{
        var success = true
        // Get 100 oldest Rizzles that haven't been started
        let query = PFQuery(className: "Rizzle")
        query.whereKey("objectId", notContainedIn: self.solvedRizzleIDs!)
        query.whereKey("user", notEqualTo: currentUser)
        query.order(byAscending: "createdAt")
        query.limit = 100
        
        do {
            let rizzles = try query.findObjects()
            if rizzles.count != 0 {
                let randomNumber = Int(arc4random_uniform(UInt32((rizzles.count))))
                self.currentRizzlePFObject = rizzles[randomNumber]
            } else {
                print("More rizzles coming soon!")
                DispatchQueue.main.async {
                    self.delegate?.noRizzleDismiss()
                }
                success = false
            }
        } catch {
            print("Problem finding new rizzles \(error)")
        }
        return success
    }
    
    func createSolvedRizzleTracker() {
        //Create a new rizzle trackers for current user
        let solvedRizzleTracker = PFObject(className:"SolvedRizzle")
        solvedRizzleTracker["user"] = currentUser
        solvedRizzleTracker["rizzle"] = currentRizzlePFObject
        solvedRizzleTracker["hint1Used"] = false
        solvedRizzleTracker["hint2Used"] = false
        solvedRizzleTracker["hint3Used"] = false
        solvedRizzleTracker["completed"] = false
        solvedRizzleTracker["score"] = currentScore
        
        solvedRizzleTracker.saveInBackground(block: { (success, error) in
            if (success) {
                print("Rizzle tracker saved")
                self.currentTracker = solvedRizzleTracker
            }else {
                print("Rizzle tracker no saved")
            }
        })
    }
    
    //MARK: Continue Rizzle
    func continueRizzle(rizzle: PFObject, tracker: PFObject) {
        resetManager()
        let rizzleQueue = DispatchQueue(label: "rizzleQueue", qos: .userInitiated)
        
        currentRizzlePFObject = rizzle
        currentTracker = tracker
        
        //Setup original score.
        self.difficultyLevel = self.currentRizzlePFObject?["difficultyLevel"] as! Int
        self.currentScore = currentTracker?.object(forKey: "score") as! Int
        self.maxScore = self.defaultScore * self.difficultyLevel
        
        self.generateRizzleObject()
        
        //Set Rizzle in SolverDelegate
        rizzleQueue.async {
            if self.currentRizzle != nil {
                DispatchQueue.main.async {
                    self.delegate?.setCurrentRizzle(rizzle: self.currentRizzle!)
                }
            }
        }
    }
    
    //MARK: Generators
    func generateRizzleObject() {
        let rizzle = Rizzle(title: (currentRizzlePFObject?.object(forKey: "title") as? String)!,
                            question: (currentRizzlePFObject?.object(forKey: "question") as? String)!,
                            answer: (currentRizzlePFObject?.object(forKey: "answer") as? String)!,
                            explanation: (currentRizzlePFObject?.object(forKey: "explanation") as? String) ?? "No Solution Explanation.",
                            hint1: (currentRizzlePFObject?.object(forKey: "hint1") as? String) ?? "No Hints Available",
                            hint2: (currentRizzlePFObject?.object(forKey: "hint2") as? String) ?? "No Hints Available",
                            hint3: (currentRizzlePFObject?.object(forKey: "hint3") as? String) ?? "No Hints Available",
                            letterBanks: generateLetterBanks(),
                            creator: (currentRizzlePFObject?.object(forKey: "user") as? PFUser)!
        )
        print("Generated Rizzle")
        if currentRizzlePFObject?["imageFile"] != nil {
            do {
                let rizzleImageFile = currentRizzlePFObject?["imageFile"] as! PFFile
                let imageData = try rizzleImageFile.getData()
                let image = UIImage(data:imageData)
                rizzle.image = image
            }catch{
                print("Could not get rizzle image")
            }
        }
        currentRizzle = rizzle
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
    
    //MARK: Score Handler
    func incorrectGuess() {
        difficultyLevel = self.currentRizzlePFObject?["difficultyLevel"] as! Int
        if currentScore - incorrectScoreDeduction * difficultyLevel >= minimumScore * difficultyLevel {
            currentScore -= incorrectScoreDeduction * difficultyLevel
        }
        
        //Save to DB
        guard let currentTracker = currentTracker else { return }
        currentTracker["score"] = currentScore
        currentTracker.saveInBackground { (success, error) in
            if error != nil {
                print(error!)
            }
        }
    }
    
    func correctGuess() {
        guard let currentTracker = currentTracker else { return }
        
        //Update and save rizzle tracker
        currentTracker["score"] = currentScore
        currentTracker["completed"] = true
        currentTracker.saveInBackground()
        
        //Save user score
        var score = currentUser["totalScore"] as! Int
        score += currentScore
        currentUser["totalScore"] = score
        currentUser.saveInBackground()
    }
    
    //MARK: Hint Handler
    func unlockHint(hint: Int) {
        guard let currentTracker = currentTracker else { return }
        
        //Update Rizzle tracker
        switch hint {
        case 1:
            currentTracker["hint1Used"] = true
            break
        case 2:
            currentTracker["hint2Used"] = true
            break
        case 3:
            currentTracker["hint3Used"] = true
            break
        default:
            break
        }
        
        if currentScore > (difficultyLevel * hintUnlockCost) + minimumScore {
            currentScore -= difficultyLevel * hintUnlockCost
        }
        currentTracker["score"] = currentScore
        delegate?.setCurrentScore()
        
        
        //Save Rizzle tracker
        currentTracker.saveInBackground { (success, error) in
            if error != nil {
                print(error!)
            }
        }
    }
}
