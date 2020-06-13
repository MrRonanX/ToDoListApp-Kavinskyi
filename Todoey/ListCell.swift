//
//  ListCell.swift
//  Todoey
//
//  Created by Roman Kavinskyi on 01.03.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {

    @IBOutlet weak var checkMark: UIImageView!
    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
