//
//  ViewController.swift
//  hotmoto
//
//  Created by Huy on 3/25/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txfPasswords: UITextField!
    @IBOutlet weak var txfUserName: UITextField!
    
    var type = LOGIN_TYPE.GUEST
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let user = UserDefaults.standard.value(forKey: LOGIN_ACCOUNT.USER.rawValue) {
            txfUserName.text = user as? String

        }
        if let pass = UserDefaults.standard.value(forKey: LOGIN_ACCOUNT.PASS.rawValue) {
            txfPasswords.text = pass as? String

        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func selectLoginType(_ sender: UIButton) {
        if type == LOGIN_TYPE.GUEST {
            type = LOGIN_TYPE.PARK

            sender.setTitle("Quản lý", for: .normal)
        }else {
            type = LOGIN_TYPE.GUEST
            sender.setTitle("Tìm bãi", for: .normal)

        }        
    }
    
    @IBAction func login(_ sender: UIButton) {
        if type == LOGIN_TYPE.GUEST {
            
            self.performSegue(withIdentifier: segue_type.guest.rawValue, sender: self)
        }else {
            
            if txfPasswords.text?.count == 0 || txfUserName.text?.count == 0 {
                App.showAlert(title: "Tài khoản hoặc mật khẩu không được để trống", vc: self, completion: {_ in })
            }
            else if (txfPasswords.text?.contains(" "))! || (txfUserName.text?.contains(" "))! {
                App.showAlert(title: "Tài khoản và mật khẩu không được có khoảng trắng", vc: self, completion: {_ in })
                
            }
            else {
                App.showLoadingOnView(view: self.view)
                let req = loginReq()
                req.username = txfUserName.text!
                req.password = txfPasswords.text!
                services.userLogin(request: req, success: {
                    App.removeLoadingOnView(view: self.view)
                    UserDefaults.standard.setValue(req.username, forKey: LOGIN_ACCOUNT.USER.rawValue)
                    UserDefaults.standard.setValue(req.password, forKey: LOGIN_ACCOUNT.PASS.rawValue)

                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: segue_type.managepark.rawValue, sender: self)

                    }

                }, failure: { (error) in
                    
                    App.showAlert(title: error, vc: self, completion: {_ in })
                    App.removeLoadingOnView(view: self.view)

                })
            }

        }
        
    }
    @IBAction func register(_ sender: Any) {
        
        if txfPasswords.text?.count == 0 || txfUserName.text?.count == 0 {
            App.showAlert(title: "Tài khoản hoặc mật khẩu không được để trống", vc: self, completion: {_ in })
        }
        else if (txfPasswords.text?.contains(" "))! || (txfUserName.text?.contains(" "))! {
            App.showAlert(title: "Tài khoản và mật khẩu không được có khoảng trắng", vc: self, completion: {_ in })
            
        }
        else {
            App.showLoadingOnView(view: self.view)

            let req = registerReq()
            req.username = txfUserName.text!
            req.password = txfPasswords.text!
            services.userRegister(request: req, success: {
                App.showAlert(title: "Đăng ký thành công", vc: self, completion: {_ in })
                App.removeLoadingOnView(view: self.view)

            }, failure: { (error) in
                App.showAlert(title: error, vc: self, completion: {_ in })
                App.removeLoadingOnView(view: self.view)

            })
        }
    }
    
}

