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

class ParkManagerViewController: UIViewController,MapSelectionViewControllerDelegate {
    func mapSelectionDidSelect(location: CLLocationCoordinate2D, suggest: String?) {
        
    }
    
    var config: CLDConfiguration!
    var cloudinary: CLDCloudinary!

    override func viewDidLoad() {
        super.viewDidLoad()
        config = CLDConfiguration(cloudName: cloudName, apiKey: apiKey, apiSecret: apiSecret)
        cloudinary = CLDCloudinary(configuration: self.config)
        

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
    
    @IBOutlet weak var imvAvatar: UIImageView!
    @IBOutlet weak var txvType: UITextField!
    @IBOutlet weak var txvName: UITextView!
    @IBOutlet weak var txvAddress: UITextView!
    @IBOutlet weak var txfCost: UITextField!
    @IBOutlet weak var txfTime: UITextField!
    @IBOutlet weak var txfTotal: UITextField!
    @IBOutlet weak var txfPhone: UITextField!
    
    
    
    var park: Park?
    
    func loadPark()  {
        if park != nil  {
            txvName.text = park?.name
            txvAddress.text = park?.address
            txfTime.text = "\(park?.openTime ?? 0)" + "-" + "\(park?.closeTime ?? 24)"
            txfCost.text = park?.cost
            txfTotal.text = "\(park?.total ?? 0)"
            txfPhone.text  = park?.phone
            coordinate = park?.position
            imvAvatar.setImage(url: park?.imageUrl)
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
        request.phone = txfPhone.text!
        request.total = 4
        request.username =  userLogin.username
        //request.cost =  (txfCost.text ?? "0")
        //request.openTime =  0
        //request.closeTime =  24
        request.email =  ""
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
        if txfPhone.text?.count == 0 {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
