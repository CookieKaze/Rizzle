//
//  RizzleViewController.swift
//  rizzle
//
//  Created by Erin Luu on 2016-12-17.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

import UIKit
import Parse

class RizzleSolveViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, RizzleSolverDelegate {
    
    //MARK: Properties
    var currentUser: PFUser!
    let rizzleManager = RizzleManager.sharedInstance
    var answerViewController: RizzleAnswerViewController?
    var loadingView = UIView()
    var loadingLabel = UILabel()
    
    var rizzle: Rizzle?
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
        self.rizzleManager.delegate = self
        
        //Show loading
        loadingView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        loadingView.backgroundColor = UIColor.black
        view.addSubview(loadingView)
        
        let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        loadingIndicator.center = view.center
        loadingIndicator.startAnimating()
        loadingView.addSubview(loadingIndicator)
        
        loadingLabel.textColor = .white
        loadingLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 30)
        loadingView.addSubview(loadingLabel)
        
        rizzleManager.generateNewRizzle()
    }
    
    func updateLoadStatus(update: String) {
        loadingLabel.text = update
    }
    
    func setCurrentRizzle(rizzle: Rizzle) {
        self.rizzle = rizzle
        //Extract rizzle letter banks
        
        startingBank = (rizzle.letterBanks["startingLetterBank"]!)
        feedingBank = (rizzle.letterBanks["feedingLetterBank"]!)
        letterBank += startingBank
        
        //Create game letter bank
        createLetterBank()
        
        DispatchQueue.main.async {
            self.titleTextField.text = rizzle.title
            self.questionTextView.text = rizzle.question
            self.answerViewController?.turnAnswerIntoWordViews(answer: rizzle.answer)
            self.letterBankCollectionView.reloadData()
            UIView.animate(withDuration: 1, animations: {
                self.loadingView.frame = CGRect(x: self.view.frame.width, y: 0, width: self.loadingView.frame.width, height: self.loadingView.frame.height)
            })
        }
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
    
    //When letter is tapped
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Pass letter to answer view controller
        if (answerViewController?.passLetterToCell(letter: letterBank[indexPath.row]))! {
            //Remove letter from bank
            letterBank.remove(at: indexPath.row)
            
            //Add new letter from feeder
            if feedingBank.count > 0 {
                letterBank.append(feedingBank.first!)
                feedingBank.remove(at: 0)
            }
            
            letterBankCollectionView.reloadData()
        }
    }
    
    
    @IBAction func solveButtonTapped(_ sender: UIButton) {
        //BLAH BLAH BLAH CATS!
    }
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        resetSolvedView()
    }
    
    func resetSolvedView() {
        //Clear Letter Banks
        startingBank = [String]()
        feedingBank = [String]()
        letterBank = [String]()
        
        //Clear Answer View
        answerViewController?.answerWordBlocksArray = [UIView]()
        answerViewController?.answerLetterBlocksArray = [RizzleAnswerCollectionViewCell]()
        answerViewController?.letterIndexTracker = 0
        answerViewController?.lastCellView = nil
        
        setCurrentRizzle(rizzle: self.rizzle!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "answerView" {
            answerViewController = segue.destination as? RizzleAnswerViewController
        }
    }
    
}
