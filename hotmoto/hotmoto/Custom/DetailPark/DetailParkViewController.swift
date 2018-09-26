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
        // Do any additional setup after loading the view.
        if myPark != nil {
            loadPark(park: myPark)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBOutlet weak var imvAvatar: UIImageView!
    @IBOutlet weak var imvState: UIImageView!
    @IBOutlet weak var imvMobiType: UIImageView!
    
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
    var myPark: Park?
    func loadPark(park: Park!)  {
        txvName.text = park.name
        lblTotal.text = "\(park.total)"
        btnPhone.setTitle(park.phone, for: .normal)
        txvAddress.text = park.address
        lblCost.attributedText = attriButestringForCost(park.cost , park.numberHours )
        lblTotal.text = "\(park.total)"
        lblAvail.attributedText = attributeStringForAvailSlot(park.AvailableSlot)
        imvMobiType.image = iconForType(park.type)
    }
    
    @IBAction func selectBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func callPhone(_ sender: Any) {
        if let url = URL(string: "tel://\(btnPhone.titleLabel?.text ?? "")"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
            
        }
        
    }

}
