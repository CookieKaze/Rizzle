//
//  CreateExplanationViewController.swift
//  rizzle
//
//  Created by Erin Luu on 2017-01-23.
//  Copyright © 2017 Erin Luu. All rights reserved.
//

import UIKit

class CreateExplanationViewController: UIViewController {
    var explanationPlaceHolderLabel: UILabel?
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var explanationTextView: UITextView!
    @IBOutlet weak var explanationView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    var nextButtonStart: CGPoint?
    var backButtonStart: CGPoint?
    var createRizzleManager = CreateRizzleManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        explanationLabel.isHidden = true
        explanationPlaceHolderLabel = UILabel.init()
        guard let placeholderLabel = explanationPlaceHolderLabel else {
            return
        }
        placeholderLabel.text = "Start typing explanation here..."
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (explanationTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        explanationTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (explanationTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !explanationTextView.text.isEmpty
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(sender:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(sender:)), name: .UIKeyboardWillHide, object: nil)
        
        //Load field if value is not nil
        if createRizzleManager.explanation != nil {
            explanationTextView.text = createRizzleManager.explanation
            explanationLabel.isHidden = false
            explanationPlaceHolderLabel?.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    //    func loadFields() {
    //        answerTextField.text = rizzleToEdit["answer"] as? String
    //        explanationTextView.text = rizzleToEdit["explanation"] as? String
    //        explanationPlaceHolderLabel?.isHidden = true
    //
    //    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        explanationTextView.resignFirstResponder()
        
        //Check for blank fields
        if explanationTextView.text == nil || explanationTextView.text == "" {
            let alertView = PopupAlertViewController(nibName: "PopupAlertViewController", bundle: nil)
            alertView.bodyText = "Your Rizzle has to have an explanation."
            self.present(alertView, animated: false, completion: nil)
        } else {
            createRizzleManager.explanation = explanationTextView.text
            performSegue(withIdentifier: "toHintView", sender: nil)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        explanationTextView.resignFirstResponder()
        createRizzleManager.explanation = explanationTextView.text
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //Keyboard controls
    func textViewDidChange(_ textView: UITextView) {
        explanationPlaceHolderLabel?.isHidden = !explanationTextView.text.isEmpty
        if explanationTextView.text != nil {
            if explanationTextView.text!.characters.count == 1 {
                explanationLabel.isHidden = false
                self.explanationLabel.center = CGPoint(x: self.explanationLabel.center.x, y: self.explanationLabel.center.y + 20)
                UIView.animate(withDuration: 0.5, animations: {
                    self.explanationLabel.center = CGPoint(x: self.explanationLabel.center.x, y: self.explanationLabel.center.y - 20)
                })
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        explanationTextView.resignFirstResponder()
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
        explanationView.center = CGPoint(x: explanationView.center.x, y: explanationView.center.y - 100)
    }
    
    func keyboardWillDisappear(sender: NSNotification) {
        if nextButtonStart != nil {
            nextButton.center = nextButtonStart!
        }
        if backButtonStart != nil {
            backButton.center = backButtonStart!
        }
        explanationView.center = CGPoint(x: explanationView.center.x, y: explanationView.center.y + 100)
    }
    
}
