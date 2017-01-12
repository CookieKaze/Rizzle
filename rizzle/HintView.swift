//
//  HintView.swift
//  rizzle
//
//  Created by Erin Luu on 2017-01-01.
//  Copyright © 2017 Erin Luu. All rights reserved.
//

import UIKit

class HintView: UIView {
    //MARK: Properties
    let rizzleManager = RizzleManager.sharedInstance
    var currentHintView: Int = 1
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var iconOutterCircle: UIView!
    @IBOutlet weak var iconInnerCircle: UIView!
    
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var remainingScoreLabel: UILabel!
    @IBOutlet weak var lockedHintView: UIView!
    @IBOutlet weak var unlockedHintView: UIView!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var hint1: UIButton!
    @IBOutlet weak var hint2: UIButton!
    @IBOutlet weak var hint3: UIButton!
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setup Methods
    func loadNib() {
        let view = Bundle.main.loadNibNamed("HintView1", owner: self, options: nil)?[0] as! UIView
        addSubview(view)
        view.frame = self.bounds
    }
    
    func setupView() {
        unlockedHintView.isHidden = true
        setRemainingScore()
        hint1.backgroundColor = UIColor.orange
        
        //Check if the first hint is unlocked
        hintButtonTapped(hint1)
        //Round Alert Icon
        iconOutterCircle.layer.cornerRadius = iconOutterCircle.frame.size.height/2
        iconInnerCircle.layer.cornerRadius = iconInnerCircle.frame.size.height/2
    }
    
    func setRemainingScore() {
        remainingScoreLabel.text = "\(rizzleManager.currentScore) / \(rizzleManager.maxScore)"
        if rizzleManager.currentScore > rizzleManager.difficultyLevel * rizzleManager.hintUnlockCost + rizzleManager.minimumScore {
            hintLabel.text = "Each hint will cost \(rizzleManager.difficultyLevel * rizzleManager.hintUnlockCost) points from your final Rizzle score."
        }else {
            hintLabel.text = ""
        }
    }
    
    func showView() {
        self.isHidden = false
        self.frame = CGRect(x: 0, y: frame.height, width: self.frame.width, height: self.frame.height)
        setRemainingScore()
        UIView.animate(withDuration: 1, animations: {
            self.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        })
    }
    
    func resetButtons() {
        hint1.backgroundColor = UIColor.gray
        hint2.backgroundColor = UIColor.gray
        hint3.backgroundColor = UIColor.gray
    }
    
    //MARK: Hint Button Actions
    @IBAction func hintButtonTapped(_ sender: UIButton) {
        var hintText = ""
        
        resetButtons()
        sender.backgroundColor = UIColor.orange
        
        guard let buttonTitle = sender.titleLabel?.text else  {
            return
        }
        
        //Set currentHintView
        switch buttonTitle {
        case "Hint 1":
            self.currentHintView = 1
            hintText = (rizzleManager.currentRizzle?.hint1)!
            break
        case "Hint 2":
            self.currentHintView = 2
            hintText = (rizzleManager.currentRizzle?.hint2)!
            break
        case "Hint 3":
            self.currentHintView = 3
            hintText = (rizzleManager.currentRizzle?.hint3)!
            break
        default:
            break
        }
        
        //Set view based on currentHintView
        if rizzleManager.currentTracker?["hint\(currentHintView)Used"] as! Bool {
            unlockedHintView.isHidden = false
            lockedHintView.isHidden = true
            textView.text = hintText
        } else {
            unlockedHintView.isHidden = true
            lockedHintView.isHidden = false
        }
    }

    @IBAction func unlockHintButtonTapped(_ sender: UIButton) {
        if rizzleManager.currentScore >= rizzleManager.difficultyLevel * rizzleManager.hintUnlockCost {
            switch currentHintView {
            case 1:
                //Unlock Hint 1
                rizzleManager.unlockHint(hint: 1)
                unlockedHintView.isHidden = false
                lockedHintView.isHidden = true
                textView.text = rizzleManager.currentRizzle?.hint1
                setRemainingScore()
                return
            case 2:
                //Unlock Hint 2
                rizzleManager.unlockHint(hint: 2)
                unlockedHintView.isHidden = false
                lockedHintView.isHidden = true
                textView.text = rizzleManager.currentRizzle?.hint2
                setRemainingScore()
                return
            case 3:
                //Unlock Hint 3
                rizzleManager.unlockHint(hint: 3)
                unlockedHintView.isHidden = false
                lockedHintView.isHidden = true
                textView.text = rizzleManager.currentRizzle?.hint3
                setRemainingScore()
                return
            default:
                 return
            }
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 1, animations: {
            self.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: self.frame.height)
        },completion: { (success) in
            self.isHidden = true
        })
    }
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
    }
    @IBAction func bgTapped(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 1, animations: {
            self.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: self.frame.height)
        },completion: { (success) in
            self.isHidden = true
        })
    }
}
