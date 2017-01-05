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
    //MARK: Properties
    var rizzleManager: RizzleManager!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var weeklyScoreLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rizzleManager = RizzleManager.sharedInstance
        guard let currentUser = PFUser.current() else{
            print("No current user")
            logout()
            return
        }
        
        //Setup View
        usernameLabel.text = currentUser.object(forKey: "rizzleName") as! String?
        weeklyScoreLabel.text = String(describing: currentUser.object(forKey: "weeklyScore") ?? "0")
        totalScoreLabel.text = String(describing: currentUser.object(forKey: "totalScore") ?? "0")
    }
    
    //MARK: Navigation and Segues
    func newRizzle(){
        let newRizzleView = UIStoryboard(name: "Rizzle", bundle: nil).instantiateViewController(withIdentifier: "solveRizzle") as! RizzleSolveViewController
        rizzleManager.currentRizzlePFObject = nil
        present(newRizzleView, animated: true, completion: nil)
    }
    
    func continueRizzle(){
        let continueRizzleView = UIStoryboard(name: "Rizzle", bundle: nil).instantiateViewController(withIdentifier: "continueRizzle") as! ContinueRizzleViewController
        present(continueRizzleView, animated: true, completion: nil)
    }
    
    func logout () {
        PFUser.logOut()
        guard let vc = UIStoryboard(name:"LoginStart", bundle:nil).instantiateViewController(withIdentifier: "LoginView") as? LoginViewController else {
            print("Could not instantiate view controller with identifier of type LoginViewController")
            return
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: Button Actions
    @IBAction func newRizzleTapped(_ sender: UIButton) {
        newRizzle()
    }
    
    @IBAction func continueRizzleTapped(_ sender: UIButton) {
        continueRizzle()
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        logout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProfile" {
            let destination = segue.destination as! ProfileViewController
            destination.displayUser = PFUser.current()
        }
    }
}
