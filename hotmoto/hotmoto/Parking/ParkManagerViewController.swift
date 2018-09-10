//
//  ParkManagerViewController.swift
//  hotmoto
//
//  Created by Huy on 4/30/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit
import GoogleMaps
import Cloudinary
import Alamofire
import KMPlaceholderTextView

class ParkManagerViewController: UIViewController,MapSelectionViewControllerDelegate {
 
    
   
    func mapSelectionDidSelect(location: CLLocationCoordinate2D, suggest: String?) {
        coordinate = location
        txvAddress.text = suggest

    }
    
    var config: CLDConfiguration!
    var cloudinary: CLDCloudinary!

    override func viewDidLoad() {
        super.viewDidLoad()
        config = CLDConfiguration(cloudName: cloudName, apiKey: apiKey, apiSecret: apiSecret)
        cloudinary = CLDCloudinary(configuration: self.config)
        txvAddress.placeholderColor = UIColor.lightGray
        txvAddress.textColor = UIColor.white
        
        txvName.placeholderColor = UIColor.lightGray
        txvName.textColor = UIColor.white

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
        barPhone.setIcon(#imageLiteral(resourceName: "call"))
        barPhone.btnSelect.addTarget(self, action: #selector(ParkManagerViewController.selectPhone), for: .touchUpInside)

        // Do any additional setup after loading the view.
        loadPark()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination
        if vc is MapSelectionViewController {
            (vc as! MapSelectionViewController).delegate = self
            (vc as! MapSelectionViewController).parkCoordinate = park?.position
        }
        
        
    }

    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var barCost: SlectionBarView!
    @IBOutlet weak var barType: SlectionBarView!
    @IBOutlet weak var barTime: SlectionBarView!
    @IBOutlet weak var barSize: SlectionBarView!
    @IBOutlet weak var barPhone: SlectionBarView!

    @IBOutlet weak var imvAvatar: UIImageView!
   // @IBOutlet weak var txvType: UITextField!
    @IBOutlet weak var txvName: KMPlaceholderTextView!
    @IBOutlet weak var txvAddress: KMPlaceholderTextView!
    //@IBOutlet weak var txfCost: UITextField!
    //@IBOutlet weak var txfTime: UITextField!
    //@IBOutlet weak var txfTotal: UITextField!
    //@IBOutlet weak var txfPhone: UITextField!
    
    
    
    var park: Park?
    
    func loadPark()  {
        if park != nil  {
            timeValue = [(park?.openTime)!, (park?.closeTime)!]
            sizeValue = [(park?.total)!]
            costValue = [(park?.cost)!, (park?.numberHours)!]
            typeValue = [(park?.type)!]
            
            txvName.text = park?.name
            txvAddress.text = park?.address
            barTime.text.text = stringForTime(timeValue[0],timeValue[1])
            barCost.text.text = stringForCost(park?.cost ?? 0, park?.numberHours ?? 0)
            barSize.text.text = "\(park?.total ?? 0)"
            barPhone.text.text  = park?.phone
            coordinate = park?.position
            imvAvatar.setImage(url: park?.imageUrl)
            barType.text.text = stringMobileType((park?.type)!)
           
        }
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
    func updatePark()  {
        if validateData() == false {
            return
        }
        
        App.showLoadingOnView(view: self.view)
        let request = insertParkReq()
        request.location = location(coordinate: coordinate!)
        request.name = txvName.text
        request.address = txvAddress.text
        request.phone = barPhone.text.text
        request.total = sizeValue[0]
        request.username =  userLogin.username
        request.cost =  costValue[0]
        request.numberHours = costValue[1]
        request.id = park?.id
        request.imageUrl = urlImage
        request.type = typeValue[0]
        request.openTime =  timeValue[0]
        request.closeTime =  timeValue[1]
        //request.email =  ""
        services.updatePark(request: request, success: {
            App.removeLoadingOnView(view: self.view)
            self.showAlert(title: "Cập nhật thành công", completion: { (_) in
                self.dismiss(animated: true, completion: nil)

            })

        }) { (error) in
            App.removeLoadingOnView(view: self.view)
            
            self.showAlert(title: error, completion: { (_) in
                
            })
        }
    }
    func validateData() -> Bool {
        if txvName.text.count == 0 {
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

    @IBAction func save(_ sender: Any) {
        updatePark()
        
    }
    
    @IBAction func selectEdit(_ sender: Any) {
        self.photoCamera()
        
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

   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
