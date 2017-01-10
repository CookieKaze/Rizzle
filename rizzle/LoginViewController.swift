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
                    //User Dashboard Segue setup
                    let userStoryboard = UIStoryboard.init(name: "User", bundle: nil)
                    let dashboardView: UserDashboardViewController = userStoryboard.instantiateViewController(withIdentifier: "userDashboard") as! UserDashboardViewController
                    self.present(dashboardView, animated: true, completion: nil)
                    
                }
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
                let alertView = PopupAlertViewController(nibName: "PopupAlertViewController", bundle: nil)
                alertView.bodyText = "Facebook login cancelled.\nPlease try again."
                self.present(alertView, animated: false, completion: nil)
            }
        })
    }
}



