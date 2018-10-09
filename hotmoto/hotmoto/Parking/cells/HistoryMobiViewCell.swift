//
//  HistoryMobiViewCell.swift
//  MotoPark
//
//  Created by Huy on 10/5/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit

class HistoryMobiViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var imvOut: UIImageView!
    @IBOutlet weak var lblTimeIn: UILabel!
    @IBOutlet weak var lblTimeOut: UILabel!
    
    func setMobi(_ mobi: Mobile) {
        lblCode.text = mobi.code
       
        if let date = mobi.timein {
             lblTimeIn.text = "\(date.hour()):\(date.minute())"
        }else {
            lblTimeIn.text = nil
        }
        
        if let date = mobi.timeout {
            imvOut.isHidden = false
            lblTimeOut.text = "\(date.hour()):\(date.minute())"
        }else {
            lblTimeOut.text = nil
            imvOut.isHidden = true
        }
    }
}
