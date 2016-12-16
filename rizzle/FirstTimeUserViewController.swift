//
//  FirstTimeUserViewController.swift
//  rizzle
//
//  Created by Erin Luu on 2016-12-15.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

import UIKit
import Parse

class FirstTimeUserViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var rizzleNameField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rizzleNameField.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func saveNameTapped(_ sender: UIButton) {
        let unCheckedUsername = rizzleNameField.text
        
        //Check for dup username
        let query = PFUser.query()
        if rizzleNameField.text != nil && (rizzleNameField.text?.characters.count)! > 0 {
            query?.whereKey("rizzleName", equalTo:unCheckedUsername!)
            query?.findObjectsInBackground(block: { (objects, error) in
                
                guard let objects = objects else {
                    print("User object is nil")
                    return
                }
                
                guard let currentUser = PFUser.current() else {
                    print("Current user is nil")
                    return
                }
                
                if objects.count > 0 {
                    // The find succeeded.
                    self.statusLabel.text = "Username already exist"
                } else {
                    currentUser["rizzleName"] = self.rizzleNameField.text
                    currentUser["weeklyScore"] = NSNumber(integerLiteral: 0)
                    currentUser["totalScore"] = NSNumber(integerLiteral: 0)
                    currentUser.saveInBackground(block: {(success, error) in
                        if (success) {
                            self.performSegue(withIdentifier: "loginToMain", sender: self)
                        } else {
                            self.statusLabel.text = "Problem saving username. Please try again later."
                        }
                    })
                }
            })
        }else {
            self.statusLabel.text = "The username field cannot be blank"
        }
    }
    
    //MARK: Keyboard resign
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        rizzleNameField.resignFirstResponder()
    }
    
    
    // Prevent typing of special characters
    let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String)-> Bool
    {
        let set = NSCharacterSet(charactersIn: allowedCharacters)
        let notAllowedCharacters = set.inverted
        
        let textFieldInvalidCharPosition = string.rangeOfCharacter(from: notAllowedCharacters)
        if (textFieldInvalidCharPosition != nil) {
            return false
        } else {
            return true
        }
    }
}
