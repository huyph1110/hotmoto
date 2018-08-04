//
//  ParkCell.swift
//  hotmoto
//
//  Created by Huy on 4/19/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit

class ParkCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var lblCost: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var imvAvatar: UIImageView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblName: UILabel!
}
