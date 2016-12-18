//
//  CreateRizzleViewController.swift
//  rizzle
//
//  Created by Erin Luu on 2016-12-17.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

import UIKit

class CreateRizzleViewController: UIViewController, UITextFieldDelegate {
    //MARK: Properties
    var currentPageCount = 0
    var animationDuration = 0.3
    
    
    //Form Views
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var imageUploadView: UIView!
    @IBOutlet weak var answerView: UIView!
    @IBOutlet weak var hintsView: UIView!
    
    //Form Fields
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var hint1TextField: UITextField!
    @IBOutlet weak var hint2TextField: UITextField!
    @IBOutlet weak var hint3TextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        let lastPageCount = currentPageCount
        currentPageCount = 0
        animationDuration = 0
        switch lastPageCount {
        case 1:
            removeViews(view: questionView)
            break
        case 2:
            removeViews(view: questionView)
            removeViews(view: imageUploadView)
            break
        case 3:
            removeViews(view: questionView)
            removeViews(view: imageUploadView)
            removeViews(view: answerView)
            break
        default:
            break
        }
        animationDuration = 0.3
    }
    
    @IBAction func saveRizzle(_ sender: UIBarButtonItem) {
        print("saved")
        checkValidField()
    }
    
    func checkValidField() {
        if hint1TextField.text == "" || hint2TextField.text == "" || hint3TextField.text == "" {
            print("Hints cannot be blank")
            return
        }
        if answerTextField.text == "" {
            print("Answer field cannot be blank")
            restoreView(view: answerView)
            return
        }
        if questionTextView.text == "" {
            print("Question field cannot be blank")
            restoreView(view: answerView)
            restoreView(view: imageUploadView)
            restoreView(view: questionView)
            return
        } 
    }
    
    //MARK: Form Transitions
    @IBAction func cancelBtnTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextBtnPressed(_ sender: UIBarButtonItem) {
        switch sender.tag {
        case 1:
            //Remove Question View
            questionTextView.resignFirstResponder()
            removeViews(view: questionView)
            break
        case 2:
            //Remove Image View
            removeViews(view: imageUploadView)
            break
        case 3:
            //Remove Answer View
            answerTextField.resignFirstResponder()
            removeViews(view: answerView)
            break
        default:
            break
        }
    }
    
    func removeViews(view: UIView) {
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseIn, animations: {
            view.center = CGPoint(x: view.center.x - self.view.frame.width, y: self.view.center.y + 10)
        }, completion: {(success) in
            view.center = CGPoint(x: view.center.x - self.view.frame.width, y: self.view.center.y + 10)
        })
        currentPageCount += 1
    }
    
    @IBAction func backBtnPressed(_ sender: UIBarButtonItem) {
        switch sender.tag {
        case 1:
            //Return Answer View
            restoreView(view: answerView)
            hint3TextField.resignFirstResponder()
            hint2TextField.resignFirstResponder()
            hint1TextField.resignFirstResponder()
            break
        case 2:
            //Restore Image Upload View
            restoreView(view: imageUploadView)
            answerTextField.resignFirstResponder()
            
            break
        case 3:
            //Restore Question View
            restoreView(view: questionView)
            break
        default:
            break
        }
    }
    
    func restoreView(view: UIView) {
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseIn, animations: {
            view.center = CGPoint(x: self.view.center.x, y: self.view.center.y + 10)
        }, completion: {(success) in
            view.center = CGPoint(x: self.view.center.x, y: self.view.center.y + 10)
        })
        currentPageCount -= 1
    }
    
    //MARK: Keyboard Resign
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        questionTextView.resignFirstResponder()
        answerTextField.resignFirstResponder()
        hint1TextField.resignFirstResponder()
        hint2TextField.resignFirstResponder()
        hint3TextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
