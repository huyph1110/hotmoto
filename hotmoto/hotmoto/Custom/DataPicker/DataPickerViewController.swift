//
//  DataPickerViewController.swift
//  hotmoto
//
//  Created by Huy on 8/8/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit

enum pickerType {
    case cost
    case type
    case time
    case size
}

class DataPickerViewController: UIViewController {

    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var lblGuild: UILabel!
    @IBOutlet weak var viewPicker: UIView!
    var completeHandler: (([Int]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if type == pickerType.cost {
            let view = CostPicker()
            view.frame = viewPicker.bounds
            view.value = values[0]
            view.costtime = costTimeFromValue(value: values[1])
            view.rollToValue()
            viewPicker.addSubview(view)
            lblGuild.text = "Giá tiền và thời gian tối đa cho mỗi lần gửi"
        }
        
        if type == pickerType.type {
            let view = MobileType()
            view.frame = viewPicker.bounds
            view.rollToValue(values[0])
            viewPicker.addSubview(view)
            lblGuild.text = "Giới hạn loại xe được gửi"
        }
        if type == pickerType.time {
            let view = TimePicker()
            view.frame = viewPicker.bounds
            view.rollToValue(values[0],values[1])
            viewPicker.addSubview(view)
            lblGuild.text = "Giờ bắt đầu và kết thúc giữ xe trong ngày"
        }
        if type == pickerType.size {
            let view = SizePicker()
            view.frame = viewPicker.bounds
            view.rollToValue(values[0])
            viewPicker.addSubview(view)
            lblGuild.text = "Số lượng xe có thể chứa"
        }

    }
    @IBAction func done(_ sender: Any) {
        
        if type == pickerType.cost {
            let view = viewPicker.subviews[0] as! CostPicker
            completeHandler?(view.values())
        }
        if type == pickerType.type {
            let view = viewPicker.subviews[0] as! MobileType
            completeHandler?([view.value()])
        }
        if type == pickerType.time {
            let view = viewPicker.subviews[0] as! TimePicker
            let dateBegin = view.startPicker.date
            let beginValue = dateBegin.hour() * 60 + dateBegin.minute()
            
            let dateEnd = view.endPicker.date
            let endValue = dateEnd.hour() * 60 + dateEnd.minute()

            completeHandler?([beginValue,endValue])
        }
        if type == pickerType.time {
            let view = viewPicker.subviews[0] as!  SizePicker
            completeHandler?([view.picker.selectedRow(inComponent: 0) + 1])

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var type = pickerType.cost
    var values: [Int] = [0,0]
    func costTimeFromValue(value: Int) -> (String,Int) {
        
        if value == 3 {
            return CostTime.per3hour
        }
        if value == 6 {
            return CostTime.per6hour
        }
        if value == 24 {
            return CostTime.perDay
        }
        return CostTime.perhour

    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
