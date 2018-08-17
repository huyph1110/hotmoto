//
//  TimePicker.swift
//  hotmoto
//
//  Created by Huy on 8/13/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit

class TimePicker: GreenView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBOutlet weak var endPicker: UIDatePicker!
    @IBOutlet weak var startPicker: UIDatePicker!
    
    override func initStyle() {
        
    }
    func rollToValue(_ begin: Int, _ end: Int)  {
        let beginHour = begin/60
        let beginMin = begin % 60
        let endHour = end/60
        let endMin = begin % 60
        
        let dateBegin = Calendar.current.date(bySettingHour: beginHour, minute: beginMin, second: 0, of: Date())
        let dateEnd = Calendar.current.date(bySettingHour: endHour, minute: endMin, second: 0, of: Date())
        
        startPicker.setDate(dateBegin!, animated: true)
        endPicker.setDate(dateEnd!, animated: true)


    }

}
