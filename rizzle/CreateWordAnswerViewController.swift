//
//  CreateWordAnswerViewController.swift
//  rizzle
//
//  Created by Erin Luu on 2017-01-22.
//  Copyright © 2017 Erin Luu. All rights reserved.
//

import UIKit

class CreateWordAnswerViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var answerView: UIView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    var nextButtonStart: CGPoint?
    var backButtonStart: CGPoint?
    var createRizzleManager = CreateRizzleManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answerLabel.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(sender:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(sender:)), name: .UIKeyboardWillHide, object: nil)
        
        //Load field if value is not nil
        if createRizzleManager.answer != nil {
            answerTextField.text = createRizzleManager.answer
            answerLabel.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        answerTextField.resignFirstResponder()
        
        //Check for blank fields
        if answerTextField.text == nil || answerTextField.text == "" {
            let alertView = PopupAlertViewController(nibName: "PopupAlertViewController", bundle: nil)
            alertView.bodyText = "Your Rizzle has to have an answer."
            self.present(alertView, animated: false, completion: nil)
        } else {
            createRizzleManager.answer = answerTextField.text
            performSegue(withIdentifier: "toExplanationView", sender: nil)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        createRizzleManager.answer = answerTextField.text
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //Keyboard controls
    @IBAction func answerFieldDidChange(_ sender: UITextField) {
        if answerTextField.text != nil {
            if answerTextField.text!.characters.count == 1 {
                answerLabel.isHidden = false
                self.answerLabel.center = CGPoint(x: self.answerLabel.center.x, y: self.answerLabel.center.y + 20)
                UIView.animate(withDuration: 0.5, animations: {
                    self.answerLabel.center = CGPoint(x: self.answerLabel.center.x, y: self.answerLabel.center.y - 20)
                })
            }
        }
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        answerTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        answerTextField.resignFirstResponder()
        return true
    }
    
    
    
    func keyboardWillAppear(sender: NSNotification) {
        let userInfo = sender.userInfo!
        if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            nextButtonStart = nextButton.center
            backButtonStart = backButton.center
            let keyboardHeight = keyboardSize.height
            self.nextButton.center = CGPoint(x: nextButton.center.x, y: nextButton.center.y - keyboardHeight/1.5)
            self.backButton.center = CGPoint(x: backButton.center.x, y: backButton.center.y - keyboardHeight/1.5)
            //Shift View
            answerView.center = CGPoint(x: answerView.center.x, y: answerView.center.y - 100)
        }
        
    }
    
    func keyboardWillDisappear(sender: NSNotification) {
        if nextButtonStart != nil {
            nextButton.center = nextButtonStart!
        }
        if backButtonStart != nil {
            backButton.center = backButtonStart!
        }
        answerView.center = CGPoint(x: answerView.center.x, y: answerView.center.y + 100)
    }
    
    
    
}
