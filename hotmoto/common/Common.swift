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
            indicator.color = UIColor.gray

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
func stringDistance(_ value: Int) -> String {
    let format = NumberFormatter()
    format.minimumFractionDigits = 0
    format.maximumFractionDigits = 2
    format.minimumIntegerDigits = 1
//    let string = String(format: "%.2f", CGFloat(value)/1000)
    return format.string(from: NSNumber(floatLiteral: Double(value)/1000))! +  "km"
    
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
func attriButestringForCost(_ value: Int,_ hour: Int) -> NSAttributedString {
    if  value == 0 {
        return NSAttributedString(string: "Miễn phí", attributes: [NSAttributedStringKey.foregroundColor  : ColorsConfig.button_green])
    }
    if hour == 24 {
        return NSAttributedString(string: "\(money(value)) đ / ngày", attributes: [NSAttributedStringKey.foregroundColor  : UIColor.black])

    }
    return NSAttributedString(string: "\(money(value)) đ / \(hour) giờ", attributes: [NSAttributedStringKey.foregroundColor  : UIColor.black])

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

func attributeStringForCount(_ current: Int, _ total: Int) -> NSAttributedString {
    let returnStr = NSMutableAttributedString(string: "")
    if current < total {
        let currentstr = NSAttributedString(string: "\(current)/", attributes: [NSAttributedStringKey.foregroundColor  : ColorsConfig.button_blue])
        returnStr.append(currentstr)
    }
    else {
        let currentstr = NSAttributedString(string: "\(current)/", attributes: [NSAttributedStringKey.foregroundColor  : ColorsConfig.button_red])
        returnStr.append(currentstr)
    }
    let totalStr = NSAttributedString(string: "\(total)", attributes: [NSAttributedStringKey.foregroundColor  : ColorsConfig.button_red])
    returnStr.append(totalStr)
    return returnStr
}

func attributeStringForAvailSlot(_ avail: Int) -> NSAttributedString {
    if avail == 0 {
        return NSAttributedString(string: "\(avail)", attributes: [NSAttributedStringKey.foregroundColor  : ColorsConfig.button_red])
    }
    return NSAttributedString(string: "\(avail)", attributes: [NSAttributedStringKey.foregroundColor  : ColorsConfig.button_blue])
}

func iconForType(_ type: Int) -> UIImage? {
    switch type {
    case 0:
        return #imageLiteral(resourceName: "mobiall")
    case 1:
        return  #imageLiteral(resourceName: "moto")
    case 2:
        return #imageLiteral(resourceName: "oto")
    default:
        return nil
    }
    
}
func iconForTypeWhite(_ type: Int) -> UIImage? {
    switch type {
    case 0:
        return #imageLiteral(resourceName: "mobiall-white")
    case 1:
        return  #imageLiteral(resourceName: "moto-white")
    case 2:
        return #imageLiteral(resourceName: "oto-white")
    default:
        return nil
    }
    
}
func stateForPark(_ park: Park) -> NSAttributedString {
    if park.status == 1 {//0: san sang ; 1: da dong

        return NSAttributedString(string: "Đóng cửa", attributes: [NSAttributedStringKey.foregroundColor  : ColorsConfig.button_yellow])
    }
    //else
    //ngoai gio lam viec
    let now = Date()
    let currentBeginMin = now.minute() + now.hour()*60
    
    if currentBeginMin < park.openTime || currentBeginMin > park.closeTime {
        return NSAttributedString(string: "Đóng cửa", attributes: [NSAttributedStringKey.foregroundColor  : ColorsConfig.button_yellow])
    }
    //đã đầy
    if park.AvailableSlot == 0 {
        return NSAttributedString(string: "Đã đầy", attributes: [NSAttributedStringKey.foregroundColor  : ColorsConfig.button_red])
    }
    
    return NSAttributedString(string: "Mở cửa", attributes: [NSAttributedStringKey.foregroundColor  : ColorsConfig.button_green])
}
