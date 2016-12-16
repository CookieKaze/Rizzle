//
//  LoginViewController.swift
//  rizzle
//
//  Created by Erin Luu on 2016-12-15.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

import UIKit
import Parse
import FacebookLogin
import ParseFacebookUtilsV4

class LoginViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func FBLoginTapped(_ sender: UIButton) {
        parseFacebookSignIn()
    }
    
    func parseFacebookSignIn() {
        PFFacebookUtils.logInInBackground(withReadPermissions: ["public_profile", "email"], block: {
            (user, error) in
            if let user = user {
                if user.isNew {
                    print("User signed up and logged in through Facebook!")
                    self.performSegue(withIdentifier: "firstTimeUser", sender: nil)
                    
                } else {
                    print("User logged in through Facebook!")
                    self.performSegue(withIdentifier: "loginToMain", sender: nil)
                }
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
                self.statusLabel.text = "The user cancelled the Facebook login"
            }
        })
    }
    
    static func storyboardInstance() -> LoginViewController? {
//        let storyboard = UIStoryboard(name:
//            “HomeViewController”, bundle: nil) return
//                storyboard.instantiateInitialViewController() as?
//        HomeViewController
        
        let storyboard = 
    }
    
}

