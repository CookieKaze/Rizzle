//
//  letterBank.swift
//  rizzle
//
//  Created by Matthew Mauro on 2016-12-16.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

import UIKit

protocol RizzleControl {
    func enterCellIntoAnswer(_cell: UICollectionViewCell)
}

class LetterBank: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    //
    // FAIR WARNING
    //
    // ANSWER ENTERING AND CHECKING HAS NOT BEEN WRITTEN YET!!!
    
    let letters:Array<String> = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    let numbers:Array<String> = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
    let characterArray = NSMutableArray()
    let dummyStringAnswer = "spider"
    let dummyNumberAnswer = "42"
    let dummyMultipleChoice = "C"
    
    let usedIndexes = NSMutableArray()
    var delegate:RizzleControl?
    
    public var currentRizzle:Rizzle?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Setting up Dummy Rizzle for testing
        
        let random = arc4random_uniform(3)
        switch random {
        case 0:
            let hint:Array<String> = ["ask about his tattoo", "Red & Blue suit", "Spins a web, any size..."]
            self.currentRizzle = Rizzle.init(title: "Superhero", question: "who is Matt's favourite hero?", answer: dummyStringAnswer, creator: "Matt", hints: hint)
            self.currentRizzle?.type = answerType.stringAnswer
            break
        case 1:
            let hint:Array<String> = ["Jackie Robinson", "Hitchhiker's Guide to the Galaxy", "6 x 7 = ?"]
            self.currentRizzle = Rizzle.init(title: "Pop Culture", question: "What is the answer to the Meaning of Life?", answer: dummyNumberAnswer, creator: "Matt", hints: hint)
            self.currentRizzle?.type = answerType.numberAnswer
            break
        case 2:
            let hint:Array<String> = ["... Panther", "Delirium Tremens", "Red + White"]
            self.currentRizzle = Rizzle.init(title: "Multiple Guess", question: "What is Erin's favourite COLOUR!? \n a) Black as Matt's soul \n b) Magenta \n c) PINK \n d) Baby Blue", answer: dummyMultipleChoice, creator: "Matt", hints: hint)
            self.currentRizzle?.type = answerType.multipleChoice
            break
        default:
            let hint:Array<String> = ["Metallica Song", "Zombieland Intro", "Canadian phone company"]
            self.currentRizzle = Rizzle.init(title: "Music", question: "For Whom the ____ tolls", answer: "Bell", creator: "Matt", hints: hint)
            self.currentRizzle?.type = answerType.stringAnswer
            break
        }
    }
    
    //MARK: - CollectionView DataSource
    //cellConfiguration method is on LetterCell class
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var rows:Int = 0
        switch self.currentRizzle?.type?.rawValue {
        case 0?:
            rows = 1
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
        let more = (self.currentRizzle?.answer?.characters.count)!
        return (self.currentRizzle?.answer?.characters.count)!+more
    }
    
    
    // MARK: - Select Cell 
    // select method. Should send cell to delegate (Rizzle viewController) to hold in answer array
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.enterCellIntoAnswer(_cell: characterArray[indexPath.row] as! LetterCell)
        characterArray.removeObject(at: indexPath.row)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let answerString = self.currentRizzle?.answer!.uppercased()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LetterCell
        
        let addedCharacters = NSMutableArray()
        
        // switch statement based on Rizzle.Type enum
        switch self.currentRizzle?.type?.rawValue {
        case 0?:
            cell.configure(image: (self.letters[indexPath.row]))
            break
        case 1?:
            for char in (answerString?.characters)! {
                let indC = arc4random_uniform(UInt32((self.currentRizzle?.answer?.characters.count)! as Int))
                let charNumber = Int(indC)
                if addedCharacters.contains(charNumber) == false {
                    addedCharacters.add(charNumber)
                    characterArray.add(char)
                }
                let ind = arc4random_uniform(27)
                let number = Int(ind)
                characterArray.add(self.letters[number])
            }
            let cells = (characterArray as NSArray) as! [String]
            cell.configure(image: cells[indexPath.row])
            break
        case 2?:
            for char in (answerString?.characters)! {
                let indC = arc4random_uniform(UInt32((self.currentRizzle?.answer?.characters.count)! as Int))
                let charNumber = Int(indC)
                if addedCharacters.contains(charNumber) == false {
                    addedCharacters.add(charNumber)
                    characterArray.add(char)
                }
                let ind = arc4random_uniform(9)
                let number = Int(ind)
                characterArray.add(self.numbers[number])
            }
            let cells = (characterArray as NSArray) as! [String]
            cell.configure(image: cells[indexPath.row])
            break
        default:
            break
        }
        return cell
    }
    

}
