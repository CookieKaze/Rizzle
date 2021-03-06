//
//  ProfileTabsViewController.swift
//  rizzle
//
//  Created by Erin Luu on 2017-01-04.
//  Copyright © 2017 Erin Luu. All rights reserved.
//

import UIKit
import Parse

protocol ProfileTabDelegate {
    func updateTotalSolved(solve: Int)
    func updateTotalMade(made: Int)
}

class ProfileTabsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {
    
    var displayUser: PFObject?
    var userRizzles = [PFObject]()
    var userFollowings = [PFObject]()
    var userFollowers = [PFObject]()
    var rizzlesCompleted = [PFObject]()
    var displayTab = "userRizzles"
    
    @IBOutlet weak var tabLoadingVIew: UIView!
    @IBOutlet weak var rizzleMarker: UIView!
    @IBOutlet weak var followingMarker: UIView!
    @IBOutlet weak var followerMarker: UIView!
    @IBOutlet weak var completedMarker: UIView!
    
    @IBOutlet weak var rizzleLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if displayUser != nil {
            getTableData()
        }
        tableView.separatorStyle = .none
    }
    
    //MARK: Data Setup
    func getTableData() {
        let tableDataQueue = DispatchQueue(label: "tableDataQueue", qos: .userInitiated)
        tableDataQueue.async {
            //Get rizzles created by user
            self.getUserRizzles()
            //Get following and followers
            self.getFollowers()
            self.getFollowing()
            //Get completed
            self.getCompletedRizzles()
            self.setupViewWithData()
        }
    }
    
    func getUserRizzles () {
        let query = PFQuery(className:"Rizzle")
        query.whereKey("user", equalTo: displayUser!)
        query.order(byAscending: "updatedAt")
        do {
            self.userRizzles = try query.findObjects()
            print("Got user rizzles")
        } catch {
            print("Can't get users rizzles: \(error)")
        }
        
    }
    
    func getFollowers () {
        let query = PFQuery(className:"Subscription")
        query.whereKey("user", equalTo: displayUser!)
        query.order(byAscending: "updatedAt")
        do {
            let subscription = try query.findObjects()
            for subscription in subscription {
                let user = subscription.object(forKey: "follower") as! PFUser
                user.fetchInBackground()
                self.userFollowers.append(user)
            }
            print("Got user followers")
        } catch {
            print("Can't get users followers: \(error)")
        }
    }
    
    func getFollowing () {
        let query = PFQuery(className:"Subscription")
        query.whereKey("follower", equalTo: displayUser!)
        query.order(byAscending: "updatedAt")
        do {
            let subscription = try query.findObjects()
            for subscription in subscription {
                let user = subscription.object(forKey: "user") as! PFUser
                user.fetchInBackground()
                self.userFollowings.append(user)
            }
            print("Got user followings")
        } catch {
            print("Can't get users following: \(error)")
        }
    }
    
    func getCompletedRizzles() {
        let query = PFQuery(className:"SolvedRizzle")
        query.whereKey("completed", equalTo: true)
        query.whereKey("user", equalTo: displayUser!)
        query.order(byAscending: "updatedAt")
        do {
            let trackers = try query.findObjects()
            for tracker in trackers {
                let rizzle = tracker.object(forKey: "rizzle") as! PFObject
                rizzle.fetchInBackground()
                self.rizzlesCompleted.append(rizzle)
            }
            print("Got user completed rizzles")
        } catch {
            print("Can't get completed rizzles: \(error)")
        }
    }
    
    func setupViewWithData() {
        DispatchQueue.main.async {
            self.rizzleLabel.text = String(self.userRizzles.count)
            self.followersLabel.text = String(self.userFollowers.count)
            self.followingLabel.text = String(self.userFollowings.count)
            self.completedLabel.text = String(self.rizzlesCompleted.count)
            self.rizzleMarker.backgroundColor = UIColor.orange
            self.displayTab = "userRizzles"
            self.tableView.reloadData()
            print("view done setting up")
            UIView.animate(withDuration: 1, animations: {
                self.tabLoadingVIew.alpha = 0
            }, completion: { (success) in
                self.tabLoadingVIew.isHidden = true
            })
        }
    }
    
    //MARK: Gesture Handler
    @IBAction func userRizzleTabTapped(_ sender: UITapGestureRecognizer) {
        resetTabColors()
        rizzleMarker.backgroundColor = UIColor.orange
        displayTab = "userRizzles"
        tableView.reloadData()
    }
    @IBAction func userFollowingTabTapped(_ sender: UITapGestureRecognizer) {
        resetTabColors()
        followingMarker.backgroundColor = UIColor.orange
        displayTab = "userFollowings"
        tableView.reloadData()
    }
    @IBAction func userFollowersTabTapped(_ sender: UITapGestureRecognizer) {
        resetTabColors()
        followerMarker.backgroundColor = UIColor.orange
        displayTab = "userFollowers"
        tableView.reloadData()
    }
    @IBAction func userCompletedTabTapped(_ sender: UITapGestureRecognizer) {
        resetTabColors()
        completedMarker.backgroundColor = UIColor.orange
        displayTab = "userCompleted"
        tableView.reloadData()
    }
    
    func resetTabColors() {
        rizzleMarker.backgroundColor = UIColor.white
        followerMarker.backgroundColor = UIColor.white
        followingMarker.backgroundColor = UIColor.white
        completedMarker.backgroundColor = UIColor.white
    }
    
    //MARK: TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 1
        switch displayTab {
        case "userRizzles":
            count = userRizzles.count
            break
        case "userFollowings":
            count = userFollowings.count
            break
        case "userFollowers":
            count = userFollowers.count
            break
        case "userCompleted":
            count = rizzlesCompleted.count
            break
        default:
            break
        }
        
        if count < 1 {
            count = 1
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if displayTab == "userRizzles" && userRizzles.count != 0 {
            let rizzle = userRizzles[indexPath.row]
            let rizzleCell = tableView.dequeueReusableCell(withIdentifier: "rizzleCell", for: indexPath) as! ProfileRizzleTableViewCell
            rizzleCell.rizzleTitleLabel.text = rizzle["title"] as? String
            if indexPath.row % 2 == 0 {
                rizzleCell.backgroundColor = UIColor(red: 255/255, green: 188/255, blue: 71/255, alpha: 1)
            }else {
                rizzleCell.backgroundColor = UIColor(red: 255/255, green: 163/255, blue: 0/255, alpha: 1)
            }
            
            return rizzleCell
            
        }else if displayTab == "userCompleted" && rizzlesCompleted.count != 0 {
            let rizzle = rizzlesCompleted[indexPath.row]
            let rizzleCell = tableView.dequeueReusableCell(withIdentifier: "rizzleCell", for: indexPath) as! ProfileRizzleTableViewCell
            rizzleCell.rizzleTitleLabel.text = rizzle["title"] as? String
            if indexPath.row % 2 == 0 {
                rizzleCell.backgroundColor = UIColor(red: 255/255, green: 188/255, blue: 71/255, alpha: 1)
            }else {
                rizzleCell.backgroundColor = UIColor(red: 255/255, green: 163/255, blue: 0/255, alpha: 1)
            }
            
            return rizzleCell
            
        }else if displayTab == "userFollowings" && userFollowings.count != 0 {
            let user = userFollowings[indexPath.row]
            let profileCell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileUserTableViewCell
            profileCell.usernameLabel.text = user["rizzleName"] as? String
            if user["userPhoto100"] != nil {
                let userImageFile = user["userPhoto100"] as! PFFile
                userImageFile.getDataInBackground(block: { (imageData, error) in
                    if error == nil {
                        if let imageData = imageData {
                            profileCell.userImageView.image = UIImage(data: imageData)
                        }
                    }
                })
            }else {
                profileCell.userImageView.image = UIImage(named: "defaultProfileImage")
                
            }
            
            if indexPath.row % 2 == 0 {
                profileCell.backgroundColor = UIColor(red: 255/255, green: 188/255, blue: 71/255, alpha: 1)
            }else {
                profileCell.backgroundColor = UIColor(red: 255/255, green: 163/255, blue: 0/255, alpha: 1)
            }
            
            return profileCell
            
        }else if  displayTab == "userFollowers" && userFollowers.count != 0 {
            let user = userFollowers[indexPath.row]
            let profileCell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileUserTableViewCell
            profileCell.usernameLabel.text = user["rizzleName"] as? String
            if user["userPhoto100"] != nil {
                let userImageFile = user["userPhoto100"] as! PFFile
                userImageFile.getDataInBackground(block: { (imageData, error) in
                    if error == nil {
                        if let imageData = imageData {
                            profileCell.userImageView.image = UIImage(data: imageData)
                        }
                    }
                })
            }else {
                profileCell.userImageView.image = UIImage(named: "defaultProfileImage")
            }
            
            if indexPath.row % 2 == 0 {
                profileCell.backgroundColor = UIColor(red: 255/255, green: 188/255, blue: 71/255, alpha: 1)
            }else {
                profileCell.backgroundColor = UIColor(red: 255/255, green: 163/255, blue: 0/255, alpha: 1)
            }
            
            return profileCell
            
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "No Results"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "User", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "userProfile") as! ProfileViewController
        
        if displayTab == "userFollowers" {
            viewController.displayUser = userFollowers[indexPath.row] as? PFUser
            self.navigationController?.pushViewController(viewController, animated: true)
        }else if displayTab == "userFollowings" {
            viewController.displayUser = userFollowings[indexPath.row] as? PFUser
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
