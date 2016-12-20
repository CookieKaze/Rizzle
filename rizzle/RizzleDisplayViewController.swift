//
//  RizzleDisplayViewController.swift
//  rizzle
//
//  Created by Matthew Mauro on 2016-12-19.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

import UIKit
import Parse

class RizzleDisplayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var rizzleTableView: UITableView!
    var solvableRizzles = NSMutableArray()
    var sendingRizzle:Rizzle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let currentUser = PFUser.current() else{
            print("No current user")
            return
        }
        
        // Query for Rizzles
        let query = PFQuery(className: "Rizzle")
        query.whereKey("_User", notEqualTo: currentUser.username!)
        query.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
            if error == nil {
                // find is successful
                // fill solvableRizzle Array with 5 rizzles, not completed by current user
                print("Successfully retrieved \(objects!.count) objects.")
                
                guard let objects = objects else {
                    print("No objects found")
                    return
                }
                let usedIndexes = NSMutableArray()
                
                // pull 5 Rizzles from 'objects' making sure non are repeated
                for _ in 1...5 {
                    let rand = Int(arc4random_uniform(UInt32(objects.count)))
                    if usedIndexes.contains(rand) == false {
                        usedIndexes.add(rand)
                        let comparison = objects[rand]
                        // relay 'comparison' PFObject to Rizzle, and add to array
                        // setup Hints from PFObject into a hints array
                        let hints:Array<String> = [(comparison.object(forKey: "hint1") as? String)!,
                                                   (comparison.object(forKey: "hint2") as? String)!,
                                                   (comparison.object(forKey: "hint3") as? String)!]
                        
                        let toAdd = Rizzle.init(title: (comparison.object(forKey: "title") as! String),
                                                question: (comparison.object(forKey: "question") as! String),
                                                answer: (comparison.object(forKey: "answer") as! String),
                                                creator: (comparison.object(forKey: "_User") as! String),
                                                hints: hints)
                        toAdd.objectId = (comparison.objectId)! as String
                        
                        //add to array and reloadData
                        self.solvableRizzles.add(toAdd)
                        self.rizzleTableView.reloadData()
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!)")
            }
        }
    }
    
    // Select cell, segue to SolveRizzle, with current rizzle in cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sendingRizzle = self.solvableRizzles[indexPath.row] as? Rizzle
    }
    //MARK: - TableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rizzleCell", for: indexPath) as! RizzleCell
        let rizzle = self.solvableRizzles[indexPath.row] as! Rizzle
        cell.currentRizzle = rizzle
        cell.textLabel?.text = rizzle.title
        cell.detailTextLabel?.text = rizzle.description
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier?.isEqual("solveRizzle"))! {
            if let vc: SolveRizzleViewController = segue.destination as? SolveRizzleViewController {
                vc.currentRizzle = self.sendingRizzle
            }
        }
    }
}
