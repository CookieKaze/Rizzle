
//
//  RizzleCorrectViewController.swift
//  rizzle
//
//  Created by Erin Luu on 2017-01-08.
//  Copyright © 2017 Erin Luu. All rights reserved.
//

import UIKit
import Parse
import HCSStarRatingView

class RizzleCorrectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    let rizzleManager = RizzleManager.sharedInstance
    var rizzlePF: PFObject?
    var rizzle: Rizzle?
    var comments = [PFObject]()
    @IBOutlet weak var ratingView: UIView!
    
    @IBOutlet weak var creatorImageView: UIImageView!
    @IBOutlet weak var creatorUsernameLabel: UILabel!
    @IBOutlet weak var explainationTextView: UITextView!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Listen for keyboard appearances and disappearances
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(sender:)), name: .UIKeyboardWillShow, object: nil)
        
        creatorImageView.layer.cornerRadius = creatorImageView.frame.size.height/2
        rizzle = rizzleManager.currentRizzle
        rizzlePF = rizzleManager.currentRizzlePFObject
        
        setupView()
        //setupRating()
        getComments()
        
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
    
//    func setupRating() {
//        let starRatingView = HCSStarRatingView.init(frame: CGRect(x: 0, y: 0, width: ratingView.frame.width, height: ratingView.frame.height))
//            
//            starRatingView.maximumValue = 5
//            starRatingView.minimumValue = 0
//            starRatingView.value = 3;
//            starRatingView.tintColor = UIColor.yellow
//            [starRatingView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
//            [self.view addSubview:starRatingView];
//    }
    
    func getComments() {
        let commentViewQueue = DispatchQueue(label: "completeViewQueue", qos: .utility)
        commentViewQueue.async {
            guard let rizzle = self.rizzlePF else {
                return
            }
            
            let query = PFQuery(className: "RizzleComment")
            query.whereKey("rizzle", equalTo: rizzle)
            query.order(byAscending: "createdAt")
            
            do {
                let comments = try query.findObjects()
                if comments.count != 0 {
                    self.comments = comments
                    DispatchQueue.main.async {
                        self.commentTableView.reloadData()
                    }
                }
            }
            catch {
                print("Problem finding comments: \(error)")
            }
        }
    }
    
    @IBAction func commentSubmitTapped(_ sender: UIButton) {
        commentTextField.resignFirstResponder()
        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        if commentTextField.text != "" && commentTextField.text != nil {
            let comment = commentTextField.text
            
            //Submit to Parse
            let rizzleComment = PFObject(className: "RizzleComment")
            rizzleComment["comment"] = comment
            rizzleComment["user"] = PFUser.current()
            rizzleComment["rizzle"] = rizzlePF
            rizzleComment["creatorName"] = PFUser.current()?["rizzleName"] as! String
            rizzleComment.saveInBackground()
            commentTextField.text = ""
            
            //Update table with new comment
            getComments()
            
        }
    }
    @IBAction func closedButtonTapped(_ sender: UIButton) {
        //Returns to dash
    }
    
    //MARK: Comment table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if comments.count > 0 {
            return comments.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! RizzleCommentTableViewCell
        if comments.count > 0 {
            let comment = comments[indexPath.row]
            cell.usernameLabel.text = comment["creatorName"] as? String
            cell.commentLabel.text = comment["comment"] as? String
            
            let commentDate = comment.createdAt
            if commentDate != nil {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .none
                dateFormatter.dateFormat = "dd.MM.yy"
                dateFormatter.locale = Locale(identifier: "en_US")
                cell.dateLabel.text = dateFormatter.string(from:commentDate!)
            }
            
            //Get Image
            //            let user = comment["user"] as? PFUser
            //            if user != nil {
            //                let userImageFile = user!["userPhoto100"] as? PFFile
            //                userImageFile?.getDataInBackground(block: { (imageData, error) in
            //                    if error == nil {
            //                        if let imageData = imageData {
            //                            DispatchQueue.main.async {
            //                                cell.?.image = UIImage(data: imageData)
            //                            }
            //                        }
            //                    }
            //                })
            //            }
            
        }else {
            cell.commentLabel.text = "No comments found"
        }
        return cell
    }
    
    //MARK: Keyboard controls
    func keyboardWillAppear(sender: NSNotification) {
        let userInfo = sender.userInfo!
        if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            view.frame = CGRect(x: 0, y: keyboardHeight * -1, width: view.frame.width, height: view.frame.height)
        }
    }
    
    @IBAction func commentUserViewTapped(_ sender: UITapGestureRecognizer) {
        commentTextField.resignFirstResponder()
        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        return true
    }
    
    
}
