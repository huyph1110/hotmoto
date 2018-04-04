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
    func showInfo(inView: UIView) {

        var startRect = self.frame
        startRect.origin.y = inView.frame.size.height
        
        inView.addSubview(self)
        
        var endRect = self.frame
        endRect.origin.y = inView.frame.size.height - self.frame.size.height

        self.layoutIfNeeded()
        self.frame = startRect
        UIView.animate(withDuration: 0.33) {
            self.frame = endRect
        }
    }
}
