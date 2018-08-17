//
//  MobileType.swift
//  hotmoto
//
//  Created by Huy on 8/11/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit
enum mobileType {
    static let all = ("Tất cả",0)
    static let moto = ("xe máy",1)
    static let oto = ("ô tô",2)
    
}

class MobileType: GreenView,UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return mobileType.all.0
        }
        if row == 1 {
            return mobileType.moto.0
        }
        return mobileType.oto.0
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
     */
    @IBOutlet weak var picker: UIPickerView!
    override func initStyle() {
        picker.delegate = self
        picker.dataSource = self
        
    }
    func rollToValue(_ val: Int)  {
        
        picker.selectRow(val, inComponent: 0, animated: true)
    }
    func value() -> Int {
        return picker.selectedRow(inComponent: 0)
    }
}
