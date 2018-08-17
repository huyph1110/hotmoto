//
//  CostPicker.swift
//  hotmoto
//
//  Created by Huy on 8/8/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit

enum CostTime {
    static let perhour = ("1h",1)
    static let per3hour = ("3h",3)
    static let per6hour = ("6h",6)
    static let perDay = ("24h",24)

}


class CostPicker: GreenView, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == ValuePicker {
            return 10
        }
        return 4
    }
    var range = 5000
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == ValuePicker {
            let value = money(range * row)
            return "\(value) đồng"
        }
        if row == 0 {
            return CostTime.perhour.0
        }
        if row == 1 {
            return CostTime.per3hour.0
        }
        if row == 2 {
            return CostTime.per6hour.0
        }
        if row == 3 {
            return CostTime.perDay.0
        }

        return  nil
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == ValuePicker {
            value = range * row
        }else {
            if row == 0 {
                costtime = CostTime.perhour
            }
            if row == 1 {
                costtime = CostTime.per3hour
            }
            if row == 2 {
                costtime = CostTime.per6hour
            }
            if row == 3 {
                costtime = CostTime.perDay
            }
        }
    }
    
    var costtime = CostTime.perhour
    var value = 5000
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var ValuePicker: UIPickerView!
    @IBOutlet weak var hourPicker: UIPickerView!
    func values() -> [Int] {
        return [value, costtime.1]
    }
    func valueToIndex(value: Int) -> Int {
        if value == 1 {
            return 0
        }
        if value == 3 {
            return 1
        }
        if value == 6 {
            return 2
        }
        if value == 24 {
            return 3
        }
        return 0

    }
    override func initStyle() {
        ValuePicker.dataSource = self
        ValuePicker.delegate = self
        hourPicker.dataSource = self
        hourPicker.delegate = self
        
     
    }
    func rollToValue()  {
        let index = Int(value/range)
        ValuePicker.selectRow(index, inComponent: 0, animated: true)
        let costIndex = valueToIndex(value: costtime.1)
        hourPicker.selectRow(costIndex, inComponent: 0, animated: true)
    }
}
