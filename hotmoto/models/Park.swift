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
    @objc dynamic var status =  0 //0: san sang ; 1: da dong
    @objc dynamic var email =  ""
    @objc dynamic var username =  ""
    @objc dynamic var fullname =  ""
    @objc dynamic var imageUrl =  ""


    var marker: GMSMarker?
    /*
     {"id":"5af90325a0ccf74aec2269f1","location":{"type":"Point","coordinates":[106.65500421077,10.8401665597548]},"name":"test name","address":"test address","phone":"012345","total":0,"AvailableSlot":0,"openTime":"","closeTime":"","status":1}
     */
    class func parseData(arr: [NSDictionary]) -> [Park] {
        var out = [Park]()
        for dic in arr {
            let item = Park.init(dictionary: dic)
            let locat = dic.value(forKey: "location") as! NSDictionary
            let coordinate = locat.value(forKey: "coordinates") as! [NSNumber]

            item.position = CLLocationCoordinate2DMake(CLLocationDegrees(coordinate[1].floatValue),CLLocationDegrees(coordinate[0].floatValue))
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
    @objc dynamic  var location = NSDictionary()
    @objc dynamic  var name: String?
    @objc dynamic  var address: String?
    @objc dynamic  var phone: String?
    @objc dynamic  var username: String?
    //@objc dynamic var cost =  ""
    @objc dynamic  var total = 0
    @objc dynamic  var openTime: String?
    @objc dynamic  var closeTime: String?
    @objc dynamic  var email: String?
    @objc dynamic  var imageUrl: String?


}
func location(coordinate: CLLocationCoordinate2D) -> NSDictionary {
   return ["coordinates" : [coordinate.longitude,coordinate.latitude] , "type" : "Point"]
}

extension Services {
    func getParks(request : getParksReq, success: @escaping (([Park]?) -> Void), failure:@escaping ((String) -> Void)){
        services.request(api: .getNearCurrents, method: .post, param: request.dictionary() as Dictionary<String, AnyObject>, success: { (response) in
            success(Park.parseData(arr: response.arrayResponse as! [NSDictionary]))

        }) { (error) in
            failure(error)
        }
    }
    func getParksByUser(user : String, success: @escaping (([Park]?) -> Void), failure:@escaping ((String) -> Void)){
        let request = ["username" : user]
        services.request(api: .getlistParkByUser, method: .post, param: request as Dictionary<String, AnyObject>, success: { (response) in
            success(Park.parseData(arr: response.arrayResponse as! [NSDictionary]))
            
        }) { (error) in
            failure(error)
        }
    }
    func updatePark(request : insertParkReq, success: @escaping (() -> Void), failure:@escaping ((String) -> Void)){
        services.request(api: .parkings, method: .put, param: request.dictionary() as Dictionary<String, AnyObject>, success: { (response) in
            success()
            
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

