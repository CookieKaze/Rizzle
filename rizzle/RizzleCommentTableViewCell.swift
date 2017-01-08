//
//  RizzleCommentTableViewCell.swift
//  rizzle
//
//  Created by Erin Luu on 2017-01-08.
//  Copyright © 2017 Erin Luu. All rights reserved.
//

import UIKit

class RizzleCommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
