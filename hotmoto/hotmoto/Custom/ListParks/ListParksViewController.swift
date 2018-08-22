//
//  ListParksViewController.swift
//  hotmoto
//
//  Created by Huy on 4/4/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit

class ListParksViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayPark.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let park = arrayPark[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParkCell") as! ParkCell
        cell.lblName.text = park.name
        cell.lblAddress.text = park.address
        cell.lblCost.text = stringForCost(park.cost, park.numberHours)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailParkViewController()
        vc.myPark = self.arrayPark[indexPath.row]
        self.present(vc, animated: true, completion: {
        })

    }
    @IBOutlet weak var tbvData: UITableView!
    
    var arrayPark = [Park]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbvData.register(UINib.init(nibName: "ParkCell", bundle: nil), forCellReuseIdentifier: "ParkCell")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) {
        self.dismiss(animated: true, completion: nil)
    }
    func loadParks(parks: [Park]) {
        arrayPark = parks
        tbvData.reloadData()
        
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
