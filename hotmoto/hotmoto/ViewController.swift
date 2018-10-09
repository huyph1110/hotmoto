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
    @IBOutlet weak var loginHeigh: NSLayoutConstraint!
    
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
        txfUserName.attributedPlaceholder = NSAttributedString(string: "Tên đăng nhập", attributes: [NSAttributedStringKey.foregroundColor : UIColor("#959DAD")])
        txfPasswords.attributedPlaceholder = NSAttributedString(string: "Mật khẩu", attributes: [NSAttributedStringKey.foregroundColor : UIColor("#959DAD")])
        let paddingView = UIView(frame: CGRect(x:0,y: 0,width: 8,height: txfUserName.frame.height))
        let paddingView2 = UIView(frame: CGRect(x:0,y: 0,width: 8,height: txfPasswords.frame.height))

        txfUserName.leftView = paddingView
        txfUserName.leftViewMode = UITextFieldViewMode.always
        txfPasswords.leftView = paddingView2
        txfPasswords.leftViewMode = UITextFieldViewMode.always
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func selectLoginType(_ sender: UIButton) {
        self.performSegue(withIdentifier: segue_type.guest.rawValue, sender: self)

    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    @IBAction func login(_ sender: UIButton) {
    
        
        if txfPasswords.text?.count == 0 || txfUserName.text?.count == 0 {
            self.showAlert(title: "Tài khoản hoặc mật khẩu không được để trống", completion: {_ in })
        }
        else if (txfPasswords.text?.contains(" "))! || (txfUserName.text?.contains(" "))! {
            self.showAlert(title: "Tài khoản và mật khẩu không được có khoảng trắng", completion: {_ in })
            
        }
        else {
            App.showLoadingOnView(view: self.view)
            let req = loginReq()
            req.username = txfUserName.text!
            req.password = txfPasswords.text!
            
            services.userLogin(request: req, success: {
                userLogin.password = req.password
                userLogin.username = req.username
                
                App.removeLoadingOnView(view: self.view)
                UserDefaults.standard.setValue(req.username, forKey: LOGIN_ACCOUNT.USER.rawValue)
                UserDefaults.standard.setValue(req.password, forKey: LOGIN_ACCOUNT.PASS.rawValue)
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: segue_type.managepark.rawValue, sender: self)
                    
                }
                
            }, failure: { (error) in
                
                self.showAlert(title: error, completion: {_ in })
                App.removeLoadingOnView(view: self.view)
                
            })
        }
        
        
    }
    @IBAction func register(_ sender: Any) {
        
        if txfPasswords.text?.count == 0 || txfUserName.text?.count == 0 {
            self.showAlert(title: "Tài khoản hoặc mật khẩu không được để trống", completion: {_ in })
        }
        else if (txfPasswords.text?.contains(" "))! || (txfUserName.text?.contains(" "))! {
            self.showAlert(title: "Tài khoản và mật khẩu không được có khoảng trắng", completion: {_ in })
            
        }
        else {
            App.showLoadingOnView(view: self.view)

            let req = registerReq()
            req.username = txfUserName.text!
            req.password = txfPasswords.text!
            services.userRegister(request: req, success: {
                self.showAlert(title: "Đăng ký thành công", completion: {_ in })
                App.removeLoadingOnView(view: self.view)

            }, failure: { (error) in
                self.showAlert(title: error, completion: {_ in })
                App.removeLoadingOnView(view: self.view)

            })
        }
    }
    
}

