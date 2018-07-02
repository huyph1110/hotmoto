//
//  constant.swift
//  hotmoto
//
//  Created by Huy on 3/25/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit

class Constant: NSObject {

}
enum LOGIN_TYPE {
    case GUEST
    case PARK
}
enum LOGIN_ACCOUNT : String {
    case USER = "LOGINUSER"
    case PASS = "LOGINPASS"
}


enum segue_type : String {
    case managepark = "managepark"
    case editpark = "editpark"
    case newpark = "newpark"
    case guest = "guest"
}
let GoogleMap_API = "AIzaSyBxsfr_Ymwg4FByyh1S6K7Xrczj6WQ4kwA"

