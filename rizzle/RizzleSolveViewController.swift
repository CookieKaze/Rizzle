//
//  RizzleViewController.swift
//  rizzle
//
//  Created by Matthew Mauro on 2016-12-17.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

import UIKit
import Parse

class RizzleSolveViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: Properties
    var solveRizzle: PFObject?
    var solveRizzleTracker: PFObject?
    var currentUser: PFUser!
    
    var startingLetters = [String]()
    var feedingLetters = [String]()
    var wordBankLimit = 0
    var wordBank = [String]()
    
    @IBOutlet weak var letterBankCollectionView: UICollectionView!
    @IBOutlet weak var titleTextField: UILabel!
    @IBOutlet weak var questionTextView: UITextView!
    
    //MARK: Setup Methods
    override func viewDidLoad() {
        guard let currentUser = PFUser.current() else{
            print("No current user")
            return
        }
        self.currentUser = currentUser
        
        if solveRizzle == nil {
            //Get random Rizzle
            setRandomRizzle()
        }else{
            createSolvedRizzleTracker()
        }
    }
    
    func setRandomRizzle() {
        var solvedRizzleID = [String]()
        // Get all trackers with current user
        let query = PFQuery(className: "SolvedRizzle")
        query.includeKey("rizzle")
        query.whereKey("user", equalTo: currentUser)
        query.findObjectsInBackground(block: { (trackers, error) in
            if error != nil || trackers == nil {
                print("The rizzle request failed.")
            } else {
                for tracker in trackers! {
                    let rizzle = tracker.object(forKey: "rizzle") as! PFObject
                    solvedRizzleID.append(rizzle.objectId!)
                }
                // Get 100 oldest Rizzles that haven't been started
                let query2 = PFQuery(className: "Rizzle")
                query2.whereKey("objectId", notContainedIn: solvedRizzleID)
                query2.order(byAscending: "createdAt")
                query2.limit = 100
                query2.findObjectsInBackground(block: { (rizzles, error) in
                    if error != nil || rizzles == nil {
                        print("The rizzle request failed.")
                    }else {
                        let randomNumber = Int(arc4random_uniform(UInt32(rizzles!.count)))
                        self.solveRizzle = rizzles?[randomNumber]
                        self.createSolvedRizzleTracker()
                    }
                })
            }
        })
    }
    
    func createSolvedRizzleTracker() {
        if solveRizzle != nil {
            let solvedRizzleTracker = PFObject(className:"SolvedRizzle")
            solvedRizzleTracker["user"] = currentUser
            solvedRizzleTracker["rizzle"] = solveRizzle
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
                
                DispatchQueue.main.async {
                    self.setupView()
                }
            })
        }
    }
    
    func setupView() {
        guard let solveRizzle = self.solveRizzle else {
            return
        }
        
        titleTextField.text = solveRizzle.object(forKey: "title") as? String
        questionTextView.text = solveRizzle.object(forKey: "question") as? String
        
        let answer = solveRizzle.object(forKey: "answer") as! String
        //Set Letter Limit
        if answer.characters.count <= 12 {
            wordBankLimit = 12
        } else {
            wordBankLimit = answer.characters.count
        }
        
        //Create letter set
        var wordBank = answer.characters.map({ (character) -> String in
            let letter = String(character).uppercased()
            return letter})
        
        //Remove spaces
        wordBank = wordBank.filter { $0 != " " }
        
        //Scramble and assign sets
        let scrambledAnswer = scrambleLetters(array: wordBank)
        createStartingAndFeedingBanks(scramabledAnswer: scrambledAnswer)
        createWordBank()
        letterBankCollectionView.reloadData()
        
        //Set blank answer blocks
    }
    
    //MARK: Letter Handlers
    func scrambleLetters(array: Array<String>) -> Array<String> {
        var wordBank = [String]()
        for _ in 0..<50
        {
            wordBank = array.sorted { (_,_) in arc4random() < arc4random() }
        }
        return wordBank
    }
    
    func createStartingAndFeedingBanks (scramabledAnswer: Array<String>) {
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
        
        feedingLetters += scramabledAnswer.suffix(removeCount)
        startingLetters += scramabledAnswer.prefix(scramabledAnswer.count-removeCount)
    }
    
    func createWordBank () {
        wordBank += startingLetters
        let missingLetters = wordBankLimit - wordBank.count
        
        let allAlphaCharacters = ["H", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R" ,"S" ,"T" ,"U" ,"V" ,"W" ,"X" ,"Y" ,"Z"]
        
        for _ in 1...missingLetters {
            let randomNumber = Int(arc4random_uniform(UInt32(allAlphaCharacters.count)))
            wordBank.append(allAlphaCharacters[randomNumber])
        }
        
        wordBank = scrambleLetters(array: wordBank)
        print(wordBank)
    }
    
    @IBAction func solveButtonTapped(_ sender: UIButton) {
        print(solveRizzle?.object(forKey: "answer") as! String)
    }
    
    //MARK: Letter Bank Data Source
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wordBank.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = letterBankCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LetterCell
        if wordBank.count != 0 {
            cell.imageView.image = UIImage.init(named: wordBank[indexPath.row])
        }
        return cell
    }
}
