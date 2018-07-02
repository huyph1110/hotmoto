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

var apiKey = "751342836181944"
var apiSecret = "tvuVpl7UHhIuzWu83G1UYPo5ZyQ"

class ParkViewController: UIViewController,MapSelectionViewControllerDelegate {
    func mapSelectionDidSelect(location: CLLocationCoordinate2D, suggest: String?) {
        
    }
    
    
    var config: CLDConfiguration!
    var cloudinary: CLDCloudinary!
    //properties
    @IBOutlet weak var imvAvatar: UIImageView!
    @IBOutlet weak var txvUsername: UITextView!
    @IBOutlet weak var txvAddress: UITextView!
    @IBOutlet weak var txvParkName: UITextView!
    @IBOutlet weak var txfCost: UITextField!
    @IBOutlet weak var txfType: UITextField!
    @IBOutlet weak var txfTime: UITextField!
    @IBOutlet weak var txfTotal: UITextField!
    @IBOutlet weak var txfPhone: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad() //tvuVpl7UHhIuzWu83G1UYPo5ZyQ
        config = CLDConfiguration(cloudName: "huyph00", apiKey: apiKey, apiSecret: apiSecret)
        cloudinary = CLDCloudinary(configuration: self.config)
        
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
    
    func uploadImage(data: Data, name: String) {
        
        
        let url =  cloudinary.createUrl().generate(name)
        
        cloudinary.createUploader().signedUpload(data: data, params: nil, progress: { (progress) in
            print(progress.fractionCompleted)
            if progress.isFinished {
                self.urlImage = url
            }
        }) { (resul, error) in
            print(error?.description ?? "")
            
        }

    }
    
   
    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        //let url = info[UIImagePickerControllerReferenceURL] as! String
        //let type = info[UIImagePickerControllerMediaType] as! String
        let data = UIImagePNGRepresentation(image)
        uploadImage(data: data!, name: generateImageName(type: "png"))
        picker.dismiss(animated: true, completion: nil)
        
    }
    func generateImageName(type: String) -> String {
        let username = UserDefaults.value(forKey: LOGIN_ACCOUNT.USER.rawValue) as! String
        let time = Date().description
        
        return username + time + type
    }
    var urlImage: String?
    let coordinate: CLLocationCoordinate2D? = nil
    func addNewPark()  {
        if validateData() == false {
            return
        }
        
        App.showLoadingOnView(view: self.view)
        let request = insertParkReq()
        request.location = ["coordinates" : [coordinate?.longitude,coordinate?.latitude] , "type" : "Point"]
        request.name = "test name"
        request.address = "test address"
        request.phone = "012345"
        request.total = 4
        request.id =  ""
        request.cost =  ""
        request.AvailableSlot =  0
        request.openTime =  0
        request.closeTime =  0
        request.status =  0
        request.email =  ""
        services.insertPark(request: request, success: {
            App.removeLoadingOnView(view: self.view)
            
        }) { (error) in
            App.removeLoadingOnView(view: self.view)
            
            App.showAlert(title: error, vc: self, completion: { (_) in
                
            })
        }
    }
    func validateData() -> Bool {
        if coordinate == nil {
            App.showAlert(title: "Hãy chọn vị trí bãi đỗ", vc: self, completion: { (complete) in
                
            })
            return false
        }
        if txfPhone.text?.count == 0 {
            App.showAlert(title: "Hãy nhập số dt", vc: self, completion: { (complete) in
                
            })
            return false
        }
        
        return true
        
        
        
    }
}

