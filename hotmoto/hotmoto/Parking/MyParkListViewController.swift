//
//  MyParkListViewController.swift
//  hotmoto
//
//  Created by Huy on 5/16/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit
import AlamofireImage
import GoogleMobileAds

class MyParkListViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    var arrayPark = [Park](){
        didSet{
            userLogin?.parkList = arrayPark
            DispatchQueue.main.async {
                self.tbvData.reloadData()
            }
        }
    }
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var notifiBar: BadgeBarButtonItem!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayPark.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParkCell") as! ParkCell
        let park = arrayPark[indexPath.row]
        cell.lblName.text = park.name
        cell.lblAddress.text = park.address
        cell.lblState.attributedText = stateForPark(park)
        cell.lblCost.attributedText = attriButestringForCost(park.cost , park.numberHours )

        cell.imvAvatar?.setImage(url: park.imageUrl)
        cell.imvType.image = iconForType(park.type)
        let current = park.total - park.AvailableSlot
        cell.btnCount.setAttributedTitle(attributeStringForCount(current, park.total), for: .normal)
        cell.btnCount.tag = indexPath.row
        cell.btnCount.addTarget(self, action: #selector(MyParkListViewController.updateCount), for: .touchUpInside)

        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: segue_type.editpark.rawValue, sender: self)
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Xóa"
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            showConfirm(title: "Xác nhận xóa bãi đỗ", detail: "") { (accept) in
                if accept {
                    
                    let park = self.arrayPark[indexPath.row]
                    services.deletePark(parkID: park.id ?? "", success: {
                        DispatchQueue.main.async {
                            self.arrayPark.remove(at: indexPath.row)
                            tableView.deleteRows(at: [indexPath], with: .automatic)
                        }
                    }, failure: { (error) in
                        self.showAlert(title: error, completion: { (_) in
                            
                        })
                    })
                }
            }
           
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tbvData.register(UINib.init(nibName: "ParkCell", bundle: nil), forCellReuseIdentifier: "ParkCell")
        // Do any additional setup after loading the view.
        tbvData.rowHeight = UITableView.automaticDimension
        tbvData.estimatedRowHeight = 44
        bannerView.adUnitID = Admob_UnitID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        let predicate = NSPredicate(format: "isread = %@", false)
        let  notifications = fetchNotifications(predicate: predicate)
        notifiBar.badgeNumber = notifications.count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        loadMyParks()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination
        if vc is ParkManagerViewController {
            (vc as! ParkManagerViewController).park = arrayPark[(tbvData.indexPathForSelectedRow?.row)!]
        }
    }
    @IBOutlet weak var tbvData: UITableView!
    


    
    /*
    // MARK: - Load data
     */
    func loadMyParks()  {
        if let user = userLogin{
            services.getParksByUser(user: user.username , success: { (list) in
                self.arrayPark = list!
                user.parkList = list
            }, failure: { (error) in
                
            })
        }
    }
    @objc func updateCount(_ btn: UIButton) {
        let park  = arrayPark[btn.tag]
        let vc = CountUpdateViewController()
        vc.value = park.total - park.AvailableSlot
        vc.max = park.total
        vc.min = 0
        
        let rect = btn.superview?.convert(btn.frame, to: self.view)
        showPopover(contentSize: CGSize(width: 120, height: 80), sourceRect: rect!, contentVC: vc, direction: .any)
        vc.completeHandler = {
            (value) -> Void in
            let slot = park.total - value
            self.updateSlotForPark(park, slot, success: {(success) in
                if success {
                    park.AvailableSlot = slot
                    DispatchQueue.main.async {
                        self.tbvData.reloadRows(at: [IndexPath(row: btn.tag, section: 0)], with: .fade)
                    }
                }
                
                vc.dismiss(animated: true, completion: nil)

            })
        }
        
    }
    
    func updateSlotForPark(_ park: Park,_ slot: Int, success: @escaping ((Bool) -> Void)) {
        let request = insertParkReq()
        request.id = park.id
        request.AvailableSlot =  slot
        //request.email =  ""
        
        request.location = location(coordinate: park.position)
        request.name = park.name
        request.address = park.address
        request.phone = park.phone
        request.total = park.total
        request.username =  park.username
        request.cost =  park.cost
        request.numberHours = park.numberHours
        request.imageUrl = park.imageUrl
        request.type = park.type
        request.openTime =  park.openTime
        request.closeTime =  park.closeTime
        
        services.updatePark(request: request, success: {
            success(true)
        }) { (error) in
            success(false)
            self.showAlert(title: error, completion: { (_) in
                
            })
        }
        
    }
    @IBAction func notificationList(_ sender: Any) {
        notifiBar.badgeNumber = 0
        let vc = RegisterNotificationViewController()
        self.present(vc) {
            
        }
    }
    
}
