//
//  SizePicker.swift
//  hotmoto
//
//  Created by Huy on 8/13/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit

class SizePicker: GreenView, UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 101
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 100 {
            return "trên 100"
        }
        return "\(row + 1)"
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
        picker.dataSource = self
        picker.delegate = self

    }
    func rollToValue(_ value: Int)  {
        picker.selectRow(value - 1, inComponent: 0, animated: true)
    }
    
}
