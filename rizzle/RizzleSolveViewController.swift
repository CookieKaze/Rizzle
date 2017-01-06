//
//  RizzleViewController.swift
//  rizzle
//
//  Created by Erin Luu on 2016-12-17.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

import UIKit
import Parse
import GSImageViewerController

class RizzleSolveViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, RizzleSolverDelegate, AnswerCollectionDelegate {
    
    //MARK: Properties
    
    //Defaults
    let letterBankLimit = 12
    
    //Rizzle Solve View
    var rizzle: Rizzle?
    var currentUser: PFUser!
    let rizzleManager = RizzleManager.sharedInstance
    var answerViewController: RizzleAnswerViewController?
    var loadingView = UIView()
    var loadingLabel = UILabel()
    
    //Letter Banks
    var startingBank = [String]()
    var feedingBank = [String]()
    var letterBank = [String]()
    
    //Continue
    var continueRizzlePF: PFObject?
    var continueRizzleTrackerPF: PFObject?
    
    //Solve View
    @IBOutlet weak var answerView: UIView!
    @IBOutlet weak var letterBankCollectionView: UICollectionView!
    @IBOutlet weak var titleTextField: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var rizzleImage: UIImageView!
    @IBOutlet weak var difficultyLevelLabel: UILabel!
    
    //Complete View
    var creatorImage: UIImage?
    var creatorUsername: String?
    @IBOutlet weak var explanationView: UITextView!
    @IBOutlet weak var creatorImageView: UIImageView!
    
    @IBOutlet weak var creatorUsernameLabel: UILabel!
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
        
        if continueRizzlePF == nil && continueRizzleTrackerPF == nil {
            rizzleManager.generateNewRizzle()
        } else {
            rizzleManager.continueRizzle(rizzle: continueRizzlePF!, tracker: continueRizzleTrackerPF!)
        }
    }
    
    func getCompleteViewData() {
        let completeViewQueue = DispatchQueue(label: "completeViewQueue", qos: .utility)
        completeViewQueue.sync {
            do {
                let creator = try self.rizzle?.creator.fetch()
                self.creatorUsername = creator?["rizzleName"] as? String
                guard let userImageFile = creator?["userPhoto"] as? PFFile else {
                    return
                }
                userImageFile.getDataInBackground(block: { (imageData, error) in
                    if error == nil {
                        if let imageData = imageData {
                            self.creatorImage = UIImage(data: imageData)
                        }
                    }
                })
                            }
            catch {}
        }
    }
    
    func updateLoadStatus(update: String) {
        loadingLabel.text = update
    }
    
    func setCurrentRizzle(rizzle: Rizzle) {
        self.rizzle = rizzle
        setCurrentScore()
        
        //Extract rizzle letter banks
        startingBank = (rizzle.letterBanks["startingLetterBank"]!)
        feedingBank = (rizzle.letterBanks["feedingLetterBank"]!)
        letterBank += startingBank
        
        //Create game letter bank
        createLetterBank()
        
        DispatchQueue.main.async {
            self.titleTextField.text = rizzle.title
            self.questionTextView.text = rizzle.question
            self.difficultyLevelLabel.text = "Difficulty Level: \(self.rizzleManager.difficultyLevel)"
            //Add image to question view
            if rizzle.image != nil {
                self.rizzleImage.image = rizzle.image!
            } else {
                self.rizzleImage.removeFromSuperview()
            }
            
            self.answerViewController?.turnAnswerIntoWordViews(answer: rizzle.answer)
            self.letterBankCollectionView.reloadData()
            
            UIView.animate(withDuration: 1, animations: {
                self.loadingView.frame = CGRect(x: self.view.frame.width, y: 0, width: self.loadingView.frame.width, height: self.loadingView.frame.height)
            })
        }
        getCompleteViewData()
    }
    
    func setCurrentScore() {
        scoreLabel.text = "Score: \(rizzleManager.currentScore) / \(rizzleManager.maxScore)"
    }
    
    func createLetterBank () {
        var missingLetters = 0
        let allAlphaCharacters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R" ,"S" ,"T" ,"U" ,"V" ,"W" ,"X" ,"Y" ,"Z"]
        
        if letterBankLimit > startingBank.count {
            missingLetters = letterBankLimit - startingBank.count
            
            //Generate random letters for all missing letters
            for _ in 1...missingLetters {
                let randomNumber = Int(arc4random_uniform(UInt32(allAlphaCharacters.count)))
                letterBank.append(allAlphaCharacters[randomNumber])
            }
            
            //Scramble new letter bank
            letterBank = rizzleManager.scrambleLetters(array: letterBank)
        }
    }
    
    func noRizzleDismiss() {
        dismiss(animated: true, completion: nil)
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
    
    //MARK: AnswerViewController
    //Setup variables
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "answerView" {
            answerViewController = segue.destination as? RizzleAnswerViewController
            answerViewController?.delegate = self
        }
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
    
    //Put deleted letter back into bank
    func resetLetter (letter: String) {
        letterBank.append(letter)
        letterBankCollectionView.reloadData()
    }
    
    //MARK: Reset views
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
    
    //MARK: Solve Rizzle
    @IBAction func solveButtonTapped(_ sender: UIButton) {
        solveRizzle()
    }
    
    @IBAction func closeCompleteTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func solveRizzle() {
        guard let answerStatus = answerViewController?.checkAnswer() else {
            return
        }
        
        switch answerStatus {
        case "INCORRECT":
            rizzleManager.incorrectGuess()
            setCurrentScore()
            break
        case "BLANK":
            //Cells can't be blank, show alert
            let blankAlertMessageController = UIAlertController(title: "Blank Answer", message: "Please fill in all answer blocks and try again.", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default)
            blankAlertMessageController.addAction(okAction)
            present(blankAlertMessageController, animated: true, completion: nil)
            break
        case "CORRECT":
            rizzleManager.correctGuess()
            
            //Display CorrectView
            let correctView = Bundle.main.loadNibNamed("CorrectView", owner: self, options: nil)?[0] as! UIView
            correctView.frame = self.view.bounds
            explanationView.text = rizzle?.explanation
            creatorImageView.image = creatorImage ?? UIImage(named: "defaultProfileImage")
            creatorImageView.layer.cornerRadius = creatorImageView.frame.size.height/2;
            creatorUsernameLabel.text = creatorUsername ?? ""
            self.view.addSubview(correctView)
            break
        default:
            break
        }
    }
    
    
    //MARK: Hints Control
    @IBAction func getHintTapped(_ sender: UIButton) {
        let hintView = HintView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(hintView)
        hintView.showView()
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Image Control
    @IBAction func rizzleImageTapped(_ sender: UITapGestureRecognizer) {
        let imageInfo      = GSImageInfo(image: (rizzle?.image)!, imageMode: .aspectFill, imageHD: nil)
        let transitionInfo = GSTransitionInfo(fromView: rizzleImage)
        let imageViewer    = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
        present(imageViewer, animated: true, completion: nil)
        
    }
    
    
}
