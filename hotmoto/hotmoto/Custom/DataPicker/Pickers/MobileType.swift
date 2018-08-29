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

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if row == 0 {

            return attributeString(#imageLiteral(resourceName: "moto"), mobileType.all.0)
            
        }
        if row == 1 {

            return attributeString(#imageLiteral(resourceName: "moto"), mobileType.moto.0)

        }
        
        return attributeString(#imageLiteral(resourceName: "moto"), mobileType.oto.0)

    }
    func attributeString(_ icon: UIImage,_ string: String ) -> NSAttributedString? {
        
        let strAtribute = NSMutableAttributedString(string: "")
        let attach = NSTextAttachment()
        attach.image = icon
        attach.bounds = CGRect(x: 0, y: -5, width: 24, height: 24)
        
        strAtribute.append(NSAttributedString(attachment: attach))
        strAtribute.append(NSAttributedString(string:" " + string) )
        
        return strAtribute
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
