//
//  InfoParkView.swift
//  hotmoto
//
//  Created by Huy on 4/2/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit
class InfoItem: NSObject {
    var infoTitle = ""
    var icon: UIImage?
    
}
class InfoParkView: GreenView, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! InfoItemCell
        let item = arrayInfo[indexPath.row]
        cell.imvIcon.image = item.icon
        cell.lblTitle.text = item.infoTitle
        return cell
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func initStyle() {
        self.backgroundColor = UIColor("#2A2E43")
        clvInfo.register(UINib.init(nibName: "InfoItemCell", bundle: nil), forCellWithReuseIdentifier: "cell")
    }
    var arrayInfo = [InfoItem]()
    
    @IBOutlet weak var btnDetail: UIButton!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblCost: UILabel!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnBook: UIButton!
    @IBOutlet weak var clvInfo: UICollectionView!
    
    func showInfo(inView: UIView) {

        var startRect = self.frame
        startRect.origin.y = inView.frame.size.height
        
        inView.addSubview(self)
        
        var endRect = self.frame
        endRect.origin.y = inView.frame.size.height - self.frame.size.height
        self.alpha = 0

        self.layoutIfNeeded()
        self.frame = startRect
        UIView.animate(withDuration: 0.33) {
            self.frame = endRect
            self.alpha = 1
        }
        
    }
    var myPark: Park?

    func loadPark(park: Park) {
        arrayInfo.removeAll()
        myPark = park
        lblStatus.attributedText = stateForPark(park)

        let itemTot = InfoItem()
        let current = park.total - park.AvailableSlot
        itemTot.infoTitle = "\(current)/ \(park.total)"
        itemTot.icon = #imageLiteral(resourceName: "total")
        arrayInfo.append(itemTot)
        
        let itemTime = InfoItem()
        itemTime.infoTitle = stringForTime(park.openTime, park.closeTime)
        itemTime.icon = #imageLiteral(resourceName: "time")
        arrayInfo.append(itemTime)
        
        let itemType = InfoItem()
        itemType.infoTitle = stringMobileType(park.type)
        itemType.icon = iconForTypeWhite(park.type)
        arrayInfo.append(itemType)
        
        lblCost.attributedText = attriButestringForCost(park.cost , park.numberHours )
        clvInfo.reloadData()

        
    }
    @IBAction func callPhone(_ sender: Any) {
        if let url = URL(string: "tel://\(myPark?.phone ?? "")"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
            
        }

    }
}
