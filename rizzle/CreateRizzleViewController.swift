//
//  CreateRizzleViewController.swift
//  rizzle
//
//  Created by Erin Luu on 2016-12-17.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

import UIKit
import Parse

class CreateRizzleViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    //MARK: Properties
    var currentPageCount = 0
    var animationDuration = 0.3
    var rizzleToEdit: PFObject?
    var imageChanged: Bool = false
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //Form Views
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var imageUploadView: UIView!
    @IBOutlet weak var answerView: UIView!
    @IBOutlet weak var hintsView: UIView!
    @IBOutlet weak var removeImageBtn: UIButton!
    
    //Form Fields
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var explanationTextView: UITextView!
    @IBOutlet weak var hint1TextField: UITextField!
    @IBOutlet weak var hint2TextField: UITextField!
    @IBOutlet weak var hint3TextField: UITextField!
    @IBOutlet weak var difficultyLabel: UILabel!
    
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.stopAnimating()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.center = view.center
        removeImageBtn.isHidden = true
        removeImageBtn.isEnabled = false
        
        if rizzleToEdit != nil {
            guard let rizzleToEdit = rizzleToEdit else {
                return
            }
            titleTextField.text = rizzleToEdit["title"] as? String
            questionTextView.text = rizzleToEdit["question"] as? String
            answerTextField.text = rizzleToEdit["answer"] as? String
            explanationTextView.text = rizzleToEdit["explanation"] as? String
            hint1TextField.text = rizzleToEdit["hint1"] as? String
            hint2TextField.text = rizzleToEdit["hint2"] as? String
            hint3TextField.text = rizzleToEdit["hint3"] as? String
            difficultyLabel.text = rizzleToEdit["difficultyLevel"] as? String
            
            
            let rizzleImageFile = rizzleToEdit["imageFile"] as? PFFile
            rizzleImageFile?.getDataInBackground(block: {(imageData, error) in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data:imageData)
                        self.imageView.image = image
                        self.removeImageBtn.isHidden = false
                        self.removeImageBtn.isEnabled = true
                    }
                }
            })
        }
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
        if checkValidField() {
            self.activityIndicator.startAnimating()
            let rizzle: PFObject!
            
            if rizzleToEdit != nil {
                rizzle = rizzleToEdit!
            } else {
                rizzle = PFObject(className:"Rizzle")
            }
            
            rizzle["user"] = PFUser.current()
            rizzle["title"] = titleTextField.text
            rizzle["question"] = questionTextView.text
            rizzle["answer"] = answerTextField.text
            rizzle["hint1"] = hint1TextField.text
            rizzle["hint2"] = hint2TextField.text
            rizzle["hint3"] = hint3TextField.text
            rizzle["explanation"] = explanationTextView.text
            rizzle["difficultyLevel"] = Int(difficultyLabel.text!)
            
            if imageView.image != nil {
                guard let imageData = UIImageJPEGRepresentation(imageView.image!, 0.75) else {
                    print("Image cannot be converted to data. Image not stored.")
                    return
                }
                let imageFile = PFFile(name:"rizzleImage.jpeg", data:imageData)
                rizzle["imageFile"] = imageFile
            } else {
                rizzle.remove(forKey:"imageFile")
            }
            
            rizzle.saveInBackground(block: { (success, error) in
                self.activityIndicator.stopAnimating()
                if error != nil {
                    print(error!)
                }else {
                    print("Rizzle Saved")
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    
    func checkValidField() -> Bool {
        var shouldSave = false
        if hint1TextField.text == "" || hint2TextField.text == "" || hint3TextField.text == "" {
            showAlert(message: "The hint fields cannot be blank.")
            return shouldSave
        }else if answerTextField.text == "" || explanationTextView.text == "" {
            showAlert(message: "The answer fields cannot be blank.")
            restoreView(view: answerView)
            return shouldSave
        } else if questionTextView.text == "" {
            showAlert(message: "The question field cannot be blank.")
            restoreView(view: answerView)
            restoreView(view: imageUploadView)
            restoreView(view: questionView)
            return shouldSave
        }else {
            shouldSave = true
        }
        return shouldSave
    }
    
    func showAlert (message: String) {
        let alertView = UIAlertController(title: "Oh no!", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Okay", style: .default, handler: {(action)in
        })
        
        alertView.addAction(defaultAction)
        present(alertView, animated: true, completion: nil)
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        difficultyLabel.text = String(Int(sender.value))
    }
    
    //MARK: Image Upload
    @IBAction func imageUploadTapped(_ sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        guard let image = pickedImage else {
            print ("Cannot get image")
            return
        }
        imageView.image = image
        removeImageBtn.isHidden = false
        removeImageBtn.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func removeImageBtnTapped(_ sender: UIButton) {
        imageView.image = nil
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
        explanationTextView.resignFirstResponder()
        hint1TextField.resignFirstResponder()
        hint2TextField.resignFirstResponder()
        hint3TextField.resignFirstResponder()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
