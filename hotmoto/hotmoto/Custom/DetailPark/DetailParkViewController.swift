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

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblAddress: UILabel!

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
        lblName.text = park.name
        lblTotal.text = ""
        lblPhone.text = park.phone
        lblAddress.text = park.address
        lblCost.text = ""
    }
    
    @IBAction func selectBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
