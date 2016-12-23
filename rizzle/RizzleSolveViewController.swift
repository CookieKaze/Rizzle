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
    
    var rizzle: Rizzle!
    var startingBank = [String]()
    var feedingBank = [String]()
    var letterBankLimit = 12
    var letterBank = [String]()
    
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
    
    //MARK: Letter Handlers
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
    
    
    @IBAction func solveButtonTapped(_ sender: UIButton) {
        print(rizzle.answer)
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
    
    //    //MARK: Answer Handle
    //
    //    func turnAnswerIntoWordViews() {
    //        let testWord = "Helloworld"
    //        let maxBlockHeight: CGFloat = 30
    //        let blockPadding = CGFloat(5)
    //        var answerViewsArray = [UIView]()
    //
    //        //        //Convert string to word array
    //        //        let wordArray = testWord.componentsSeparatedByString(" ")
    //        //
    //        //Convert word to array
    //        let letterArray = testWord.characters.map({ (character) -> String in
    //            let letter = String(character).uppercased()
    //            return letter})
    //
    //        //Get size of letter blocks, height should not be over maxHeight
    //        let answerViewWidth = answerView.frame.width
    //        var width = (answerViewWidth - ((CGFloat(letterArray.count) - 1) * blockPadding)) / CGFloat(letterArray.count)
    //        if width > maxBlockHeight { width = maxBlockHeight }
    //
    //        //Add each letter views to parent view
    //        let parentView = UIView()
    //        for i in 0...letterArray.count - 1 {
    //            let xPosition = CGFloat(i) * (width + blockPadding)
    //            let blockView = UIView(frame: CGRect(x: xPosition , y: 0, width: width, height: width))
    //            blockView.backgroundColor = UIColor.gray
    //            parentView.addSubview(blockView)
    //        }
    //
    //        //Resize parent based on children
    //        let parentWidth: CGFloat = 0
    //        let parentHeight: CGFloat = 0
    //        for currentView in parentView.subviews {
    //            var frameWidth = currentView.frame.origin.x + currentView.frame.size.width;
    //            var frameHeight = currentView.frame.origin.y + currentView.frame.size.height;
    //            frameWidth = max(frameWidth, parentWidth);
    //            frameHeight = max(frameHeight, parentHeight);
    //        }
    //        parentView.frame = CGRect(x: 0, y: 0, width: parentWidth, height: parentHeight)
    //        
    //        //Add parent view to array
    //        answerViewsArray.append(parentView)
    //        testWordView = parentView
    //        
    //    }
    //    
    
}
