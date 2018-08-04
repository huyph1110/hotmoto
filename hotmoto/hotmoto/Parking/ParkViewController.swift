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


class ParkViewController: UIViewController,MapSelectionViewControllerDelegate {
    func mapSelectionDidSelect(location: CLLocationCoordinate2D, suggest: String?) {
        coordinate = location
        txvAddress.text = suggest
    }
    
    
    var config: CLDConfiguration!
    var cloudinary: CLDCloudinary!
    //properties
    @IBOutlet weak var imvAvatar: UIImageView!
    @IBOutlet weak var txvAddress: UITextView!
    @IBOutlet weak var txvParkName: UITextView!
    @IBOutlet weak var txfCost: UITextField!
    @IBOutlet weak var txfType: UITextField!
    @IBOutlet weak var txfTime: UITextField!
    @IBOutlet weak var txfTotal: UITextField!
    @IBOutlet weak var txfPhone: UILabel!
    
    
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
        request.phone = txfPhone.text!
        request.total = 4
        request.username =  userLogin.username
        //request.cost =  (txfCost.text ?? "0")
        //request.openTime =  0
        //request.closeTime =  24
        request.email =  ""
        request.imageUrl = urlImage
        services.insertPark(request: request, success: {
            App.removeLoadingOnView(view: self.view)
            
        }) { (error) in
            App.removeLoadingOnView(view: self.view)
            
            self.showAlert(title: error, completion: { (_) in
                
            })
        }
    }
    func validateData() -> Bool {
        if coordinate == nil {
            self.showAlert(title: "Hãy chọn vị trí bãi đỗ", completion: { (complete) in
                
            })
            return false
        }
        if txfPhone.text?.count == 0 {
            self.showAlert(title: "Hãy nhập số dt", completion: { (complete) in
                
            })
            return false
        }
        
        return true
        
        
        
    }
}

