//
//  MyParkListViewController.swift
//  hotmoto
//
//  Created by Huy on 5/16/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit
import AlamofireImage

class MyParkListViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    var arrayPark = [Park](){
        didSet{
            DispatchQueue.main.async {
                self.tbvData.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayPark.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParkCell") as! ParkCell
        let park = arrayPark[indexPath.row]
        cell.lblName.text = park.name
        cell.lblAddress.text = park.address
        cell.lblState.text = park.status == 0 ? "Mở cửa" : "Đóng cửa"    //0: san sang ; 1: da dong
        cell.lblCost.text = stringForCost(park.cost, park.numberHours)
        cell.imvAvatar?.setImage(url: park.imageUrl)
        cell.imvType.image = iconForType(park.type)

        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: segue_type.editpark.rawValue, sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tbvData.register(UINib.init(nibName: "ParkCell", bundle: nil), forCellReuseIdentifier: "ParkCell")
        // Do any additional setup after loading the view.
        tbvData.rowHeight = UITableViewAutomaticDimension
        tbvData.estimatedRowHeight = 44
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        loadMyParks()

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination
        if vc is ParkManagerViewController {
            (vc as! ParkManagerViewController).park = arrayPark[(tbvData.indexPathForSelectedRow?.row)!]
        }
        
        
    }
    @IBOutlet weak var tbvData: UITableView!
    

    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Load data
     */
    func loadMyParks()  {
        if let user = UserDefaults.standard.value(forKey: LOGIN_ACCOUNT.USER.rawValue) {
            services.getParksByUser(user: user as! String, success: { (list) in
                self.arrayPark = list!
            }, failure: { (error) in
                
            })
        }
    }
}
