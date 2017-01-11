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
        tableView.separatorStyle = .none
        getGlobalLeaders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        leaderImageVIew.layer.cornerRadius = leaderImageVIew.frame.size.height/2
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
                let imageFile = self.users[0]["userPhoto"] as? PFFile
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
        if users.count > 0  {
            var count = users.count
            count -= 1
            return count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LeaderboardTableViewCell
        if users.count > 0  {
            cell.positionLabel.text = String(indexPath.row + 2)
            cell.usernameLabel.text = users[indexPath.row + 1]["rizzleName"] as? String
            cell.scoreLabel.text = "\(users[indexPath.row + 1]["totalScore"] as? Int ?? 0)"
            
            //Load Image
            let imageFile = self.users[indexPath.row + 1]["userPhoto100"] as? PFFile
            if imageFile != nil {
                imageFile?.getDataInBackground(block: {(imageData, error) in
                    if error == nil {
                        if let imageData = imageData {
                            let image = UIImage(data:imageData)
                            cell.userImageView.image = image
                        }
                    }
                })
            }else {
                cell.userImageView.image = UIImage(named: "defaultProfileImage")
            }
        } else {
            cell.positionLabel.text = ""
            cell.usernameLabel.text = "Please try again later."
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let navController = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "ProfileNavController") as! UINavigationController
        let creatorProfileView = navController.viewControllers[0] as! ProfileViewController
        creatorProfileView.displayUser = users[indexPath.row + 1]
        present(navController, animated: true, completion: nil)
    }
    
    @IBAction func leaderTapped(_ sender: UITapGestureRecognizer) {
        let navController = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "ProfileNavController") as! UINavigationController
        let creatorProfileView = navController.viewControllers[0] as! ProfileViewController
        creatorProfileView.displayUser = users[0]
        present(navController, animated: true, completion: nil)
    }
}
