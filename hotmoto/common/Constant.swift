//
//  constant.swift
//  hotmoto
//
//  Created by Huy on 3/25/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit
var cloudName = "huyph00"
var apiKey = "751342836181944"
var apiSecret = "tvuVpl7UHhIuzWu83G1UYPo5ZyQ"

let GoogleMap_API = "AIzaSyBxsfr_Ymwg4FByyh1S6K7Xrczj6WQ4kwA"
let Admob_ApplicationID = "ca-app-pub-6694327567060424~7544807820"
let Admob_UnitID = "ca-app-pub-6694327567060424/7870867616"

class Constant: NSObject {

}
enum LOGIN_TYPE {
    case LOGIN
    case REGISTER
}
enum LOGIN_ACCOUNT : String {
    case USER = "LOGINUSER"
    case PASS = "LOGINPASS"

}
enum SYSTEM : String {

    case TOKEN = "TOKEN"
    
}


enum segue_type : String {
    case managepark = "managepark"
    case editpark = "editpark"
    case newpark = "newpark"
    case guest = "guest"
}

struct ColorsConfig {
    static let selectedText = UIColor.white
    static let text = UIColor.black
    static let textDisabled = UIColor.gray
    static let selectionBackground = UIColor("#FE2C7B")
    static let sundayText = UIColor("#9B9B9B")
    static let sundayTextDisabled = UIColor(red: 1.0, green: 0.6, blue: 0.6, alpha: 1.0)
    static let sundaySelectionBackground = selectionBackground
    static let markColor = UIColor("#4CD964")
    static let button_green = UIColor("#5FB660")
    static let button_blue = UIColor("#377BB5")
    static let button_red = UIColor("#D75452")
    static let button_yellow = UIColor("#EBAA56")
    static let button_violet = UIColor("#5FBED9")

}
