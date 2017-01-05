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
    var rizzlesSolved = [PFObject]()
    var delegate: ProfileTabDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabView: UITabBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if displayUser != nil {
            getUserRizzles()
            getCompletedRizzles()
        }
        
        let tabItem = tabView.items?[0]
        tabView.selectedItem = tabItem
    }
    
    func getUserRizzles () {
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
                    self.delegate?.updateTotalMade(made: self.userRizzles.count)
                    self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!)")
            }
        }
    }
    
    func getCompletedRizzles() {
        rizzlesSolved = [PFObject]()
        let query = PFQuery(className:"SolvedRizzles")
        query.whereKey("completed", equalTo: true)
        query.whereKey("user", equalTo: displayUser!)
        query.findObjectsInBackground {
            (objects, error) in
            if error == nil {
                // The find succeeded.
                guard let objects = objects else { return }
                for tracker in objects {
                    self.rizzlesSolved.append(tracker.object(forKey: "rizzle") as! PFObject)
                }
                DispatchQueue.main.async {
                    self.delegate?.updateTotalSolved(solve: self.rizzlesSolved.count)
                }
            } else {
                // Log details of the failure
                print("Error: \(error!)")
            }
        }
    }
    
    //MARK: TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 1
        if tabView.selectedItem?.title == "Rizzles" {
            count = userRizzles.count
        } else if tabView.selectedItem?.title == "Completed" {
            count = rizzlesSolved.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var currentRizzle: PFObject?
        if tabView.selectedItem?.title == "Rizzles" && userRizzles.count > 0{
            currentRizzle = userRizzles[indexPath.row]
            cell.textLabel?.text = currentRizzle?["title"] as? String
            cell.detailTextLabel?.text = currentRizzle?["question"] as? String
            
        } else if tabView.selectedItem?.title == "Completed" && rizzlesSolved.count > 0 {
            currentRizzle = rizzlesSolved[indexPath.row]
            cell.textLabel?.text = currentRizzle?["title"] as? String
            cell.detailTextLabel?.text = currentRizzle?["question"] as? String
        }
        return cell
    }
    
    //MARK: TabBar Delegate
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == "Rizzles" {
            self.tableView.reloadData()
        } else if item.title == "Completed" {
            self.tableView.reloadData()
        }
    }
    
}
