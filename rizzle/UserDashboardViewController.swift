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
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var myRizzleButton: UIButton!
    @IBOutlet weak var ProfileButton: UIButton!
    @IBOutlet weak var leaderboardButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var outterUserImageView: UIView!
    @IBOutlet weak var newRizzleView: UIView!
    @IBOutlet weak var continueRizzleView: UIView!
    
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
        totalScoreLabel.text = String(describing: currentUser.object(forKey: "totalScore") ?? "0")
        
        userImageView.layer.cornerRadius = userImageView.frame.size.height/2
        outterUserImageView.layer.cornerRadius = outterUserImageView.frame.size.height/2
        newRizzleView.layer.borderColor = UIColor.white.cgColor
        newRizzleView.layer.borderWidth = 1
        continueRizzleView.layer.borderColor = UIColor.white.cgColor
        continueRizzleView.layer.borderWidth = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
            if PFUser.current()?["userPhoto"] != nil {
                let userImageFile = PFUser.current()?["userPhoto"] as! PFFile
                userImageFile.getDataInBackground(block: { (imageData, error) in
                    if error == nil {
                        if let imageData = imageData {
                            self.userImageView.image = UIImage(data: imageData)
                        }
                    }
                })
            }else {
                self.userImageView.image = UIImage(named: "defaultProfileImage")
            }
        
        menuView.isHidden = true
        menuView.frame = CGRect(x: menuView.frame.origin.x - menuView.frame.width, y: menuView.frame.origin.y, width: menuView.frame.size.width, height: menuView.frame.size.height)
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
            let navController = segue.destination as! UINavigationController
            let destination = navController.viewControllers[0] as! ProfileViewController
            destination.displayUser = PFUser.current()
        }
    }
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        menuView.frame = CGRect(x: menuView.frame.origin.x - menuView.frame.width, y: menuView.frame.origin.y, width: menuView.frame.size.width, height: menuView.frame.size.height)
        menuView.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.menuView.frame = CGRect(x: 0, y: 0, width: self.menuView.frame.size.width, height: self.menuView.frame.size.height)
        })
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.5, animations: {
            self.menuView.frame = CGRect(x: self.menuView.frame.origin.x - self.menuView.frame.width, y: self.menuView.frame.origin.y, width: self.menuView.frame.size.width, height: self.menuView.frame.size.height)
        }) { (success) in
            self.menuView.isHidden = true
        }
        
    }
    
}
