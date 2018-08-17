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
import AlamofireImage

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
extension UIViewController: UIPopoverPresentationControllerDelegate {
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
    func showPopover(contentSize: CGSize, sourceRect: CGRect, contentVC: UIViewController, direction: UIPopoverArrowDirection ) {
        DispatchQueue.main.async {
            
            let nav = UINavigationController(rootViewController: contentVC)
            nav.isNavigationBarHidden = true
            nav.modalPresentationStyle = UIModalPresentationStyle.popover
            let popover = nav.popoverPresentationController
            contentVC.preferredContentSize = contentSize
            popover?.sourceView = self.view
            popover?.sourceRect = sourceRect
            popover?.delegate = self
            popover?.permittedArrowDirections = direction
            popover?.backgroundColor = contentVC.view.backgroundColor
            self.present(nav, animated: true, completion: nil)
        }
    }
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
extension UIImageView {
    func setImage(url: String?) {
        if let aurl = URL.init(string: url!) {
            let urlcv = URLRequest.init(url: aurl)
            let filter = AspectScaledToFillSizeFilter(size: self.frame.size)
            
            self.af_setImage(withURLRequest: urlcv, placeholderImage: nil, filter: filter, progress: { (progress) in
                
            }, progressQueue: DispatchQueue.global(qos: .background), imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: true, completion: { (data) in
                
            })
            
        }
        else {
            
            self.image = nil
        }
    }
}
 func callPhone(_ phone: String) {
    if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url)
        
    }
    
}
func money(_ value: Int) -> String {
    let formatter = NumberFormatter()
    formatter.groupingSeparator = "."
    formatter.decimalSeparator = ","
    formatter.numberStyle = .decimal
    if let formattedAmount = formatter.string(for: value){
        return formattedAmount
    }
    return ""
}

func stringMobileType(_ value: Int) -> String {
    if value == 1 {
        return mobileType.moto.0
    }
    if value == 2 {
        return mobileType.oto.0
    }
    return mobileType.all.0
}

func stringForCost(_ value: Int,_ hour: Int) -> String {
    if  value == 0 {
        return "miễn phí"
    }
    if hour == 24 {
        
        return  "\(money(value)) đ / ngày"
    }
    
    return "\(money(value)) đ / \(hour) giờ"
}
func stringForTime(_ begin: Int,_ end: Int) -> String {
    let beginHour = begin/60
    let beginMin = begin % 60
    let endHour = end/60
    let endMin = begin % 60
    
    return String(format: "%d:%02d đến %d:%02d",beginHour,beginMin,endHour,endMin )
    
}
func stringForSize(_ size: Int) -> String {
    if size == 101 {
        return "trên 100"
    }
    return "\(size)"
    
}
