//
//  CreateRizzleViewController.swift
//  rizzle
//
//  Created by Erin Luu on 2016-12-17.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

import UIKit
struct Constants {
   static let animationDuration = 0.3
}

class CreateRizzleViewController: UIViewController {
    @IBOutlet weak var quesitonView: UIView!
    @IBOutlet weak var imageUploadView: UIView!
    @IBOutlet weak var answerView: UIView!
    @IBOutlet weak var hintsView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveRizzle(_ sender: UIBarButtonItem) {
    }
    

    //MARK: Form Transitions
    @IBAction func cancelBtnTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextBtnPressed(_ sender: UIBarButtonItem) {
        switch sender.tag {
        case 1:
            //Remove Question View
            removeViews(view: quesitonView)
            break
        case 2:
            //Remove Image View
            removeViews(view: imageUploadView)
            break
        case 3:
            //Remove Answer View
            removeViews(view: answerView)
            break
        default:
            break
        }
    }

    func removeViews(view: UIView) {
        UIView.animate(withDuration: Constants.animationDuration, delay: 0, options: .curveEaseIn, animations: {
        view.center = CGPoint(x: view.center.x + self.view.frame.width, y: self.view.center.y + 10)
        }, completion: {(success) in})
    }
    
    @IBAction func backBtnPressed(_ sender: UIBarButtonItem) {
        switch sender.tag {
        case 1:
            //Return Answer View
            restoreView(view: answerView)
            break
        case 2:
            //Restore Image Upload View
            restoreView(view: imageUploadView)
            break
        case 3:
            //Restore Question View
            restoreView(view: quesitonView)
            break
        default:
            break
        }
    }
    
    func restoreView(view: UIView) {
        UIView.animate(withDuration: Constants.animationDuration, delay: 0, options: .curveEaseIn, animations: {
            view.center = CGPoint(x: self.view.center.x, y: self.view.center.y + 10)
        }, completion: {(success) in})
    }
}
