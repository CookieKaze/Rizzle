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
    var createRizzleManager = CreateRizzleManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView.isHidden = true
        hint1Label.isHidden = true
        hint2Label.isHidden = true
        hint3Label.isHidden = true
        
        //Activity Indicator
        activityIndicator.stopAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Load field if value is not nil
        if createRizzleManager.hint1 != nil {
            hint1TextField.text = createRizzleManager.hint1
            hint1Label.isHidden = false
        }
        if createRizzleManager.hint2 != nil {
            hint2TextField.text = createRizzleManager.hint2
            hint2Label.isHidden = false
        }
        if createRizzleManager.hint3 != nil {
            hint3TextField.text = createRizzleManager.hint3
            hint3Label.isHidden = false
        }
        if createRizzleManager.difficulty != nil {
            difficultyLabel.text = "\(createRizzleManager.difficulty!)"
            diffStepper.value = Double(createRizzleManager.difficulty!)
        }
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
        }else {
            createRizzleManager.hint1 = hint1TextField.text
            createRizzleManager.hint2 = hint2TextField.text
            createRizzleManager.hint3 = hint3TextField.text
            createRizzleManager.difficulty = Int(diffStepper.value)
            //save
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        createRizzleManager.hint1 = hint1TextField.text
        createRizzleManager.hint2 = hint2TextField.text
        createRizzleManager.hint3 = hint3TextField.text
        createRizzleManager.difficulty = Int(diffStepper.value)
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
        label.frame = CGRect(origin: CGPoint(x: label.frame.origin.x, y: label.frame.origin.y + 20 ), size: label.frame.size)
        UIView.animate(withDuration: 0.5, animations: {
            label.frame = CGRect(origin: CGPoint(x: label.frame.origin.x, y: label.frame.origin.y - 20 ), size: label.frame.size)
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
