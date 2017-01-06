//
//  ContinueRizzleViewController.swift
//  rizzle
//
//  Created by Erin Luu on 2017-01-02.
//  Copyright © 2017 Erin Luu. All rights reserved.
//

import UIKit
import Parse

class ContinueRizzleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    var currentUser: PFUser!
    var incompleteRizzles = [PFObject]()
    var incompleteRizzleTrackers = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentUser = PFUser.current() else{
            print("No current user")
            return
        }
        self.currentUser = currentUser
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let unsolvedRizzleQueue = DispatchQueue(label: "unsolvedRizzleQueue", qos: .userInitiated)
        
        //Get unsolved Rizzles
        unsolvedRizzleQueue.async {
            self.findIncompleteTrackers()
        }
    }
    
    func findIncompleteTrackers() {
        // Get all Rizzle trackers with current user
        let query = PFQuery(className: "SolvedRizzle")
        query.includeKey("rizzle")
        query.whereKey("user", equalTo: currentUser)
        query.whereKey("completed", equalTo: false)
        
        //Try finding the rizzles solve by the user
        do {
            self.incompleteRizzleTrackers = try query.findObjects()
            setRizzlesFromTrackers()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Problem finding rizzles \(error)")
        }
        
    }
    
    func setRizzlesFromTrackers() {
        if incompleteRizzleTrackers.count > 0 {
            for tracker in incompleteRizzleTrackers {
                let rizzle = tracker.object(forKey: "rizzle") as! PFObject
                incompleteRizzles.append(rizzle)
            }
        }
    }
    
    //MARK: Table View DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 1
        if incompleteRizzleTrackers.count > 0 {
            numberOfRows = incompleteRizzleTrackers.count
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContinueRizzleCell
        
        if incompleteRizzleTrackers.count > 0 {
            let tracker = incompleteRizzleTrackers[indexPath.row]
            let rizzle = tracker.object(forKey: "rizzle") as! PFObject
            cell.titleLabel.text = rizzle.object(forKey: "title") as? String
        } else {
            cell.titleLabel.text = "No incomplete Rizzle found"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if incompleteRizzles.count != 0 {
            let solveRizzleView = UIStoryboard(name: "Rizzle", bundle: nil).instantiateViewController(withIdentifier: "solveRizzle") as! RizzleSolveViewController
            solveRizzleView.continueRizzlePF = incompleteRizzles[indexPath.row]
            solveRizzleView.continueRizzleTrackerPF = incompleteRizzleTrackers[indexPath.row]
            present(solveRizzleView, animated: true, completion: nil)
        }
    }
    
    @IBAction func backToDashTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
