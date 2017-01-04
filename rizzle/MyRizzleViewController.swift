//
//  MyRizzleViewController.swift
//  rizzle
//
//  Created by Erin Luu on 2017-01-04.
//  Copyright © 2017 Erin Luu. All rights reserved.
//

import UIKit
import Parse

class MyRizzleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var myRizzles = [PFObject]()
    @IBOutlet weak var myRizzleTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let currentUser = PFUser.current() else{
            print("No current user")
            return
        }
        
        //Get My Rizzles
        let query = PFQuery(className:"Rizzle")
        query.whereKey("user", equalTo: currentUser)
        query.findObjectsInBackground {
            (objects, error) in
            if error == nil {
                // The find succeeded.
                guard let objects = objects else { return }
                self.myRizzles = objects.reversed()
                self.myRizzleTableView.reloadData()
            } else {
                // Log details of the failure
                print("Error: \(error!)")
            }
        }
    }
    
    func createEditRizzle(rizzleToEdit: PFObject?) {
        performSegue(withIdentifier: "createEditRizzle", sender: rizzleToEdit)
    }
    
    @IBAction func createRizzleTapped(_ sender: UIButton) {
        createEditRizzle(rizzleToEdit: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createEditRizzle" {
            let createRizzleView = segue.destination as! CreateRizzleViewController
            createRizzleView.rizzleToEdit = sender as? PFObject
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
}
