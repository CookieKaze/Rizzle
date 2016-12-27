//
//  RizzleAnswerViewController.swift
//  rizzle
//
//  Created by Erin Luu on 2016-12-21.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

import UIKit

class RizzleAnswerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //MARK: Properties
    var answer: String?
    var answerViewsArray = [UIView]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        turnAnswerIntoWordViews()
        collectionView.reloadData()
    }
    
    //MARK: Answer Handle
    func turnAnswerIntoWordViews() {
        let testWord = "Fluffy cats are fluffy"
        let maxBlockHeight: CGFloat = 30
        let blockPadding = CGFloat(5)
        
        //Convert string to word array
        let wordArray = testWord.components(separatedBy: " ")
        
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
                let blockView = UIView(frame: CGRect(x: xPosition , y: 0, width: width, height: width))
                blockView.backgroundColor = UIColor.gray
                blockView.layer.borderWidth = 1
                blockView.layer.borderColor = UIColor.red.cgColor
                parentView.addSubview(blockView)
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
    }
    
    //MARK: Collection View Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return answerViewsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RizzleAnswerCollectionViewCell
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
}
