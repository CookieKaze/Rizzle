//
//  letterBank.swift
//  rizzle
//
//  Created by Matthew Mauro on 2016-12-16.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

import UIKit

class letterBank: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    let letters:Array = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    let numbers:Array = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
    
    let dummyStringAnswer = "spider"
    let dummyNumberAnswer = "42"
    let dummyMultipleChoice = "c"
    var dummyRizzle:Rizzle?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let random = arc4random_uniform(3)
        switch random {
        case 0:
            let hint:Array<String> = ["ask about his tattoo", "Red & Blue suit", "Spins a web, any size"]
            self.dummyRizzle = Rizzle.init(title: "Superhero", question: "who is Matt's favourite hero?", answer: dummyStringAnswer, creator: "Matt", hints: hint)
            self.dummyRizzle?.type = answerType.stringAnswer
            break
        case 1:
            let hint:Array<String> = ["Jackie Robinson", "Hitchhiker's Guide to the Galaxy", "6 x 7 = ?"]
            self.dummyRizzle = Rizzle.init(title: "Pop Culture", question: "What is the answer to the Meaning of Life?", answer: dummyNumberAnswer, creator: "Matt", hints: hint)
            self.dummyRizzle?.type = answerType.numberAnswer
            break
        case 2:
            let hint:Array<String> = ["ask about his tattoo", "Red & Blue suit", "Spins a web, any size"]
            self.dummyRizzle = Rizzle.init(title: "Multiple Guess", question: "What is Erin's favourite COLOUR!? \n a) Black as Matt's soul \n b) Magenta \n c) PINK \n d) Baby Blue", answer: dummyMultipleChoice, creator: "Matt", hints: hint)
            self.dummyRizzle?.type = answerType.multipleChoice
            break
        default:
            let hint:Array<String> = ["Metallica Song", "Zombieland Intro", "Canadian phone company"]
            self.dummyRizzle = Rizzle.init(title: "Music", question: "For Whom the ____ tolls", answer: "Bell", creator: "Matt", hints: hint)
            self.dummyRizzle?.type = answerType.stringAnswer
            break
        }
    }
    
    //MARK: - CollectionView DataSource
    //cellConfiguration method is on LetterCell class
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var rows:Int = 0
        switch self.dummyRizzle?.type?.rawValue {
        case 0?:
            rows = 4
            break
        case 1?:
            rows = 1
            break
        case 2?:
            rows = 1
            break
        default:
            break
        }
        return rows
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let more = (self.dummyRizzle?.answer?.characters.count)!
        return (self.dummyRizzle?.answer?.characters.count)!+more
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let characterArray = NSMutableArray()
        for char in (self.dummyRizzle?.answer?.characters)! {
            characterArray.add(char)
            let ind = arc4random_uniform(27)
            let number = Int(ind)
            characterArray.add(self.letters[number])
        }
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LetterCell
        //cell.configure(image: )
        return cell
    }
}
