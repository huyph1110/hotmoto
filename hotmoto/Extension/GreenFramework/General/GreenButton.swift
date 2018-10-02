//
//  GreenButton.swift
//  GFramework
//
//  Created by KieuVan on 2/14/17.
//  Copyright © 2017 KieuVan. All rights reserved.
//

import UIKit

 class GreenButton: UIButton
{
    func initStyle()
    {
        self.backgroundColor = ColorsConfig.button_green
        self.layer.cornerRadius = 5
        self.setTitleColor(UIColor.white, for: .normal)
    }
    
    override  func awakeFromNib() {
        initStyle()
    }
}
