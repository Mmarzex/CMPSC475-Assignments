//
//  ParkTableViewCell.swift
//  ParkScroll
//
//  Created by Max Marze on 10/6/15.
//  Copyright © 2015 Max Marze. All rights reserved.
//

import UIKit

class ParkTableViewCell: UITableViewCell {

    @IBOutlet var parkCellImage: UIImageView!
    @IBOutlet var parkCellCaption: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
