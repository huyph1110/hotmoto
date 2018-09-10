//
//  ABView.swift
//  DVC
//
//  Created by Lê Dũng on 9/28/17.
//  Copyright © 2017 DVC. All rights reserved.
//

import UIKit
import PureLayout
class ABView: GreenView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}



extension UIView
{
    func showABView(view : GreenView)
    {
        if(view.superview != nil)
        {
            self.hideABView(view: view)
            return;
        }
        view.removeFromSuperview()
        self.addSubview(view)
        view.autoPinEdge(toSuperviewEdge: .leading)
        view.autoPinEdge(toSuperviewEdge: .trailing)
        
        
        let bottom = view.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: UIScreen.main.bounds.height)
        
        view.object = bottom
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1), execute: {
            bottom.constant = 0
            UIView.animate(withDuration: 0.25) {
                self.layoutIfNeeded()
            }
        })
    }
    
    func hideABView(view : GreenView)
    {
        let bottomContrain = view.object as? NSLayoutConstraint
        if(bottomContrain != nil)
        {
            bottomContrain?.constant = UIScreen.main.bounds.height
            UIView.animate(withDuration: 0.5) {
                self.layoutIfNeeded()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(600), execute: {
                view.removeFromSuperview()
            })

        }
    }
}
