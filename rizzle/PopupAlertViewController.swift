//
//  PopupAlertViewController.swift
//  rizzle
//
//  Created by Erin Luu on 2017-01-10.
//  Copyright © 2017 Erin Luu. All rights reserved.
//

import UIKit

class PopupAlertViewController: UIViewController {
    
    var endPositionY: CGFloat?
    var headText: String?
    var bodyText: String?
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var iconOutterCircle: UIView!
    @IBOutlet weak var iconInnerCircle: UIView!
    @IBOutlet weak var alertHeadingLabel: UILabel!
    @IBOutlet weak var alertBodyLabel: UILabel!
    @IBOutlet weak var alertButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertBodyLabel.text = bodyText
        
        //Round Alert Icon
        iconOutterCircle.layer.cornerRadius = iconOutterCircle.frame.size.height/2
        iconInnerCircle.layer.cornerRadius = iconInnerCircle.frame.size.height/2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        endPositionY = mainView.frame.origin.y
        mainView.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        mainView.frame = CGRect(x: mainView.frame.origin.x, y: 0 - mainView.frame.size.height , width: mainView.frame.size.width, height: mainView.frame.size.height)
        self.mainView.isHidden = false
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 20, options: UIViewAnimationOptions.curveEaseIn, animations: {
            //Main view animate in
            
            self.mainView.frame = CGRect(x: self.mainView.frame.origin.x, y: self.endPositionY!, width: self.mainView.frame.size.width, height: self.mainView.frame.size.height)
        }) { (success) in
            //Main view animated successfully
        }
    }
    
    @IBAction func alertButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
