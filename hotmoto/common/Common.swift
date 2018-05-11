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
    func showAlert(title: String, vc: UIViewController, completion:@escaping (Bool) -> Void)  {
        DispatchQueue.main.async {
            let alertView = UIAlertController(title: "Thông báo", message: title, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                completion(true)
            })
            alertView.addAction(action)
            vc.present(alertView, animated: true, completion: nil)
        }
        
    }
    
    func showLoadingOnView(view: UIView){
        DispatchQueue.main.async {
            let indicator = UIActivityIndicatorView.init()
            indicator.center = CGPoint.init(x: view.frame.width/2, y: view.frame.height/2)
            indicator.color = UIColor.blue
            indicator.activityIndicatorViewStyle  = .whiteLarge
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
