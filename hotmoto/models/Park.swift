//
//  Park.swift
//  hotmoto
//
//  Created by Huy on 4/6/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit
import GoogleMaps

class Park: Mi {
    @objc dynamic var position =  CLLocationCoordinate2DMake(0, 0)
    @objc dynamic var name =  ""
    @objc dynamic var address =  ""
    @objc dynamic var phone =  ""
    @objc dynamic var id =  ""
    @objc dynamic var cost =  ""
    @objc dynamic var total =  0
    @objc dynamic var AvailableSlot =  0
    @objc dynamic var openTime =  0
    @objc dynamic var closeTime =  0
    @objc dynamic var status =  0

    var marker: GMSMarker?
    /*
     {"id":"5af90325a0ccf74aec2269f1","location":{"type":"Point","coordinates":[106.65500421077,10.8401665597548]},"name":"test name","address":"test address","phone":"012345","total":0,"AvailableSlot":0,"openTime":"","closeTime":"","status":1}
     */
    class func parseData(arr: [NSDictionary]) -> [Park] {
        var out = [Park]()
        for dic in arr {
            let item = Park.init(dictionary: dic)
            let locat = dic.value(forKey: "location") as! NSDictionary
            let coordinate = locat.value(forKey: "coordinates") as! [CGFloat]

            item.position = CLLocationCoordinate2DMake(CLLocationDegrees(coordinate[1]),CLLocationDegrees(coordinate[0]))
            out.append(item)
        }
        
        return out
    }

}
class getParksReq: Mi {
//    "long": (float),
//    "lat": (float),
//    "scope":(float)
    @objc dynamic var position:[Float] =  [0,0]
    @objc dynamic var scope:Float =  0

    
}

class Location: Mi {
    @objc dynamic var type =  "Point"
    @objc dynamic var coordinates:[Double] =  [0,0]

}
class insertParkReq: Mi {
    //    "long": (float),
    //    "lat": (float),
    //    "scope":(float)
    @objc dynamic var location = NSDictionary()
    @objc dynamic var name =  ""
    @objc dynamic var address = ""
    @objc dynamic var phone = ""
    @objc dynamic var total = 0

}


extension Services {
    func getParks(request : getParksReq, success: @escaping (([Park]?) -> Void), failure:@escaping ((String) -> Void)){
        services.request(api: .getNearCurrents, method: .post, param: request.dictionary() as Dictionary<String, AnyObject>, success: { (response) in
            success(Park.parseData(arr: response.arrayResponse as! [NSDictionary]))

        }) { (error) in
            failure(error)
        }
    }
    func insertPark(request : insertParkReq, success: @escaping (() -> Void), failure:@escaping ((String) -> Void)){
        services.request(api: .parkings, method: .post, param: request.dictionary() as Dictionary<String, AnyObject>, success: { (response) in
            success()
            
        }) { (error) in
            failure(error)
        }
    }
}

