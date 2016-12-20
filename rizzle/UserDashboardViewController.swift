//
//  UserDashboardViewController.swift
//  rizzle
//
//  Created by Erin Luu on 2016-12-15.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

import UIKit
import Parse

class UserDashboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //MARK: Properties
    var myRizzles = [PFObject]()
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var weeklyScoreLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var myRizzleTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentUser = PFUser.current() else{
            print("No current user")
            logout()
            return
        }
        
        //Setup View
        usernameLabel.text = currentUser.object(forKey: "rizzleName") as! String?
        weeklyScoreLabel.text = String(describing: currentUser.object(forKey: "weeklyScore") ?? "0")
        totalScoreLabel.text = String(describing: currentUser.object(forKey: "totalScore") ?? "0")
        
        //Get My Rizzles
        let query = PFQuery(className:"Rizzle")
        query.whereKey("user", equalTo:currentUser)
        query.findObjectsInBackground {
            (objects, error) in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) objects.")
                
                guard let objects = objects else {
                    print("No objects found")
                    return
                }
                self.myRizzles = objects.reversed()
                self.myRizzleTableView.reloadData()
            } else {
                // Log details of the failure
                print("Error: \(error!)")
            }
        }
    }
    
    //MARK: My Rizzle Table View
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myRizzles.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentRizzle = myRizzles[indexPath.row]
        let cell = myRizzleTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = currentRizzle["title"] as? String
        cell.detailTextLabel?.text = currentRizzle["question"] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        createEditRizzle(rizzleToEdit: myRizzles[indexPath.row])
    }
    
    //MARK: Navigation and Segues
    
    func createEditRizzle(rizzleToEdit: PFObject?) {
        let createRizzleStoryboard = UIStoryboard(name: "CreateRizzle", bundle: nil)
        let createRizzleView = createRizzleStoryboard.instantiateViewController(withIdentifier: "createRizzle") as! CreateRizzleViewController
        createRizzleView.rizzleToEdit = rizzleToEdit
        present(createRizzleView, animated: true, completion: nil)
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
    @IBAction func createRizzleTapped(_ sender: UIButton) {
        createEditRizzle(rizzleToEdit: nil)
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        logout()
    }
}
