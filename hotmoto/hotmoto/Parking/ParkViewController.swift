//
//  ParkViewController.swift
//  hotmoto
//
//  Created by Huy on 3/25/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit
import Cloudinary
import GoogleMaps
import Alamofire
import KMPlaceholderTextView

class ParkViewController: UIViewController,MapSelectionViewControllerDelegate {
    func mapSelectionDidSelect(location: CLLocationCoordinate2D, suggest: String?) {
        coordinate = location
        txvAddress.text = suggest
    }
    
    
    var config: CLDConfiguration!
    var cloudinary: CLDCloudinary!
    //properties
    @IBOutlet weak var imvAvatar: UIImageView!
    @IBOutlet weak var txvAddress: KMPlaceholderTextView!
    @IBOutlet weak var txvParkName: KMPlaceholderTextView!
    
    @IBOutlet weak var barCost: SlectionBarView!
    @IBOutlet weak var barType: SlectionBarView!
    @IBOutlet weak var barTime: SlectionBarView!
    @IBOutlet weak var barSize: SlectionBarView!
    @IBOutlet weak var barPhone: SlectionBarView!
    

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination
        if vc is MapSelectionViewController {
            (vc as! MapSelectionViewController).delegate = self
        }
        

    }

    override func viewDidLoad() {
        super.viewDidLoad() //tvuVpl7UHhIuzWu83G1UYPo5ZyQ
        config = CLDConfiguration(cloudName: cloudName, apiKey: apiKey, apiSecret: apiSecret)
        cloudinary = CLDCloudinary(configuration: self.config)
        txvAddress.placeholderColor = UIColor.lightGray
        txvAddress.textColor = UIColor.white

        txvParkName.placeholderColor = UIColor.lightGray
        txvParkName.textColor = UIColor.white

        
        barCost.setPlaceHolder("Chọn giá")
        barCost.setIcon(#imageLiteral(resourceName: "money_black"))
        barCost.btnSelect.addTarget(self, action: #selector(ParkManagerViewController.selectCost), for: .touchUpInside)
        
        barType.setPlaceHolder("Loại xe")
        barType.setIcon(#imageLiteral(resourceName: "menu"))
        barType.btnSelect.addTarget(self, action: #selector(ParkManagerViewController.selectType), for: .touchUpInside)
        
        barTime.setPlaceHolder("Thời gian gửi")
        barTime.setIcon(#imageLiteral(resourceName: "time_light"))
        barTime.btnSelect.addTarget(self, action: #selector(ParkManagerViewController.selectTime), for: .touchUpInside)
        
        barSize.setPlaceHolder("Sức chứa")
        barSize.setIcon(#imageLiteral(resourceName: "Park"))
        barSize.btnSelect.addTarget(self, action: #selector(ParkManagerViewController.selectSize), for: .touchUpInside)
        
        barPhone.setPlaceHolder("SDT liên lạc")
        barPhone.setIcon(#imageLiteral(resourceName: "call-Black"))
        barPhone.btnSelect.addTarget(self, action: #selector(ParkManagerViewController.selectPhone), for: .touchUpInside)

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editImage(_ sender: Any) {
        
        self.photoCamera()
    }
    
    @IBAction func createPark(_ sender: Any) {
        addNewPark()
    }
    
    func uploadImage(data: Data, name: String) {
        
        
        _ =  cloudinary.createUrl().generate(name)
        cloudinary.createUploader().signedUpload(data: data, params: nil, progress: { (progress) in
            print(progress.fractionCompleted)
        }) { (resul, error) in
            print(error?.description ?? "")
            if error == nil {
                self.urlImage = resul?.url
                self.imvAvatar.image = UIImage.init(data: data)
            }

        }

    }
    
   
    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        //let url = info[UIImagePickerControllerReferenceURL] as! String
        //let type = info[UIImagePickerControllerMediaType] as! String
        let data = UIImagePNGRepresentation(image)
        uploadImage(data: data!, name: generateImageName(type: "png")!)
        picker.dismiss(animated: true, completion: nil)
        
    }
    func generateImageName(type: String) -> String? {
        if let username = UserDefaults.standard.value(forKey: LOGIN_ACCOUNT.USER.rawValue) {
            let time = Date().description
            
            return (username as! String) + time + type

        }
        return nil
    }
    var urlImage: String?
    var coordinate: CLLocationCoordinate2D? = nil
    func addNewPark()  {
        if validateData() == false {
            return
        }
        
        App.showLoadingOnView(view: self.view)
        let request = insertParkReq()
        request.location = location(coordinate: coordinate!)
        request.name = txvParkName.text
        request.address = txvAddress.text
        request.phone = barPhone.text.text
        request.total = sizeValue[0]
        request.username =  userLogin.username
        request.cost =  costValue[0]
        request.numberHours = costValue[1]
        request.imageUrl = urlImage
        request.type = typeValue[0]
        request.openTime =  timeValue[0]
        request.closeTime =  timeValue[1]
        //request.email =  ""
        services.insertPark(request: request, success: {
            App.removeLoadingOnView(view: self.view)
            
        }) { (error) in
            App.removeLoadingOnView(view: self.view)
            
            self.showAlert(title: error, completion: { (_) in
                
            })
        }
    }
    func validateData() -> Bool {
        if txvParkName.text.count == 0 {
            self.showAlert(title: "Hãy đặt tên bãi", completion: { (complete) in
                
            })
            return false
        }

        if coordinate == nil {
            self.showAlert(title: "Hãy chọn vị trí bãi đỗ", completion: { (complete) in
                
            })
            return false
        }
        if barPhone.text.text?.count == 0 {
            self.showAlert(title: "Hãy nhập số dt", completion: { (complete) in
                
            })
            return false
        }
        
        return true
        
        
        
    }
    
    
    
    @objc func selectCost() {
        let rect = barCost.convert(barCost.bounds, to: self.view)
        let vc = DataPickerViewController()
        vc.type = .cost
        vc.values = costValue
        showPopover(contentSize: CGSize(width: 400, height: 400), sourceRect: rect, contentVC: vc, direction: .any)
        vc.completeHandler = {
            (value) -> Void in
            //[value, costtime.1]
            self.costValue = value
            self.barCost.setText(stringForCost(value[0], value[1]))
            vc.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func selectType() {
        let rect = barType.convert(barType.bounds, to: self.view)
        let vc = DataPickerViewController()
        vc.type = .type
        vc.values = typeValue
        showPopover(contentSize: CGSize(width: 400, height: 400), sourceRect: rect, contentVC: vc, direction: .any)
        vc.completeHandler = {
            (value) -> Void in
            //[value, costtime.1]
            self.typeValue = value
            self.barType.setText(stringMobileType(value[0]))
            vc.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func selectTime() {
        let rect = barTime.convert(barTime.bounds, to: self.view)
        let vc = DataPickerViewController()
        vc.type = .time
        vc.values = timeValue
        showPopover(contentSize: CGSize(width: 400, height: 400), sourceRect: rect, contentVC: vc, direction: .any)
        vc.completeHandler = {
            (value) -> Void in
            //[value, costtime.1]
            self.timeValue = value
            self.barTime.setText(stringForTime(value[0], value[1]))
            vc.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func selectSize() {
        let rect = barSize.convert(barSize.bounds, to: self.view)
        let vc = DataPickerViewController()
        vc.type = .size
        vc.values = sizeValue
        showPopover(contentSize: CGSize(width: 400, height: 400), sourceRect: rect, contentVC: vc, direction: .any)
        vc.completeHandler = {
            (value) -> Void in
            //[value, costtime.1]
            self.sizeValue = value
            self.barSize.setText(stringForSize(value[0]))
            vc.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func selectPhone() {
        barPhone.text.isEnabled  = true
        barPhone.text.keyboardType = .numberPad
        barPhone.text.becomeFirstResponder()
    }
    
    var costValue = [0,0]
    var typeValue = [0]
    var timeValue = [0,0]
    var sizeValue = [0]
    

    
}

