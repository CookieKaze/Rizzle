//
//  ProfileUserTableViewCell.swift
//  rizzle
//
//  Created by Erin Luu on 2017-01-07.
//  Copyright © 2017 Erin Luu. All rights reserved.
//

import UIKit

class ProfileUserTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
