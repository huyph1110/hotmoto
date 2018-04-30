//
//  InfoParkView.swift
//  hotmoto
//
//  Created by Huy on 4/2/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit

class InfoParkView: GreenView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func initStyle() {
        self.backgroundColor = UIColor.white
    }
    @IBOutlet weak var btnDetail: UIButton!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblSlot: UILabel!
    @IBOutlet weak var lblTimeActive: UILabel!
    @IBOutlet weak var lblCost: UILabel!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnBook: UIButton!
    
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
    
    func loadPark(park: Park) {
        lblCost.text = park.cost
        lblSlot.text = "\(park.total)"
    }
}
