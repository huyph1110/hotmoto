//
//  Common.swift
//  hotmoto
//
//  Created by Huy on 4/16/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import Foundation
import PXGoogleDirections
import UIKit

let App = UIApplication.shared.delegate as! AppDelegate
let mapTasks = MapTasks()

extension AppDelegate {
  
    func showLoadingOnView(view: UIView){
        DispatchQueue.main.async {
            let indicator = UIActivityIndicatorView.init()
            indicator.center = CGPoint.init(x: view.frame.width/2, y: view.frame.height/2)
            indicator.activityIndicatorViewStyle  = .whiteLarge
            indicator.color = UIColor.blue

            indicator.startAnimating()
            view.addSubview(indicator)
        }
    }
    
    func removeLoadingOnView(view: UIView){
        DispatchQueue.main.async {

            for subview in view.subviews {
                if subview is UIActivityIndicatorView {
                    subview.removeFromSuperview()
                }
            }
        }
    }
    
}
extension UIViewController {
    func showAlert(title: String, completion:@escaping (Bool) -> Void)  {
        DispatchQueue.main.async {
            let alertView = UIAlertController(title: "Thông báo", message: title, preferredStyle: .alert)
            let action = UIAlertAction(title: "Đồng ý", style: .default, handler: { (alert) in
                completion(true)
            })
            alertView.addAction(action)
            self.present(alertView, animated: true, completion: nil)
        }
        
    }
    func showConfirm(title: String, detail: String, completion:@escaping (Bool) -> Void)  {
        DispatchQueue.main.async {
            let alertView = UIAlertController(title: title, message: detail, preferredStyle: .alert)
            let accept = UIAlertAction(title: "Đồng ý", style: .default, handler: { (alert) in
                completion(true)
            })
            let deni = UIAlertAction(title: "Hủy bỏ", style: .cancel, handler: { (alert) in
                completion(true)
            })
            
            alertView.addAction(accept)
            alertView.addAction(deni)
            
            self.present(alertView, animated: true, completion: nil)
        }
        
    }

}
