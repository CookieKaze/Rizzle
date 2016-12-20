//
//  RizzleViewController.swift
//  rizzle
//
//  Created by Matthew Mauro on 2016-12-17.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

import UIKit
import Parse

class SolveRizzleViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, RizzleControl {

    @IBOutlet weak var rizzleTitle: UILabel!
    @IBOutlet weak var rizzleDescription: UITextView!
    @IBOutlet weak var hintsRemainingLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBOutlet weak var letterBankCollection: UICollectionView!
    @IBOutlet weak var answerCollection: UICollectionView!
    
    var hintNumber:NSInteger?
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var solvedImage: UIImageView!
    @IBOutlet weak var bank: LetterBank!
    
    public var currentRizzle:Rizzle?
    
    var answerArray = NSMutableArray()
    var user:PFUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bank.currentRizzle = self.currentRizzle
        // 'bank' is still set to create Dummy values for testing at this point
        guard let currentUser = PFUser.current() else{
            print("No current user")
            return
        }
        self.user = currentUser
        
        self.rizzleTitle.text = self.currentRizzle?.title
        self.rizzleDescription.text = self.currentRizzle?.question
        answerCollection.dataSource = self
        letterBankCollection.dataSource = self.bank
        self.bank.delegate = self
        
    }
    func enterCellIntoAnswer(_cell: UICollectionViewCell){
        self.answerArray.add(_cell)
        self.reloadInputViews()
        if self.answerArray.count == (self.currentRizzle?.answer?.characters.count)! {
            let solved = self.checkAnswer()
            if solved == true{
                self.rizzleTitle.text = "SOLVED!"
                self.bank.characterArray.removeAllObjects()
                // render letterBank and answerArray to unInteractable
                var completed = self.user?.object(forKey: "completedRizzles") as! Array<String>
                completed.append(String(format: "%@", (self.currentRizzle?.objectId)!))
                
                
                
                self.solvedImage.backgroundColor = UIColor.blue
                self.solvedImage.image = UIImage(named: "solved")
                self.solvedImage.isHidden = false
                
                
                UIView.animate(withDuration: 1.5, animations: {
                    self.solvedImage.isHidden = true
                })
                
            }else{
                // answer field red. possibly offer a hint?
                self.answerCollection.backgroundColor = UIColor.red
                self.solvedImage.backgroundColor = UIColor.red
                self.solvedImage.image = UIImage(named: "incorrect")
                self.solvedImage.isHidden = false
                
                UIView.animate(withDuration: 1.5, animations: {
                    self.solvedImage.isHidden = true
                })
            }
        }
        self.reloadInputViews()
    }
    func checkAnswer() -> Bool{
        var solved:Bool = false
        let toCheck = self.answerArray.componentsJoined(by: "")
        if self.currentRizzle?.answer == toCheck {
            solved = true
        }
        return solved
    }
    
    @IBAction func returnToDashboard(_ sender: Any) {
        if let dashboard = self.storyboard?.instantiateViewController(withIdentifier: "userDashboard") as? UserDashboardViewController {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController!.present(dashboard, animated: true, completion: nil)
        }
    }
    
    //MARK: - UICollectionViewDataSource
    
    // select Item to send it back to LetterBank
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.answerCollection.backgroundColor = UIColor.lightGray
        self.bank.characterArray.add(self.answerArray[indexPath.row])
        self.answerArray.removeObject(at: indexPath.row)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.currentRizzle?.answer?.characters.count)!
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let answerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "answerCell", for: indexPath) as! LetterCell
        answerCell.configure(image: self.answerArray[indexPath.row] as! String)
        return answerCell
    }
    
}
