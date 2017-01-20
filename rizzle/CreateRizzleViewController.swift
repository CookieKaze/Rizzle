//
//  CreateRizzleViewController.swift
//  rizzle
//
//  Created by Erin Luu on 2017-01-18.
//  Copyright © 2017 Erin Luu. All rights reserved.
//

import UIKit

class CreateRizzleViewController: UIViewController {

    var createRizzleManager = CreateRizzleManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func rizzleTypeTapped(_ sender: UIButton) {
        createRizzleManager.clearProperties()
        
        switch sender.tag {
        //Word Answer
        case 1:
            createRizzleManager.rizzleType = "word"
            break
        //Multiple Choice
        case 2:
            createRizzleManager.rizzleType = "multiple"
            break
        //Number Answer
        case 3:
            createRizzleManager.rizzleType = "number"
            break
        default:
            break
        }
        
        performSegue(withIdentifier: "toTitleCreator", sender: nil)
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unwindToCreateRizzle(segue: UIStoryboardSegue) {
    }
}
