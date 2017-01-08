
//
//  RizzleCorrectViewController.swift
//  rizzle
//
//  Created by Erin Luu on 2017-01-08.
//  Copyright © 2017 Erin Luu. All rights reserved.
//

import UIKit
import Parse

class RizzleCorrectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let rizzleManager = RizzleManager.sharedInstance
    var rizzlePF: PFObject?
    var rizzle: Rizzle?
    
    @IBOutlet weak var creatorImageView: UIImageView!
    @IBOutlet weak var creatorUsernameLabel: UILabel!
    @IBOutlet weak var explainationTextView: UITextView!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creatorImageView.layer.cornerRadius = creatorImageView.frame.size.height/2
        rizzle = rizzleManager.currentRizzle
        rizzlePF = rizzleManager.currentRizzlePFObject
        setupView()
        
    }
    
    func setupView() {
        let completeViewQueue = DispatchQueue(label: "completeViewQueue", qos: .utility)
        explainationTextView.text = rizzle?.explanation
        completeViewQueue.async {
            do {
                guard let rizzle = self.rizzle else {
                    return
                }
                let creator = try rizzle.creator.fetch()
                //Try getting user image
                guard let userImageFile = creator["userPhoto"] as? PFFile else {
                    return
                }
                userImageFile.getDataInBackground(block: { (imageData, error) in
                    if error == nil {
                        if let imageData = imageData {
                            DispatchQueue.main.async {
                                self.creatorImageView.image = UIImage(data: imageData)
                                self.creatorUsernameLabel.text = creator["rizzleName"] as? String
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.creatorImageView.image = UIImage(named: "defaultProfileImage")
                            self.creatorUsernameLabel.text = creator["rizzleName"] as? String
                        }
                    }
                })
            }
            catch {}
        }
    }
    
    @IBAction func commentSubmitTapped(_ sender: UIButton) {
        //Get comment from field
        //Submit to Parse
        //Update table with new comment
    }
    @IBAction func closedButtonTapped(_ sender: UIButton) {
        //Returns to dash
    }
    
    //MARK: Comment table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! RizzleCommentTableViewCell
        return cell
    }
    
    
    
}
