//
//  CreateQuestionViewController.swift
//  rizzle
//
//  Created by Erin Luu on 2017-01-18.
//  Copyright © 2017 Erin Luu. All rights reserved.
//

import UIKit

class CreateQuestionViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    var nextButtonStart: CGPoint?
    var backButtonStart: CGPoint?
    var questionPlaceHolderLabel: UILabel?
    var createRizzleManager = CreateRizzleManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.isHidden = true
        
        questionPlaceHolderLabel = UILabel.init()
        guard let placeholderLabel = questionPlaceHolderLabel else {
            return
        }
        placeholderLabel.text = "Start typing your rizzle question here…"
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (questionTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        questionTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (questionTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !questionTextView.text.isEmpty
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(sender:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(sender:)), name: .UIKeyboardWillHide, object: nil)
        
        //Load field if value is not nil
        if createRizzleManager.question != nil {
            questionTextView.text = createRizzleManager.question
            questionLabel.isHidden = false
            questionPlaceHolderLabel?.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func loadFields() {
        //        questionTextView.text = rizzleToEdit["question"] as? String
        //        questionPlaceHolderLabel?.isHidden = true
        //        questionLabel.isHidden = false
        
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        questionTextView.resignFirstResponder()
        //Check for blank question
        if questionTextView.text == nil || questionTextView.text == "" {
            let alertView = PopupAlertViewController(nibName: "PopupAlertViewController", bundle: nil)
            alertView.bodyText = "Your Rizzle has to have a question."
            self.present(alertView, animated: false, completion: nil)
        } else {
            createRizzleManager.question = questionTextView.text
            performSegue(withIdentifier: "toImageView", sender: nil)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        questionTextView.resignFirstResponder()
        createRizzleManager.question = questionTextView.text
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //Keyboard controlls
    func textViewDidChange(_ textView: UITextView) {
        questionPlaceHolderLabel?.isHidden = !questionTextView.text.isEmpty
        if questionTextView.text != nil {
            if questionTextView.text!.characters.count == 1 {
                questionLabel.isHidden = false
                self.questionLabel.center = CGPoint(x: self.questionLabel.center.x, y: self.questionLabel.center.y + 20)
                UIView.animate(withDuration: 0.5, animations: {
                    self.questionLabel.center = CGPoint(x: self.questionLabel.center.x, y: self.questionLabel.center.y - 20)
                })
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        questionTextView.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        questionTextView.resignFirstResponder()
        return true
    }
    
    func keyboardWillAppear(sender: NSNotification) {
        nextButtonStart = nextButton.center
        backButtonStart = backButton.center
        let userInfo = sender.userInfo!
        if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            self.nextButton.center = CGPoint(x: nextButton.center.x, y: nextButton.center.y - keyboardHeight/1.5)
            self.backButton.center = CGPoint(x: backButton.center.x, y: backButton.center.y - keyboardHeight/1.5)
        }
        
        //Shift View
        questionView.center = CGPoint(x: questionView.center.x, y: questionView.center.y - 100)
    }
    
    func keyboardWillDisappear(sender: NSNotification) {
        if nextButtonStart != nil {
            nextButton.center = nextButtonStart!
        }
        if backButtonStart != nil {
            backButton.center = backButtonStart!
        }
        questionView.center = CGPoint(x: questionView.center.x, y: questionView.center.y + 100)
    }
    
    
}
