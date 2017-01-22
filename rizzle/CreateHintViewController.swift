//
//  CreateHintViewController.swift
//  rizzle
//
//  Created by Erin Luu on 2017-01-18.
//  Copyright © 2017 Erin Luu. All rights reserved.
//

import UIKit

class CreateHintViewController: UIViewController {
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var hint1Label: UILabel!
    @IBOutlet weak var hint1TextField: UITextField!
    @IBOutlet weak var hint2Label: UILabel!
    @IBOutlet weak var hint2TextField: UITextField!
    @IBOutlet weak var hint3Label: UILabel!
    @IBOutlet weak var hint3TextField: UITextField!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var diffStepper: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView.isHidden = true
        hint1Label.isHidden = true
        hint2Label.isHidden = true
        hint3Label.isHidden = true
        
        //Activity Indicator
        activityIndicator.stopAnimating()
    }
    
    func loadFields() {
        //Load title
        //        titleTextField.text = rizzleToEdit["title"] as? String
        //        titleLabel.isHidden = false
        
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        difficultyLabel.text = String(Int(sender.value))
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        hint1TextField.resignFirstResponder()
        hint2TextField.resignFirstResponder()
        hint3TextField.resignFirstResponder()
        //Check for blank text fields
        if hint1TextField.text == "" || hint2TextField.text == "" || hint3TextField.text == "" {
            let alertView = PopupAlertViewController(nibName: "PopupAlertViewController", bundle: nil)
            alertView.bodyText = "Please fill in all hint fields before saving."
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //Keyboard controls
    @IBAction func hintFieldChanged(_ sender: UITextField) {
        if sender.text != nil {
            if sender.text!.characters.count == 1 {
                switch sender.tag {
                case 1:
                    showHintLabel(label: hint1Label)
                    break
                case 2:
                    showHintLabel(label: hint2Label)
                    break
                case 3:
                    showHintLabel(label: hint3Label)
                    break
                default:
                    break
                }
            }
        }
    }
    
    func showHintLabel(label: UILabel) {
        label.isHidden = false
        label.center = CGPoint(x: self.hint1Label.center.x, y: label.center.y + 20)
        UIView.animate(withDuration: 0.5, animations: {
            label.center = CGPoint(x: label.center.x, y: label.center.y - 20)
        })
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        hint1TextField.resignFirstResponder()
        hint2TextField.resignFirstResponder()
        hint3TextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hint1TextField.resignFirstResponder()
        hint2TextField.resignFirstResponder()
        hint3TextField.resignFirstResponder()
        return true
    }
}
