//
//  RizzleAnswerViewController.swift
//  rizzle
//
//  Created by Erin Luu on 2016-12-21.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

import UIKit
import KTCenterFlowLayout


protocol AnswerCollectionDelegate {
    func resetLetter (letter: String)
}

class RizzleAnswerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, AnswerCollectionCellDelegate {
    
    //MARK: Properties
    var answer: String?
    var answerWordBlocksArray = [UIView]()
    var answerLetterBlocksArray = [RizzleAnswerCollectionViewCell]()
    var letterIndexTracker = 0
    var lastCellView: RizzleAnswerCollectionViewCell?
    var delegate: AnswerCollectionDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = KTCenterFlowLayout()
        layout.minimumInteritemSpacing = 20.0
        layout.minimumLineSpacing = 10.0
        collectionView.collectionViewLayout = layout
    }
    
    //MARK: Answer Handle
    func turnAnswerIntoWordViews(answer: String) {
        let maxBlockHeight: CGFloat = 35
        let blockPadding = CGFloat(3)
        
        //Convert string to word array
        let wordArray = answer.components(separatedBy: " ")
        self.answer = answer.uppercased().components(separatedBy: .whitespaces).joined(separator: "")
        
        
        
        //Loop through all words in wordArray
        var positionCount = 0
        for word in wordArray {
            //Convert word to array
            let letterArray = word.characters.map({(character) -> String in
                let letter = String(character)
                return letter})
            
            //Get size of letter blocks, height should not be over maxHeight
            let answerViewWidth = collectionView.frame.width
            var width = (answerViewWidth - ((CGFloat(letterArray.count) - 1) * blockPadding)) / CGFloat(letterArray.count)
            if width > maxBlockHeight { width = maxBlockHeight }
            
            //Add each letter views to parent view
            let parentView = UIView()
            for i in 0...letterArray.count - 1 {
                let xPosition = CGFloat(i) * (width + blockPadding)
                let blockvView = RizzleAnswerCollectionViewCell(
                    frame: CGRect(x: xPosition , y: 0, width: width, height: width),
                    letter: letterArray[i],
                    position: positionCount,
                    delegate: self)
                
                blockvView.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
                parentView.addSubview(blockvView)
                answerLetterBlocksArray.append(blockvView)
                positionCount += 1
            }
            
            //Resize parent based on children
            var parentWidth: CGFloat = 0
            var parentHeight: CGFloat = 0
            for currentView in parentView.subviews {
                let frameWidth = currentView.frame.origin.x + currentView.frame.size.width;
                let frameHeight = currentView.frame.origin.y + currentView.frame.size.height;
                parentWidth = max(frameWidth, parentWidth);
                parentHeight = max(frameHeight, parentHeight);
            }
            parentView.frame = CGRect(x: 0, y: 0, width: parentWidth, height: parentHeight)
            
            //Add parent view to array
            answerWordBlocksArray.append(parentView)
            
        }
        collectionView.reloadData()
        updateTracker(currentTracker: 0, lastCellView: answerLetterBlocksArray[0])
    }
    
    //MARK: Collection View Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return answerWordBlocksArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.addSubview(answerWordBlocksArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellSize = CGSize(width: 0, height: 0)
        if answerWordBlocksArray.count > 0 {
            let wordView = answerWordBlocksArray[indexPath.row]
            cellSize = CGSize(width: wordView.frame.size.width, height: wordView.frame.size.height)
        }
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        collectionView.contentInset.top = max((collectionView.frame.height - collectionView.contentSize.height) / 2, 0) - 5
    }
    
    //Take letter from letterbank and pass it to current answer cell
    func passLetterToCell (letter: String) -> Bool {
        var shouldRemoveLetterFrombank = true
        
        //Move to the next answer cell
        if letterIndexTracker < answerLetterBlocksArray.count {
            if lastCellView?.letterLabel.text == "" || lastCellView?.letterLabel.text == nil {
                lastCellView?.letterLabel.text = letter
                lastCellView?.imageView?.image = UIImage(named: letter)
                letterIndexTracker += 1
                if letterIndexTracker == answerLetterBlocksArray.count {
                    letterIndexTracker -= 1
                }else {
                    lastCellView = answerLetterBlocksArray[letterIndexTracker]
                    lastCellView?.backgroundColor = UIColor(red: 255/255, green: 198/255, blue: 119/255, alpha: 1)
                }
            }else {
                shouldRemoveLetterFrombank = false
            }
        }
        return shouldRemoveLetterFrombank
    }
    
    //MARK: RizzleCell Delegate
    //Update tracker with selected answer cell
    func updateTracker(currentTracker: Int, lastCellView: RizzleAnswerCollectionViewCell) {
        letterIndexTracker = currentTracker
        if self.lastCellView != nil {
            self.lastCellView?.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        }
        self.lastCellView = lastCellView
        
    }
    
    //Get current letter from cell and send it back to RizzleSolve VC
    func resetLetter (letter: String) {
        delegate?.resetLetter(letter: letter)
    }
    
    //MARK: Solve Rizzle
    func checkAnswer() -> String {
        var cellAnswer = ""
        var returnTask = "INCORRECT"
        //Check that all answer cells are filled out
        for answer in answerLetterBlocksArray {
            if answer.letterLabel.text == nil || answer.letterLabel.text == "" {
                returnTask = "BLANK"
                break
            }else {
                cellAnswer.append(answer.letterLabel.text!)
            }
        }
        
        if cellAnswer == answer {
            returnTask = "CORRECT"
        }
        
        return returnTask
    }
    
    
    
}
