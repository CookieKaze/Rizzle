//
//  MyRizzleTableViewCell.swift
//  rizzle
//
//  Created by Erin Luu on 2017-01-10.
//  Copyright © 2017 Erin Luu. All rights reserved.
//

import UIKit

class MyRizzleTableViewCell: UITableViewCell {

    @IBOutlet weak var rizzleDateLabel: UILabel!
    @IBOutlet weak var rizzleTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
