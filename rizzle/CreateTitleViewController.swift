//
//  CreateTitleViewController.swift
//  rizzle
//
//  Created by Erin Luu on 2017-01-18.
//  Copyright © 2017 Erin Luu. All rights reserved.
//

import UIKit

class CreateTitleViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    var nextButtonStart: CGPoint?
    var titleViewStart: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(sender:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(sender:)), name: .UIKeyboardWillHide, object: nil)

        if titleViewStart != nil {
            titleView.center = titleViewStart!
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func loadFields() {
        //Load title
        //        titleTextField.text = rizzleToEdit["title"] as? String
        //        titleLabel.isHidden = false
        
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        titleTextField.resignFirstResponder()
        //Check for blank title
        if titleTextField.text == nil || titleTextField.text == "" {
            let alertView = PopupAlertViewController(nibName: "PopupAlertViewController", bundle: nil)
            alertView.bodyText = "The Title field cannot be blank."
            self.present(alertView, animated: false, completion: nil)
        } else {
                        performSegue(withIdentifier: "toCreateQuestionView", sender: nil)
            
        }
    }
    
    //Keyboard controls
    @IBAction func titleFieldChanged(_ sender: UITextField) {
        if titleTextField.text != nil {
            if titleTextField.text!.characters.count == 1 {
                titleLabel.isHidden = false
                self.titleLabel.center = CGPoint(x: self.titleLabel.center.x, y: self.titleLabel.center.y + 20)
                UIView.animate(withDuration: 0.5, animations: {
                    self.titleLabel.center = CGPoint(x: self.titleLabel.center.x, y: self.titleLabel.center.y - 20)
                })
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillAppear(sender: NSNotification) {
        nextButtonStart = nextButton.center
        let userInfo = sender.userInfo!
        if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            self.nextButton.center = CGPoint(x: nextButton.center.x, y: nextButton.center.y - keyboardHeight/1.4)
        }
        
        //Shift View
        titleView.center = CGPoint(x: titleView.center.x, y: titleView.center.y - 60)
    }
    
    func keyboardWillDisappear(sender: NSNotification) {
        if nextButtonStart != nil {
            nextButton.center = nextButtonStart!
        }
        titleView.center = CGPoint(x: titleView.center.x, y: titleView.center.y + 60)
        
    }
    
    
}
