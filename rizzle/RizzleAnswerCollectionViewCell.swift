//
//  RizzleAnswerCollectionViewCell.swift
//  rizzle
//
//  Created by Erin Luu on 2016-12-22.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

import UIKit


protocol AnswerCollectionCellDelegate {
    func updateTracker(currentTracker: Int, lastCellView: UIView)
}

class RizzleAnswerCollectionViewCell: UIView {
 
    var letter: String!
    var letterPosition: Int!
    var delegate: AnswerCollectionCellDelegate?
    
    init(frame: CGRect, letter: String, position: Int, delegate: AnswerCollectionCellDelegate) {
        super.init(frame: frame)
        self.letter = letter
        self.letterPosition = position
        self.delegate = delegate
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(letterCellTapped))
        self.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func letterCellTapped () {
        delegate?.updateTracker(currentTracker: letterPosition, lastCellView: self)
        layer.borderWidth = 1
        layer.borderColor = UIColor.red.cgColor
    }
    
   
    
//    func updateLetter(tempLetter: String) {
//        letterLabel.text = tempLetter
//    }
}
