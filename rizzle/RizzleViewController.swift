//
//  RizzleViewController.swift
//  rizzle
//
//  Created by Matthew Mauro on 2016-12-17.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

import UIKit

class RizzleViewController: UIViewController {

    @IBOutlet weak var rizzleTitle: UILabel!
    @IBOutlet weak var rizzleDescription: UITextView!
    @IBOutlet weak var hintsRemainingLabel: UILabel!
    
    @IBOutlet weak var bank: letterBank!
    var currentRizzle:Rizzle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting my currentRizzle to the dummy I made in the letterBank class. 
        // in actuality, we'll set the current rizzle in a segue
        
        self.currentRizzle = self.bank.dummyRizzle
        
        self.rizzleTitle.text = self.currentRizzle?.title
        self.rizzleDescription.text = self.currentRizzle?.question
        
        
    }

}
