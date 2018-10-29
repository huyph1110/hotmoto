//
//  ViewController.swift
//  hotmoto
//
//  Created by Huy on 3/25/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController, GADBannerViewDelegate {

    @IBOutlet weak var txfPasswords: UITextField!
    @IBOutlet weak var txfUserName: UITextField!
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet  var viewUserInfo: UIView!
    @IBOutlet weak var btnAccept: UIButton!
    
    
    
    var type = LOGIN_TYPE.LOGIN
    
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
        
        bannerView.adUnitID = Admob_UnitID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        bannerView.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {

    }
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print(error)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func managePark(_ sender: Any) {
        type = LOGIN_TYPE.LOGIN
        viewUserInfo.isHidden = false
        viewUserInfo.present(inView: self.view)
        btnAccept.setTitle("Đăng nhập", for: .normal)
    }
    @IBAction func register(_ sender: Any) {
        type = LOGIN_TYPE.REGISTER
        viewUserInfo.isHidden = false
        viewUserInfo.present(inView: self.view)
        btnAccept.setTitle("Đăng ký", for: .normal)
    }
    @IBAction func accept(_ sender: Any) {
        
        if type == LOGIN_TYPE.LOGIN {
            login()
            
        }else if type == LOGIN_TYPE.REGISTER {
            register()
        }
        viewUserInfo.dismiss()

    }
    @IBAction func closeView(_ sender: Any) {
        viewUserInfo.dismiss()
    }
    
    @IBAction func searchPark(_ sender: UIButton) {
        self.performSegue(withIdentifier: segue_type.guest.rawValue, sender: self)

    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
   func login() {
        
        if txfPasswords.text?.count == 0 || txfUserName.text?.count == 0 {
            self.showAlert(title: "Tài khoản hoặc mật khẩu không được để trống", completion: {_ in })
        }
        else if (txfPasswords.text?.contains(" "))! || (txfUserName.text?.contains(" "))! {
            self.showAlert(title: "Tài khoản và mật khẩu không được có khoảng trắng", completion: {_ in })
            
        }
        else {
            
            App.showLoadingOnView(view: self.view)
           
            loginFunc { (success) in
                App.removeLoadingOnView(view: self.view)
                if success {
                    self.regTokenFunc { (success) in
                        App.removeLoadingOnView(view: self.view)
                        if success {
                            UserDefaults.standard.setValue(userLogin?.username, forKey: LOGIN_ACCOUNT.USER.rawValue)
                            UserDefaults.standard.setValue(userLogin?.password, forKey: LOGIN_ACCOUNT.PASS.rawValue)
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: segue_type.managepark.rawValue, sender: self)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func loginFunc(complete :@escaping ((Bool)->Void) ) {
        let req = loginReq()
        req.username = txfUserName.text!
        req.password = txfPasswords.text!
        
        services.userLogin(request: req, success: { (user) in
            userLogin = user
            complete(true)


        }, failure: { (error) in
            self.showAlert(title: error, completion: {_ in })
            complete(false)

        })
    }
    func regTokenFunc(complete :@escaping ((Bool)->Void) ) {
        if let token =  UserDefaults.standard.value(forKey: SYSTEM.TOKEN.rawValue) as? String {
            let req = registerTokenReq()
            req.userID = userLogin?.userID ?? ""
            req.deviceToken = token
            services.registerToken(request: req, success: {
                complete(true)
            }) { (error) in
                self.showAlert(title: error, completion: {_ in })
                complete(false)
            }
        }
       
    }
    
    func register() {
        
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

