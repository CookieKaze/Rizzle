//
//  ProfileViewController.swift
//  rizzle
//
//  Created by Erin Luu on 2017-01-04.
//  Copyright © 2017 Erin Luu. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userInfoLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var totalSolvedLabel: UILabel!
    @IBOutlet weak var totalMadeLabel: UILabel!
    @IBOutlet weak var tabView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func avatarTapped(_ sender: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Take a New Profile Image", style: UIAlertActionStyle.default, handler: { action in
            print("Cats")
        })
        let albumAction = UIAlertAction(title: "Select From Photos", style: UIAlertActionStyle.default, handler: { action in
            print("Something")
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(albumAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
