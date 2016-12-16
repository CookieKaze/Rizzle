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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logoutButton: UIButton = UIButton(type: .custom)
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.backgroundColor = .gray
        logoutButton.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        logoutButton.center = view.center;
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        view.addSubview(logoutButton)
        
    }

    func logoutButtonTapped () {
        PFUser.logOut()
        guard let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "LoginView") as? LoginViewController else {
            print("Could not instantiate view controller with identifier of type LoginViewController")
            return
        }
        self.present(vc, animated: true, completion: nil)   
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
