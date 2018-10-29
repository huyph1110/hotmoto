//
//  AttendanceCollectionViewCell.swift
//  MotoPark
//
//  Created by Huy on 9/26/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit

class AttendanceCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var lblTimein: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var imvImage: UIImageView!
}
