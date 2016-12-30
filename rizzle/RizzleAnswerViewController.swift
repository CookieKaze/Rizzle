//
//  RizzleAnswerViewController.swift
//  rizzle
//
//  Created by Erin Luu on 2016-12-21.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

import UIKit
import KTCenterFlowLayout

class RizzleAnswerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, AnswerCollectionCellDelegate {
    
    //MARK: Properties
    var answer: String?
    var answerViewsArray = [UIView]()
    var letterIndexTracker = 0
    var lastCellView: RizzleAnswerCollectionViewCell?
    
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
        self.answer = answer
        let maxBlockHeight: CGFloat = 30
        let blockPadding = CGFloat(5)
        
        //Convert string to word array
        let wordArray = answer.components(separatedBy: " ")
        
        //Loop through all words in wordArray
        for word in wordArray {
            //Convert word to array
            let letterArray = word.characters.map({ (character) -> String in
                let letter = String(character).uppercased()
                return letter})
            
            //Get size of letter blocks, height should not be over maxHeight
            let answerViewWidth = collectionView.frame.width
            var width = (answerViewWidth - ((CGFloat(letterArray.count) - 1) * blockPadding)) / CGFloat(letterArray.count)
            if width > maxBlockHeight { width = maxBlockHeight }
            
            //Add each letter views to parent view
            let parentView = UIView()
            for i in 0...letterArray.count - 1 {
                let xPosition = CGFloat(i) * (width + blockPadding)
                let blockvView = RizzleAnswerCollectionViewCell(frame: CGRect(x: xPosition , y: 0, width: width, height: width), letter: letterArray[i], position: i, delegate: self)
                
                blockvView.backgroundColor = UIColor.lightGray
                parentView.addSubview(blockvView)
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
            answerViewsArray.append(parentView)
        }
        collectionView.reloadData()
    }
    
    //MARK: Collection View Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return answerViewsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.addSubview(answerViewsArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellSize = CGSize(width: 0, height: 0)
        if answerViewsArray.count > 0 {
            let wordView = answerViewsArray[indexPath.row]
            cellSize = CGSize(width: wordView.frame.size.width, height: wordView.frame.size.height)
        }
        return cellSize
    }
    
    //Take letter from letterbank and pass it to current answer cell
    func passLetterToCell (letter: String) {
        lastCellView?.letterLabel.text = letter
    }
    
    //Update tracker with selected answer cell
    func updateTracker(currentTracker: Int, lastCellView: RizzleAnswerCollectionViewCell) {
        letterIndexTracker = currentTracker
        if self.lastCellView != nil {
            self.lastCellView?.layer.borderWidth = 0
        }
        self.lastCellView = lastCellView
        
    }

    
}
