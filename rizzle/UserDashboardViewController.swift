//
//  UserDashboardViewController.swift
//  rizzle
//
//  Created by Erin Luu on 2016-12-15.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

import UIKit
import Parse

class UserDashboardViewController: UIViewController {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var weeklyScoreLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentUser = PFUser.current() else{
            print("No current user")
            logout()
            return
        }
        
        usernameLabel.text = currentUser.object(forKey: "rizzleName") as! String?
        weeklyScoreLabel.text = String(describing: currentUser.object(forKey: "weeklyScore") ?? "0")
        totalScoreLabel.text = String(describing: currentUser.object(forKey: "totalScore") ?? "0")
        
    }
    
    @IBAction func createRizzleTapped(_ sender: UIButton) {
        let createRizzleStoryboard = UIStoryboard(name: "CreateRizzle", bundle: nil)
        let createRizzleView = createRizzleStoryboard.instantiateViewController(withIdentifier: "createRizzle")
        present(createRizzleView, animated: true, completion: nil)
    }
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        logout()
    }
    
    func logout () {
        PFUser.logOut()
        guard let vc = UIStoryboard(name:"LoginStart", bundle:nil).instantiateViewController(withIdentifier: "LoginView") as? LoginViewController else {
            print("Could not instantiate view controller with identifier of type LoginViewController")
            return
        }
        self.present(vc, animated: true, completion: nil)
    }
}
