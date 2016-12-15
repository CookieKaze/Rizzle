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
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func saveNameTapped(_ sender: UIButton) {
        let unCheckedUsername = rizzleNameField.text
        
        //Check for dup username
        let query = PFQuery(className: "User")
        if rizzleNameField.text != nil || (rizzleNameField.text?.characters.count)! > 0 {
            query.whereKey("rizzleName", equalTo:unCheckedUsername!)
            query.findObjectsInBackground(block: { (objects, error) in
                
                if error == nil {
                    // The find succeeded.
                    self.statusLabel.text = "Username already exist"
                } else {
                    PFUser.current()?["rizzleName"] = self.rizzleNameField.text
                    PFUser.current()?.saveInBackground(block: {(success, error) in
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
        resignFirstResponder()
    }
}
