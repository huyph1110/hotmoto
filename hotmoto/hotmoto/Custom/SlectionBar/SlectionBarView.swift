//
//  SlectionBarView.swift
//  hotmoto
//
//  Created by Huy on 8/5/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit

class SlectionBarView: GreenView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var text: UITextField!
    
    @IBOutlet weak var btnSelect: UIButton!
    func setIcon(_ image: UIImage?) {
        icon.image = image
    }
    func setText(_ text: String?) {
        self.text.text = text
    }
    func setPlaceHolder(_ text: String?) {
        self.text.placeholder = text
    }
    
    override func initStyle() {
        self.text.text = nil
        btnSelect.layer.cornerRadius = 8
        self.layer.cornerRadius = 8
        self.layer.shadowRadius = 8
        self.layer.shadowOpacity = 1
        self.layer.shadowColor = UIColor.init(white: 0, alpha: 0.08).cgColor
    }
}
