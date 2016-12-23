//
//  RizzleAnswerViewController.swift
//  rizzle
//
//  Created by Erin Luu on 2016-12-21.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

import UIKit

class RizzleAnswerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    //MARK: Properties
    var answerCellView: UIView?
    var answer: String?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Answer Handle
    func turnAnswerIntoWordViews() {
        let testWord = "Helloworld"
        let maxBlockHeight: CGFloat = 30
        let blockPadding = CGFloat(5)
        var answerViewsArray = [UIView]()
        
        //        //Convert string to word array
        //        let wordArray = testWord.componentsSeparatedByString(" ")
        //
        //Convert word to array
        let letterArray = testWord.characters.map({ (character) -> String in
            let letter = String(character).uppercased()
            return letter})
        
        //Get size of letter blocks, height should not be over maxHeight
        let answerViewWidth = answerView.frame.width
        var width = (answerViewWidth - ((CGFloat(letterArray.count) - 1) * blockPadding)) / CGFloat(letterArray.count)
        if width > maxBlockHeight { width = maxBlockHeight }
        
        //Add each letter views to parent view
        let parentView = UIView()
        for i in 0...letterArray.count - 1 {
            let xPosition = CGFloat(i) * (width + blockPadding)
            let blockView = UIView(frame: CGRect(x: xPosition , y: 0, width: width, height: width))
            blockView.backgroundColor = UIColor.gray
            parentView.addSubview(blockView)
        }
        
        //Resize parent based on children
        let parentWidth: CGFloat = 0
        let parentHeight: CGFloat = 0
        for currentView in parentView.subviews {
            var frameWidth = currentView.frame.origin.x + currentView.frame.size.width;
            var frameHeight = currentView.frame.origin.y + currentView.frame.size.height;
            frameWidth = max(frameWidth, parentWidth);
            frameHeight = max(frameHeight, parentHeight);
        }
        parentView.frame = CGRect(x: 0, y: 0, width: parentWidth, height: parentHeight)
        
        //Add parent view to array
        answerViewsArray.append(parentView)
    }
    
    //MARK: Collection View Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RizzleAnswerCollectionViewCell
        cell.backgroundColor = .red
        
        return cell
    }


}
