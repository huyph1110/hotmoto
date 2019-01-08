//
//  RegisterNotificationViewController.swift
//  MotoPark
//
//  Created by Huy on 11/1/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit

class RegisterNotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NotificationTableViewCell
        let noti = notifications[indexPath.row]
        let time =  notifications[indexPath.row].date?.stringDate("dd/MM HH:mm ")
        if let park = userLogin?.parkList?.filter({$0.id == noti.parkid}).first {
            cell.lblTitle?.text =  park.name
        }
        if noti.isread == false {
            noti.isread = true
            noti.save()
        }
        cell.lblTitle?.text = (time ?? "")  + (noti.title ?? "")
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tbvList.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view.
        reloadData()
    }
    @objc func reloadData()  {
        notifications = fetchNotifications()
        notifications.reverse()
        tbvList.reloadData()
    }
    @IBOutlet weak var tbvList: UITableView!
    var notifications = [Notification]()
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func back(_ sender: Any) {
        self.dismiss()
    }
    
}
