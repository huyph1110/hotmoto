//
//  HistoryViewController.swift
//  MotoPark
//
//  Created by Huy on 10/4/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    override func viewDidLoad() {
        super.viewDidLoad()
        tbvData.register(UINib(nibName: "HistoryMobiViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view.
        if let apark = park {
            let predicate = NSPredicate(format: "parkID = %@", apark.id ?? "")
            let array = fetchMobies(predicate: predicate)
            groupByDate = Dictionary(grouping: array, by: {
                "\($0.timein?.day() ?? 0)/" + "\($0.timein?.month() ?? 0)/" + "\($0.timein?.year() ?? 0)"
            })
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let allkey = Array(groupByDate.keys)
        let key = allkey[section]
        return groupByDate[key]?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupByDate.keys.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let allkey = Array(groupByDate.keys)
        let key = allkey[section]
        
        return key
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let allkey = Array(groupByDate.keys)
        let key = allkey[indexPath.section]
        let array = groupByDate[key]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HistoryMobiViewCell
        cell.setMobi(array![indexPath.row])
        
        return cell
    }

   
    
    var groupByDate = Dictionary<String, [Mobile]>()
    var park: Park?

    @IBOutlet weak var naviBar: UINavigationBar!
    @IBOutlet weak var tbvData: UITableView!
    @IBAction func back(_ sender: Any) {
        self.dismiss()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
