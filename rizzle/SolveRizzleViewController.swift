//
//  RizzleViewController.swift
//  rizzle
//
//  Created by Matthew Mauro on 2016-12-17.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

import UIKit
import Parse

class SolveRizzleViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: Properties
    var solveRizzle: PFObject?
    var solveRizzleTracker: PFObject?
    var currentUser: PFUser!
    
    @IBOutlet weak var letterBankCollectionView: UICollectionView!
    @IBOutlet weak var titleTextField: UILabel!
    @IBOutlet weak var questionTextView: UITextView!
    
    //MARK: Methods
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
        self.titleTextField.text = self.solveRizzle?.object(forKey: "title") as? String
        self.questionTextView.text = self.solveRizzle?.object(forKey: "question") as? String
    }
    
    //    func scrambleLetters {
    //
    //    }
    
    //MARK: Letter Bank Data Source
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = letterBankCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LetterCell
        return cell
    }
    
    
    //    @IBOutlet weak var rizzleTitle: UILabel!
    //    @IBOutlet weak var rizzleDescription: UITextView!
    //    @IBOutlet weak var hintsRemainingLabel: UILabel!
    //    @IBOutlet weak var dismissButton: UIButton!
    //
    //    @IBOutlet weak var letterBankCollection: UICollectionView!
    //    @IBOutlet weak var answerCollection: UICollectionView!
    //
    //    var hintNumber:NSInteger?
    //    @IBOutlet weak var hintLabel: UILabel!
    //    @IBOutlet weak var solvedImage: UIImageView!
    //    @IBOutlet weak var bank: LetterBank!
    //
    //    public var currentRizzle:Rizzle?
    //
    //    var answerArray = NSMutableArray()
    //    var user:PFUser?
    //
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //
    //        self.bank.currentRizzle = self.currentRizzle
    //        // 'bank' is still set to create Dummy values for testing at this point
    //        guard let currentUser = PFUser.current() else{
    //            print("No current user")
    //            return
    //        }
    //        self.user = currentUser
    //
    //        self.rizzleTitle.text = self.currentRizzle?.title
    //        self.rizzleDescription.text = self.currentRizzle?.question
    //        answerCollection.dataSource = self
    //        letterBankCollection.dataSource = self.bank
    //        self.bank.delegate = self
    //
    //    }
    //    func enterCellIntoAnswer(_cell: UICollectionViewCell){
    //        self.answerArray.add(_cell)
    //        self.reloadInputViews()
    //        if self.answerArray.count == (self.currentRizzle?.answer?.characters.count)! {
    //            let solved = self.checkAnswer()
    //            if solved == true{
    //                self.rizzleTitle.text = "SOLVED!"
    //                self.bank.characterArray.removeAllObjects()
    //                // render letterBank and answerArray to unInteractable
    //                var completed = self.user?.object(forKey: "completedRizzles") as! Array<String>
    //                completed.append(String(format: "%@", (self.currentRizzle?.objectId)!))
    //
    //                self.user?.saveInBackground(block: { (success, error) in
    //                    if error != nil {
    //                        print(error!)
    //                    }else {
    //                        print("solved Rizzle ID stored")
    //                    }
    //                })
    //
    //                self.solvedImage.backgroundColor = UIColor.blue
    //                self.solvedImage.image = UIImage(named: "solved")
    //                self.solvedImage.isHidden = false
    //
    //
    //                UIView.animate(withDuration: 1.5, animations: {
    //                    self.solvedImage.isHidden = true
    //                })
    //
    //            }else{
    //                // answer field red. possibly offer a hint?
    //                self.answerCollection.backgroundColor = UIColor.red
    //                self.solvedImage.backgroundColor = UIColor.red
    //                self.solvedImage.image = UIImage(named: "incorrect")
    //                self.solvedImage.isHidden = false
    //
    //                UIView.animate(withDuration: 1.5, animations: {
    //                    self.solvedImage.isHidden = true
    //                })
    //            }
    //        }
    //        self.reloadInputViews()
    //    }
    //    func checkAnswer() -> Bool{
    //        var solved:Bool = false
    //        let toCheck = self.answerArray.componentsJoined(by: "")
    //        if self.currentRizzle?.answer == toCheck {
    //            solved = true
    //        }
    //        return solved
    //    }
    //
    //    @IBAction func returnToDashboard(_ sender: Any) {
    //        self.dismiss(animated: true, completion: nil)
    //    }
    //
    //    //MARK: - UICollectionViewDataSource
    //
    //    // select Item to send it back to LetterBank
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        self.answerCollection.backgroundColor = UIColor.lightGray
    //        self.bank.characterArray.add(self.answerArray[indexPath.row])
    //        self.answerArray.removeObject(at: indexPath.row)
    //    }
    //    func numberOfSections(in collectionView: UICollectionView) -> Int {
    //        return 1
    //    }
    //    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //        return (self.currentRizzle?.answer?.characters.count)!
    //    }
    //    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //        let answerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "answerCell", for: indexPath) as! LetterCell
    //        answerCell.configure(image: self.answerArray[indexPath.row] as! String)
    //        return answerCell
    //    }
    //
}
