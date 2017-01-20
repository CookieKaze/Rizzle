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
        myRizzleTableView.separatorStyle = .none
        getMyRizzles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getMyRizzles()
    }
    
    
    func getMyRizzles() {
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "createEditRizzle" {
//            let createRizzleView = segue.destination as! CreateRizzleViewController
//            createRizzleView.rizzleToEdit = sender as? PFObject
//        }
//    }
    @IBAction func createNewRizzle(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "CreateRizzleStoryboard", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "createRizzleView")
        present(view, animated: true, completion: nil)
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: My Rizzle Table View
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myRizzles.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentRizzle = myRizzles[indexPath.row]
        let cell = myRizzleTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyRizzleTableViewCell
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 255/255, green: 188/255, blue: 71/255, alpha: 1)
        }else {
            cell.backgroundColor = UIColor(red: 255/255, green: 163/255, blue: 0/255, alpha: 1)
        }
        cell.rizzleTitleLabel.text = currentRizzle["title"] as? String
        
        let date = currentRizzle.createdAt
        if date != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "MMM d, yyyy"
            dateFormatter.locale = Locale(identifier: "en_US")
            cell.rizzleDateLabel.text = dateFormatter.string(from:date!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //createEditRizzle(rizzleToEdit: myRizzles[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = UIColor(red: 255/255, green: 142/255, blue: 0/255, alpha: 1)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if indexPath.row % 2 == 0 {
            cell?.backgroundColor = UIColor(red: 255/255, green: 188/255, blue: 71/255, alpha: 1)
        }else {
            cell?.backgroundColor = UIColor(red: 255/255, green: 163/255, blue: 0/255, alpha: 1)
        }
    }
    
}
