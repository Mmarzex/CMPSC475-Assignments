//
//  ParkTableHeaderCell.swift
//  ParkScroll
//
//  Created by Max Marze on 10/6/15.
//  Copyright © 2015 Max Marze. All rights reserved.
//

import UIKit

protocol ParkTableHeaderCellDelegate {
    func didSelectParkTableHeaderCell(selected: Bool, parkHeader: ParkTableHeaderCell)
}

class ParkTableHeaderCell: UITableViewCell {

    var delegate : ParkTableHeaderCellDelegate?
    
    @IBOutlet var headerButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func headButtonAction(sender: AnyObject) {
        delegate?.didSelectParkTableHeaderCell(true, parkHeader: self)
    }
}
