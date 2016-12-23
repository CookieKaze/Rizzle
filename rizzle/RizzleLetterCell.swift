//
//  RizzleLetterCell.swift
//  rizzle
//
//  Created by Matthew Mauro on 2016-12-16.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

import UIKit

class RizzleLetterCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(image:String){
        self.imageView.image = UIImage(named: "image")
    }
}
