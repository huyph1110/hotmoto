//
//  EditMobiViewController.swift
//  MotoPark
//
//  Created by Huy on 10/1/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit

class EditMobiViewController: UIViewController {
    var mobi : Mobile?
    var park : Park?

    var saveComplete: (() -> Void)?
    var delComplete: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        if mobi != nil && park != nil{
            loadMobi(mobi!, park!)
        }
        // Do any additional setup after loading the view.
        
    }
    @IBOutlet weak var lblCost: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var lblTimeIn: UILabel!
    @IBOutlet weak var txfCode: UITextField!
    
    @IBAction func release(_ sender: Any) {
        self.showConfirm(title: "Xác nhận trả xe?", detail: "") { (ok) in
            if ok {
                self.mobi?.state = Mobi_State.checkout.rawValue
                self.mobi?.timeout = Date()
                self.mobi?.save()
                self.delComplete?()
            }
        }
    }
    
    @IBAction func save(_ sender: Any) {
        if valid() {
            mobi?.code  = txfCode.text
            mobi?.save()
            saveComplete?()
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss()
    }
    func loadMobi(_ mobi: Mobile, _ park: Park) {
        imageView.image = UIImage(data: mobi.image!)
        txfCode.text = mobi.code
        lblTime.text = stringDurationTimeParking(mobi)
        lblCost.text = stringCostParking(mobi, park)
        if let date = mobi.timein {
            if date.isEqual(to: Date()) == false {
                lblTimeIn.text = nil
                let day = "(\(date.day())/\(date.month()))"
                let hour =  "\(date.hour()):\(date.minute())"
                lblTimeIn.addAttributeText(text: hour, font: lblTimeIn.font, color: lblTimeIn.textColor)
                lblTimeIn.addAttributeText(text: day, font: lblTimeIn.font, color: .blue)
                
            }else {
                lblTimeIn.text = "\(date.hour()):\(date.minute())"
                
            }
        }
        
    }
    func valid() -> Bool {
        if txfCode.text?.count == 0 {
            self.showAlert(title: "Số xe không được để trống") { (_) in
                
            }
            return false
        }
      
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
