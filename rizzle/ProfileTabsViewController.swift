//
//  ProfileTabsViewController.swift
//  rizzle
//
//  Created by Erin Luu on 2017-01-04.
//  Copyright © 2017 Erin Luu. All rights reserved.
//

import UIKit
import Parse


class ProfileTabsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {
    
    var displayUser: PFObject?
    var userRizzles = [PFObject]()
    var currentTabView:Int = 0
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabView: UITabBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserRizzles()
    }
    
    func getUserRizzles () {
        if displayUser != nil {
            userRizzles = [PFObject]()
            let query = PFQuery(className:"Rizzle")
            query.whereKey("user", equalTo: displayUser!)
            query.findObjectsInBackground {
                (objects, error) in
                if error == nil {
                    // The find succeeded.
                    guard let objects = objects else { return }
                    self.userRizzles = objects.reversed()
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else {
                    // Log details of the failure
                    print("Error: \(error!)")
                }
            }
        }
    }
    
    func getCompletedRizzles() {
        if displayUser != nil {
            userRizzles = [PFObject]()
            let query = PFQuery(className:"SolvedRizzles")
            query.whereKey("completed", equalTo: true)
            query.whereKey("user", equalTo: displayUser!)
            query.findObjectsInBackground {
                (objects, error) in
                if error == nil {
                    // The find succeeded.
                    guard let objects = objects else { return }
                    for tracker in objects {
                        self.userRizzles.append(tracker.object(forKey: "rizzle") as! PFObject)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else {
                    // Log details of the failure
                    print("Error: \(error!)")
                }
            }
        }
    }
    
    //MARK: TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userRizzles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let currentRizzle = userRizzles[indexPath.row]
        cell.textLabel?.text = currentRizzle["title"] as? String
        cell.detailTextLabel?.text = currentRizzle["question"] as? String
        
        return cell
    }
    
    //MARK: TabBar Delegate
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == "Rizzles" {
            getUserRizzles()
        } else if item.title == "Completed" {
            getCompletedRizzles()
        }
    }
    
}
