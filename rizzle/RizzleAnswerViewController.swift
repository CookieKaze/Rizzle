//
//  RizzleAnswerViewController.swift
//  rizzle
//
//  Created by Erin Luu on 2016-12-21.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

import UIKit

class RizzleAnswerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    //MARK: Properties
    var answerCellView: UIView?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK: Collection View Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RizzleAnswerCollectionViewCell
        cell.backgroundColor = .red
        
        return cell
    }


}
