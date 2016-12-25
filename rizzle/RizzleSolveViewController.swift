//
//  RizzleViewController.swift
//  rizzle
//
//  Created by Erin Luu on 2016-12-17.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

import UIKit
import Parse

class RizzleSolveViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: Properties
    var currentUser: PFUser!
    let rizzleManager = RizzleManager.sharedInstance
    var answerViewController: RizzleAnswerViewController?
    
    var rizzle: Rizzle!
    var startingBank = [String]()
    var feedingBank = [String]()
    var letterBank = [String]()
    let letterBankLimit = 12
    
    
    @IBOutlet weak var answerView: UIView!
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
        self.rizzle = rizzleManager.getRizzle()
        
        //Extract rizzle letter banks
        startingBank = rizzle.letterBanks["startingLetterBank"]!
        feedingBank = rizzle.letterBanks["feedingLetterBank"]!
        letterBank += startingBank
        
        //Create game letter bank
        createLetterBank()
        
    }
    
    func createLetterBank () {
        let missingLetters = letterBankLimit - startingBank.count
        let allAlphaCharacters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R" ,"S" ,"T" ,"U" ,"V" ,"W" ,"X" ,"Y" ,"Z"]
        
        //Generate random letters for all missing letters
        for _ in 1...missingLetters {
            let randomNumber = Int(arc4random_uniform(UInt32(allAlphaCharacters.count)))
            letterBank.append(allAlphaCharacters[randomNumber])
        }
        //Scramble new letter bank
        letterBank = rizzleManager.scrambleLetters(array: letterBank)
    }
    
    //MARK: Letter Bank Data Source
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return letterBank.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = letterBankCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RizzleLetterCell
        if letterBank.count != 0 {
            cell.imageView.image = UIImage.init(named: letterBank[indexPath.row])
        }
        return cell
    }
    
    @IBAction func solveButtonTapped(_ sender: UIButton) {
        print(rizzle.answer)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "answerView" {
            answerViewController = segue.destination as? RizzleAnswerViewController
        }
    }
    
}
