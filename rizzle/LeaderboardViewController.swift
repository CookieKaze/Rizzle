//
//  LeaderboardViewController.swift
//  rizzle
//
//  Created by Erin Luu on 2017-01-07.
//  Copyright © 2017 Erin Luu. All rights reserved.
//

import UIKit
import Parse

class LeaderboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Properties
    var users = [PFUser]()
    @IBOutlet weak var leaderImageVIew: UIImageView!
    @IBOutlet weak var leaderUsernameLabel: UILabel!
    @IBOutlet weak var leaderscoreLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        getGlobalLeaders()
    }
    
    func getGlobalLeaders() {
        let leaderQueue = DispatchQueue(label: "leaderQueue", qos: .userInitiated)
        leaderQueue.async {
            let query = PFUser.query()
            query?.addDescendingOrder("totalScore")
            query?.limit = 100
            do {
                self.users = try query?.findObjects() as! [PFUser]
                //Load Image
                let imageFile = self.users[0]["imageFile"] as? PFFile
                if imageFile != nil {
                    imageFile?.getDataInBackground(block: {(imageData, error) in
                        if error == nil {
                            if let imageData = imageData {
                                let image = UIImage(data:imageData)
                                DispatchQueue.main.async {
                                    self.leaderImageVIew.image = image
                                }
                            }
                        }
                        
                    })
                }else {
                    DispatchQueue.main.async {
                        self.leaderImageVIew.image = UIImage(named: "defaultProfileImage")
                    }
                }
                DispatchQueue.main.async {
                    self.leaderUsernameLabel.text = self.users[0]["rizzleName"] as? String
                    self.leaderscoreLabel.text = "\(self.users[0]["totalScore"] as? Int ?? 0)"
                    self.tableView.reloadData()
                }
            } catch {
                print("Can't find users: \(error)")
            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Table Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LeaderboardTableViewCell
        //        cell.positionLabel.text = ""
        //        cell.userImageView.image = UIImage
        //        cell.usernameLabel.text = ""
        //        cell.scoreLabel.text = ""
        return cell
    }
    
    
    
}
