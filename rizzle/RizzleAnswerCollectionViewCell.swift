//
//  RizzleAnswerCollectionViewCell.swift
//  rizzle
//
//  Created by Erin Luu on 2016-12-22.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

import UIKit


protocol AnswerCollectionCellDelegate {
    func updateTracker(currentTracker: Int, lastCellView: RizzleAnswerCollectionViewCell)
    func resetLetter (letter: String)
}

class RizzleAnswerCollectionViewCell: UIView {
 
    var letter: String!
    var letterLabel = UILabel(frame: .zero)
    var letterPosition: Int!
    var imageView: UIImageView?
    var delegate: AnswerCollectionCellDelegate?
    
    init(frame: CGRect, letter: String, position: Int, delegate: AnswerCollectionCellDelegate) {
        super.init(frame: frame)
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 203/255, green: 203/255, blue: 203/255, alpha: 1).cgColor
        
        self.letter = letter
        self.letterPosition = position
        self.delegate = delegate
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(letterCellTapped))
        self.addGestureRecognizer(tapGesture)
        
        //Setup letter label
        letterLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        letterLabel.textAlignment = .center
        letterLabel.font = letterLabel.font.withSize(20)
        letterLabel.textColor = .white
        self.addSubview(letterLabel)
        
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        self.addSubview(self.imageView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Letter cell selection, passing to answer view controller
    func letterCellTapped () {
        self.backgroundColor = UIColor(red: 255/255, green: 198/255, blue: 119/255, alpha: 1)

        delegate?.updateTracker(currentTracker: letterPosition, lastCellView: self)
        if letterLabel.text != "" && letterLabel.text != nil {
            //self.backgroundColor = UIColor(red: 255/255, green: 198/255, blue: 119/255, alpha: 1)
            delegate?.resetLetter(letter: letterLabel.text!)
            letterLabel.text = nil
            imageView?.image = nil
            letterLabel.text = ""
        }
    }
    
//    func updateLetter(tempLetter: String) {
//        letterLabel.text = tempLetter
//    }
}
