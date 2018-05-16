//
//  MyParkListViewController.swift
//  hotmoto
//
//  Created by Huy on 5/16/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit

class MyParkListViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    var arrayPark = [Park]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayPark.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParkCell") as! ParkCell
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        tbvData.register(UINib.init(nibName: "ParkCell", bundle: nil), forCellReuseIdentifier: "ParkCell")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var tbvData: UITableView!
    

    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Load data
     */
    func loadMyParks()  {
        
    }
}
