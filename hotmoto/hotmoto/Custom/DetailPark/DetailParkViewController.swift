//
//  DetailParkViewController.swift
//  hotmoto
//
//  Created by Huy on 4/2/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit

class DetailParkViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if park != nil {
            self.loadPark(park: park)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBOutlet weak var imvAvatar: UIImageView!
    @IBOutlet weak var imvState: UIImageView!

    @IBOutlet weak var txvName: UITextView!
    @IBOutlet weak var txvAddress: UITextView!
    @IBOutlet weak var btnPhone: UIButton!
    
    @IBOutlet weak var lblCost: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblAvail: UILabel!

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    var park : Park!
    func loadPark(park: Park!)  {
        self.park = park
        txvName.text = park.name
        lblTotal.text = "\(park.total)"
        btnPhone.setTitle(park.phone, for: .normal)
        txvAddress.text = park.address
        lblCost.text = stringForCost(park?.cost ?? 0, park?.numberHours ?? 0)
        lblTotal.text = "\(park.total)"
        lblAvail.text = "\(park.AvailableSlot)"

    }
    
    @IBAction func selectBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func callPhone(_ sender: Any) {
        if let url = URL(string: "tel://\(self.park.phone)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
            
        }
        
    }

}
