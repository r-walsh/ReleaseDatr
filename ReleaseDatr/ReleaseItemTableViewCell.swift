//
//  ReleaseItemTableViewCell.swift
//  ReleaseDatr
//
//  Created by Ryan Walsh on 7/25/16.
//  Copyright © 2016 Ryan Walsh. All rights reserved.
//

import UIKit

class ReleaseItemTableViewCell: UITableViewCell {

    @IBOutlet weak var releaseItemNameLabel: UILabel!
    @IBOutlet weak var releaseItemDateLabel: UILabel!
    @IBOutlet weak var releaseItemConfirmedImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
