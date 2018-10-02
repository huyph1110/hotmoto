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
    var saveComplete: (() -> Void)?
    var delComplete: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        if mobi != nil {
            loadMobi(mobi!)
        }
        // Do any additional setup after loading the view.
        
    }
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var txfCode: UITextField!
    
    @IBAction func release(_ sender: Any) {
        self.showConfirm(title: "Xác nhận trả xe?", detail: "") { (ok) in
            if ok {
                self.mobi?.delete()
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
    func loadMobi(_ mobi: Mobile) {
        imageView.image = UIImage(data: mobi.image!)
        txfCode.text = mobi.code
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
