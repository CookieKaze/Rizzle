//
//  ProfileViewController.swift
//  rizzle
//
//  Created by Erin Luu on 2017-01-04.
//  Copyright © 2017 Erin Luu. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ProfileTabDelegate{
    
    var displayUser: PFUser?
    var subscription: PFObject?
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var totalSolvedLabel: UILabel!
    @IBOutlet weak var totalMadeLabel: UILabel!
    @IBOutlet weak var tabView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoImageView.layer.cornerRadius = photoImageView.frame.size.height/2;
        
        if displayUser != nil {
            setupFollowButton()
            if displayUser?["userPhoto"] != nil {
                let userImageFile = displayUser?["userPhoto"] as! PFFile
                userImageFile.getDataInBackground(block: { (imageData, error) in
                    if error == nil {
                        if let imageData = imageData {
                            self.photoImageView.image = UIImage(data: imageData)
                        }
                    }
                })
            }else {
                self.photoImageView.image = UIImage(named: "defaultProfileImage")
            }
            usernameLabel.text = displayUser?["rizzleName"] as? String
            totalScoreLabel.text = "Score: \(displayUser?["totalScore"] as! Int)"
        }
    }
    
    //MARK: Follow
    func setupFollowButton() {
        guard let currentUser = PFUser.current() else{
            print("No current user")
            return
        }
        if displayUser == currentUser {
            followButton.removeFromSuperview()
        }else {
            checkFollowStatus()
        }
    }
    
    func checkFollowStatus() {
        let query = PFQuery(className: "Subscriptions")
        query.whereKey("user", equalTo: displayUser!)
        query.whereKey("follower", equalTo: PFUser.current()!)
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                if (objects?.count)! > 0 {
                    self.subscription = objects?.first
                }
            }else {
                //Create new subscription record
                self.subscription = PFObject(className: "Subscriptions")
                self.subscription?["user"] = self.displayUser
                self.subscription?["follower"] = PFUser.current()
                self.subscription?["active"] = false
                self.subscription?.saveInBackground()
            }
            //Setup follow button
            if self.subscription?["active"] as! Bool == false {
                self.followButton.setTitle("Follow", for: .normal)
            } else {
                self.followButton.setTitle("Unfollow", for: .normal)
            }
        }
    }
    
    @IBAction func followButtonTapped(_ sender: UIButton) {
        if sender.titleLabel?.text == "Follow" {
            sender.setTitle("Unfollow", for: .normal)
            self.subscription?["active"] = true
        } else {
            sender.setTitle("Follow", for: .normal)
            self.subscription?["active"] = false
        }
        self.subscription?.saveInBackground()
    }
    
    //MARK: Image Picker
    @IBAction func photoTapped(_ sender: UITapGestureRecognizer) {
        if displayUser == PFUser.current() {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            let cameraAction = UIAlertAction(title: "Take a New Profile Image", style: UIAlertActionStyle.default, handler: { action in
                let picker = UIImagePickerController.init()
                picker.delegate = self
                picker.allowsEditing = true
                picker.sourceType = UIImagePickerControllerSourceType.camera
                
                self.present(picker, animated: true, completion: nil)
            })
            let albumAction = UIAlertAction(title: "Select From Photos", style: UIAlertActionStyle.default, handler: { action in
                let picker = UIImagePickerController.init()
                picker.delegate = self
                picker.allowsEditing = true
                picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                
                self.present(picker, animated: true, completion: nil)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            
            alertController.addAction(cameraAction)
            alertController.addAction(albumAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else {
            print("Could not get image")
            return
        }
        photoImageView.image = image
        
        //Save photo
        let currentUser = PFUser.current()
        guard let imageData = UIImageJPEGRepresentation(image, 0.75) else {
            print("Image cannot be converted to data. Image not stored.")
            return
        }
        
        if currentUser != nil{
            let imageFile = PFFile(name:"userPhoto.jpg", data:imageData)
            currentUser?["userPhoto"] = imageFile
            currentUser?.saveInBackground()
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Tab View
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileTabView" {
            let destination = segue.destination as! ProfileTabsViewController
            destination.displayUser = displayUser
            destination.delegate = self
        }
    }
    
    func updateTotalSolved(solve: Int) {
        totalSolvedLabel.text = "Solved: \(solve)"
    }
    
    func updateTotalMade(made: Int) {
        totalMadeLabel.text = "Made: \(made)"
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
