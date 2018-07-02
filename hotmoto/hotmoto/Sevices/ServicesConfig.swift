//
//  ServicesConfig.swift
//  Hey_Go
//
//  Created by Lê Dũng on 5/19/17.
//  Copyright © 2017 NCSoft. All rights reserved.
//

import UIKit
import Foundation

let  servicesConfig = ServicesConfig.sharedInstance()


class ServicesConfig: NSObject {

    //product
    let url = "http://hotmoto.mr47.net"

    static var instance: ServicesConfig!
    class func sharedInstance() -> ServicesConfig
    {
        if(self.instance == nil)
        {
            self.instance = (self.instance ?? ServicesConfig())
        }
        return self.instance
    }

}


