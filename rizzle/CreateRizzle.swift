//
//  CreateRizzleViewController.swift
//  rizzle
//
//  Created by Erin Luu on 2016-12-17.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

import UIKit
import Parse

class CreatesddsfRizzleViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    //MARK: Properties
    var currentPageCount = 0
    var animationDuration = 0.3
    var rizzleToEdit: PFObject?
    var imageChanged: Bool = false
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //Form Views
    var titleViewPosition: CGRect?
    var questionViewPostion: CGRect?
    var answerViewPosition: CGRect?
    
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var imageUploadView: UIView!
    @IBOutlet weak var answerView: UIView!
    @IBOutlet weak var hintsView: UIView!
    @IBOutlet weak var removeImageBtn: UIButton!
    
    //Form Fields
    var questionPlaceHolderLabel: UILabel?
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var answerTextField: UITextField!
    var explanationPlaceHolderLabel: UILabel?
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var explanationTextView: UITextView!
    @IBOutlet weak var hint1Label: UILabel!
    @IBOutlet weak var hint1TextField: UITextField!
    @IBOutlet weak var hint2Label: UILabel!
    @IBOutlet weak var hint2TextField: UITextField!
    @IBOutlet weak var hint3Label: UILabel!
    @IBOutlet weak var hint3TextField: UITextField!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var diffStepper: UIStepper!
    
    //Buttons
    var titlePosition: CGRect?
    var questionBackPosition: CGRect?
    var questionNextPosition: CGRect?
    var answerBackPosition: CGRect?
    var answerNextPosition: CGRect?
    @IBOutlet weak var titleNextButton: UIButton!
    @IBOutlet weak var questionBackButton: UIButton!
    @IBOutlet weak var questionNextButton: UIButton!
    @IBOutlet weak var answerBackButton: UIButton!
    @IBOutlet weak var answerNextButton: UIButton!
    
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Listen for keyboard appearances and disappearances
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(sender:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(sender:)), name: .UIKeyboardWillHide, object: nil)
        
        //Form Labels
        
        questionLabel.isHidden = true
        answerLabel.isHidden = true
        hint1Label.isHidden = true
        hint2Label.isHidden = true
        hint3Label.isHidden = true
        
        //Place Holders
        questionPlaceHolderLabel = UILabel.init()
        guard let placeholderLabel = questionPlaceHolderLabel else {
            return
        }
        placeholderLabel.text = "Start typing your rizzle question here…"
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (questionTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        questionTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (questionTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !questionTextView.text.isEmpty
        
        explanationPlaceHolderLabel = UILabel.init()
        guard let placeholderLabel2 = explanationPlaceHolderLabel else {
            return
        }
        placeholderLabel2.text = "What are the steps you took to get the answer? Explainations will be shown at the end of a Rizzle once it has been completed."
        placeholderLabel2.font = UIFont.italicSystemFont(ofSize: (explanationTextView.font?.pointSize)!)
        placeholderLabel2.sizeToFit()
        explanationTextView.addSubview(placeholderLabel2)
        placeholderLabel2.frame.origin = CGPoint(x: 5, y: (explanationTextView.font?.pointSize)! / 2)
        placeholderLabel2.textColor = UIColor.lightGray
        placeholderLabel2.isHidden = !explanationTextView.text.isEmpty
        
        //Activity Indicator
        activityIndicator.stopAnimating()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.center = view.center
        
        //Remove Image Btn
        removeImageBtn.isHidden = true
        removeImageBtn.isEnabled = false
        
        //Setup but positions
        titlePosition = titleNextButton.frame
        questionBackPosition = questionBackButton.frame
        questionNextPosition = questionNextButton.frame
        answerBackPosition = answerBackButton.frame
        answerNextPosition = answerNextButton.frame
        
        
        questionViewPostion = questionView.frame
        answerViewPosition = answerView.frame
        
        if rizzleToEdit != nil {
            guard let rizzleToEdit = rizzleToEdit else {
                return
            }
            //Load rizzle fields
            
            questionTextView.text = rizzleToEdit["question"] as? String
            questionPlaceHolderLabel?.isHidden = true
            questionLabel.isHidden = false
            answerTextField.text = rizzleToEdit["answer"] as? String
            explanationTextView.text = rizzleToEdit["explanation"] as? String
            explanationPlaceHolderLabel?.isHidden = true
            hint1TextField.text = rizzleToEdit["hint1"] as? String
            hint1Label.isHidden = false
            hint2TextField.text = rizzleToEdit["hint2"] as? String
            hint2Label.isHidden = false
            hint3TextField.text = rizzleToEdit["hint3"] as? String
            hint3Label.isHidden = false
            
            //Load difficulty level
            let diffLevel = rizzleToEdit["difficultyLevel"] as? Int
            if diffLevel != nil {
                difficultyLabel.text = "\(diffLevel!)"
                diffStepper.value = Double(diffLevel!)
            }
            
            //Load image
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
           
            break
        case 2:
           
            removeViews(view: questionView)
            break
        case 3:
           
            removeViews(view: questionView)
            removeViews(view: imageUploadView)
            break
        case 4:
           
            removeViews(view: questionView)
            removeViews(view: imageUploadView)
            removeViews(view: answerView)
            break
        default:
            break
        }
        animationDuration = 0.3
    }
    
    @IBAction func saveRizzle(_ sender: UIButton) {
        if checkValidField() {
            self.activityIndicator.startAnimating()
            let rizzle: PFObject!
            
            if rizzleToEdit != nil {
                rizzle = rizzleToEdit!
            } else {
                rizzle = PFObject(className:"Rizzle")
            }
            
            rizzle["user"] = PFUser.current()
            rizzle["question"] = questionTextView.text
            rizzle["answer"] = answerTextField.text
            rizzle["hint1"] = hint1TextField.text
            rizzle["hint2"] = hint2TextField.text
            rizzle["hint3"] = hint3TextField.text
            rizzle["explanation"] = explanationTextView.text
            rizzle["difficultyLevel"] = Int(difficultyLabel.text!)
            
            if imageView.image != nil {
                //                if resizeWith(image: imageView.image!, width: 1024) != nil && (imageView.image?.size.width)! > CGFloat(1024) {
                guard let imageData = UIImageJPEGRepresentation(imageView.image!, 0.75) else {
                    print("Image cannot be converted to data. Image not stored.")
                    return
                }
                let imageFile = PFFile(name:"rizzleImage.jpeg", data:imageData)
                rizzle["imageFile"] = imageFile
                //                }
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
            showAlert(message: "Hint fields cannot be blank.")
            return shouldSave
        }else if answerTextField.text == "" || explanationTextView.text == "" {
            showAlert(message: "Answer and explanation fields cannot be blank.")
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
        let alertView = PopupAlertViewController(nibName: "PopupAlertViewController", bundle: nil)
        alertView.bodyText = message
        self.present(alertView, animated: false, completion: nil)
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
    
    func resizeWith(image: UIImage, width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/image.size.width * image.size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, image.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
    //MARK: Form Transitions
    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextBtnPressed(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            //Remove title View
            break
        case 2:
            //Remove Question View
            questionTextView.resignFirstResponder()
            removeViews(view: questionView)
            break
        case 3:
            //Remove Image View
            removeViews(view: imageUploadView)
            break
        case 4:
            //Remove Answer View
            answerTextField.resignFirstResponder()
            explanationTextView.resignFirstResponder()
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
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        switch sender.tag {
        case 2:
            //Restore Title View
            questionTextView.resignFirstResponder()
            
            break
        case 3:
            //Restore Question View
            restoreView(view: questionView)
            break
        case 4:
            //Restore Image Upload View
            answerTextField.resignFirstResponder()
            explanationTextView.resignFirstResponder()
            restoreView(view: imageUploadView)
            break
        case 5:
            //Return Answer View
            restoreView(view: answerView)
            hint3TextField.resignFirstResponder()
            hint2TextField.resignFirstResponder()
            hint1TextField.resignFirstResponder()
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
    
    //MARK: Keyboard controls
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        if sender.text != nil {
            if sender.tag == 1 && sender.text!.characters.count == 1 {
               
            }else if sender.tag == 2 && sender.text!.characters.count == 1 {
                moveTextFieldLabel(label: answerLabel)
            }else if sender.tag == 3 && sender.text!.characters.count == 1 {
                moveTextFieldLabel(label: hint1Label)
            }else if sender.tag == 4 && sender.text!.characters.count == 1 {
                moveTextFieldLabel(label: hint2Label)
            }else if sender.tag == 5 && sender.text!.characters.count == 1 {
                moveTextFieldLabel(label: hint3Label)
            }
        }
    }
    
    func moveTextFieldLabel (label: UILabel) {
        label.frame = CGRect(x: label.frame.origin.x, y: label.frame.origin.y + 20, width: label.frame.size.width, height: label.frame.size.height)
        label.isHidden = false
        
        UIView.animate(withDuration: 0.5, animations: {
            label.frame = CGRect(x: label.frame.origin.x, y: label.frame.origin.y - 20, width: label.frame.size.width, height: label.frame.size.height)
        })
    }
    
    func textViewDidChange(_ textView: UITextView) {
        questionPlaceHolderLabel?.isHidden = !textView.text.isEmpty
        explanationPlaceHolderLabel?.isHidden = !textView.text.isEmpty
        if textView.text != nil {
            if textView.text!.characters.count == 1 {
                questionLabel.frame = CGRect(x: questionLabel.frame.origin.x, y: questionLabel.frame.origin.y + 20, width: questionLabel.frame.size.width, height: questionLabel.frame.size.height)
                questionLabel.isHidden = false
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.questionLabel.frame = CGRect(x: self.questionLabel.frame.origin.x, y: self.questionLabel.frame.origin.y - 20, width: self.questionLabel.frame.size.width, height: self.questionLabel.frame.size.height)
                })
            }
        }
    }
    
    func keyboardWillAppear(sender: NSNotification) {
        let userInfo = sender.userInfo!
        if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            
            switch currentPageCount {
            
            case 1:
                questionBackButton.frame = questionBackPosition!
                questionNextButton.frame = questionNextPosition!
                questionView.frame = questionViewPostion!
                //Question
                self.questionView.frame = CGRect(x: self.questionViewPostion!.origin.x, y: self.questionViewPostion!.origin.y - 100, width: self.questionViewPostion!.width, height: self.questionViewPostion!.height)
                self.questionBackButton.frame = CGRect(x: self.questionBackPosition!.origin.x, y: self.questionBackPosition!.origin.y - keyboardHeight/2, width: self.questionBackPosition!.width, height: self.questionBackButton.frame.height)
                self.questionNextButton.frame = CGRect(x: self.questionNextPosition!.origin.x, y: self.questionNextPosition!.origin.y - keyboardHeight/2, width: self.questionNextPosition!.width, height: self.questionNextPosition!.height)
                break
            case 3:
                answerBackButton.frame = answerBackPosition!
                answerNextButton.frame = answerNextPosition!
                answerView.frame = answerViewPosition!
                //Answer
                self.answerView.frame = CGRect(x: self.answerViewPosition!.origin.x, y: self.answerViewPosition!.origin.y - 100, width: self.answerViewPosition!.width, height: self.answerViewPosition!.height)
                self.answerBackButton.frame = CGRect(x: self.answerBackPosition!.origin.x, y: self.answerBackPosition!.origin.y - keyboardHeight/2, width: self.answerBackPosition!.width, height: self.answerBackPosition!.height)
                self.answerNextButton.frame = CGRect(x: self.answerNextPosition!.origin.x, y: self.answerNextPosition!.origin.y - keyboardHeight/2, width: self.answerNextPosition!.width, height: self.answerNextPosition!.height)
                break
            default:
                break
            }
        }
    }
    
    func keyboardWillDisappear(sender: NSNotification) {
        let userInfo = sender.userInfo!
        if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            
            switch currentPageCount {
                        case 1:
                //Question
                self.questionView.frame = CGRect(x: self.questionView.frame.origin.x, y: self.questionView.frame.origin.y + 100, width: self.questionView.frame.width, height: self.questionView.frame.height)
                self.questionBackButton.frame = CGRect(x: self.questionBackButton.frame.origin.x, y: self.questionBackButton.frame.origin.y + keyboardHeight/2, width: self.questionBackButton.frame.width, height: self.questionBackButton.frame.height)
                self.questionNextButton.frame = CGRect(x: self.questionNextButton.frame.origin.x, y: self.questionNextButton.frame.origin.y + keyboardHeight/2, width: self.questionNextButton.frame.width, height: self.questionNextButton.frame.height)
                break
            case 3:
                //Answer
                self.answerView.frame = CGRect(x: self.answerView.frame.origin.x, y: self.answerView.frame.origin.y + 100, width: self.answerView.frame.width, height: self.answerView.frame.height)
                self.answerBackButton.frame = CGRect(x: self.answerBackButton.frame.origin.x, y: self.answerBackButton.frame.origin.y + keyboardHeight/2, width: self.answerBackButton.frame.width, height: self.answerBackButton.frame.height)
                self.answerNextButton.frame = CGRect(x: self.answerNextButton.frame.origin.x, y: self.answerNextButton.frame.origin.y + keyboardHeight/2, width: self.answerNextButton.frame.width, height: self.answerNextButton.frame.height)
                break
            default:
                break
            }
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        resignAllTextFields()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func resignAllTextFields() {
        
        questionTextView.resignFirstResponder()
        answerTextField.resignFirstResponder()
        explanationTextView.resignFirstResponder()
        hint1TextField.resignFirstResponder()
        hint2TextField.resignFirstResponder()
        hint3TextField.resignFirstResponder()
    }
}
