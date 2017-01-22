//
//  CreateRizzleViewController.swift
//  rizzle
//
//  Created by Erin Luu on 2016-12-17.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

import UIKit
import Parse

class CreatesddsfRizzleViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate{
    //MARK: Properties
    var currentPageCount = 0
    var animationDuration = 0.3
    var rizzleToEdit: PFObject?
    
    
    //Form Views
    var titleViewPosition: CGRect?
    var questionViewPostion: CGRect?
    var answerViewPosition: CGRect?
    
    
    
    @IBOutlet weak var answerView: UIView!
    @IBOutlet weak var hintsView: UIView!
    
    //Form Fields
    var questionPlaceHolderLabel: UILabel?
    
    
    
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        answerViewPosition = answerView.frame
        
        if rizzleToEdit != nil {
            guard let rizzleToEdit = rizzleToEdit else {
                return
            }
            //Load rizzle fields
            
            //            hint1TextField.text = rizzleToEdit["hint1"] as? String
            //            hint1Label.isHidden = false
            //            hint2TextField.text = rizzleToEdit["hint2"] as? String
            //            hint2Label.isHidden = false
            //            hint3TextField.text = rizzleToEdit["hint3"] as? String
            //            hint3Label.isHidden = false
            //
            //            //Load difficulty level
            //            let diffLevel = rizzleToEdit["difficultyLevel"] as? Int
            //            if diffLevel != nil {
            //                difficultyLabel.text = "\(diffLevel!)"
            //                diffStepper.value = Double(diffLevel!)
            //            }
            
            //            //Load image
            //            let rizzleImageFile = rizzleToEdit["imageFile"] as? PFFile
            //            rizzleImageFile?.getDataInBackground(block: {(imageData, error) in
            //                if error == nil {
            //                    if let imageData = imageData {
            //                        let image = UIImage(data:imageData)
            //                        self.imageView.image = image
            //                        self.removeImageBtn.isHidden = false
            //                        self.removeImageBtn.isEnabled = true
            //                    }
            //                }
            //            })
        }
    }
    
    
    @IBAction func saveRizzle(_ sender: UIButton) {
        
        //            self.activityIndicator.startAnimating()
        //            let rizzle: PFObject!
        //
        //            if rizzleToEdit != nil {
        //                rizzle = rizzleToEdit!
        //            } else {
        //                rizzle = PFObject(className:"Rizzle")
        //            }
        //
        //            rizzle["user"] = PFUser.current()
        //            //rizzle["question"] = questionTextView.text
        //            //rizzle["answer"] = answerTextField.text
        //            rizzle["hint1"] = hint1TextField.text
        //            rizzle["hint2"] = hint2TextField.text
        //            rizzle["hint3"] = hint3TextField.text
        //            //rizzle["explanation"] = explanationTextView.text
        //            rizzle["difficultyLevel"] = Int(difficultyLabel.text!)
        
        //            if imageView.image != nil {
        //                //                if resizeWith(image: imageView.image!, width: 1024) != nil && (imageView.image?.size.width)! > CGFloat(1024) {
        //                guard let imageData = UIImageJPEGRepresentation(imageView.image!, 0.75) else {
        //                    print("Image cannot be converted to data. Image not stored.")
        //                    return
        //                }
        //                let imageFile = PFFile(name:"rizzleImage.jpeg", data:imageData)
        //                rizzle["imageFile"] = imageFile
        //                //                }
        //            } else {
        //                rizzle.remove(forKey:"imageFile")
        //            }
        
        //                rizzle.saveInBackground(block: { (success, error) in
        //                    self.activityIndicator.stopAnimating()
        //                    if error != nil {
        //                        print(error!)
        //                    }else {
        //                        print("Rizzle Saved")
        //                        self.dismiss(animated: true, completion: nil)
        //                    }
        //                })
    }
}










