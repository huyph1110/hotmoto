//
//  MIDateView.swift
//  ReBook
//
//  Created by Lê Dũng on 9/15/17.
//  Copyright © 2017 Ledung. All rights reserved.
//

import UIKit


protocol MIDateViewDelegate: class {
    func dateViewDidSelect()
}

class MIDateView: GreenView {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var btSelect: UIButton!
    @IBOutlet weak var dateView: UIView!
    var delegate : MIDateViewDelegate!
    
    
    override func initStyle() {
            
        dateView.backgroundColor = UIColor.white
        backgroundColor = UIColor.white

//        dateView.dropShadowInsec()
    }
    deinit {
        print("MIDateView deinit")
    }
    
    var date : Date
    {
        set{
            datePicker.date = date
        }
        get{
            return datePicker.date
        }
    }
    
    @IBAction func selected(_ sender: Any) {
        
        delegate.dateViewDidSelect()
    }

}
