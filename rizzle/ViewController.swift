//
//  ViewController.swift
//  rizzle
//
//  Created by Erin Luu on 2016-12-15.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

import UIKit
import FacebookLogin

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func FBLoginTapped(_ sender: UIButton) {
        facebookSignIn()
    }
    
    @objc fileprivate func facebookSignIn() {
        //        let loginManager = LoginManager()
        //        print("LOGIN MANAGER: \(loginManager)")
        //        loginManager.logIn([ .publicProfile, .email ], viewController: self) { loginResult in
        //            print("LOGIN RESULT! \(loginResult)")
        //            switch loginResult {
        //            case .failed(let error):
        //                print("FACEBOOK LOGIN FAILED: \(error)")
        //            case .cancelled:
        //                print("User cancelled login.")
        //            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
        //                print("Logged in!")
        //                print("GRANTED PERMISSIONS: \(grantedPermissions)")
        //                print("DECLINED PERMISSIONS: \(declinedPermissions)")
        //                print("ACCESS TOKEN \(accessToken)")
        //            }
        //        }
        
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile, .email ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
                print("GRANTED PERMISSIONS: \(grantedPermissions)")
                print("DECLINED PERMISSIONS: \(declinedPermissions)")
                print("ACCESS TOKEN \(accessToken)")
            }
        }
    }
    
}

