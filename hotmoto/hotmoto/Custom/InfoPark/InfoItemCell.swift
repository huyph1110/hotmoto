//
//  InfoItemCell.swift
//  hotmoto
//
//  Created by Huy on 7/22/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit

class InfoItemCell: UICollectionViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imvIcon: UIImageView!
    @IBOutlet weak var content: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        content.layer.borderColor = UIColor("#454F63").cgColor
        content.layer.borderWidth = 1
    }

}
