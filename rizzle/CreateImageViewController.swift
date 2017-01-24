//
//  CreateImageViewController.swift
//  rizzle
//
//  Created by Erin Luu on 2017-01-18.
//  Copyright © 2017 Erin Luu. All rights reserved.
//

import UIKit

class CreateImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    @IBOutlet weak var imageUploadView: UIView!
    @IBOutlet weak var removeImageBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var imageChanged: Bool = false
    var createRizzleManager = CreateRizzleManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Remove Image Btn
        removeImageBtn.isHidden = true
        removeImageBtn.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Load field if value is not nil
        if createRizzleManager.image != nil {
            imageView.image = createRizzleManager.image
            removeImageBtn.isHidden = false
            removeImageBtn.isEnabled = true
        }
    }
    func loadImage() {
        //        //Load image
        //        let rizzleImageFile = rizzleToEdit["imageFile"] as? PFFile
        //        rizzleImageFile?.getDataInBackground(block: {(imageData, error) in
        //            if error == nil {
        //                if let imageData = imageData {
        //                    let image = UIImage(data:imageData)
        //                    self.imageView.image = image
        //                    self.removeImageBtn.isHidden = false
        //                    self.removeImageBtn.isEnabled = true
        //                }
        //            }
        //        })
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
    
    //Navigation
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if imageView.image != nil {
            createRizzleManager.image = imageView.image!
        }
        performSegue(withIdentifier: "toWordAnswerView", sender: nil)
        
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        if imageView.image != nil {
            createRizzleManager.image = imageView.image!
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
}
