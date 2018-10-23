//
//  User.swift
//  hotmoto
//
//  Created by Huy on 5/15/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit
var userLogin: User?

class User: Mi {
    @objc dynamic var username = ""
    @objc dynamic var password = ""
    @objc dynamic var userID = ""
    @objc dynamic var devicetoken = ""
    class func parseData(dic: NSDictionary) -> User {
        /*
         "id": "5afaae8ca0ccf760e2bc605c",
         "username": "user1",
         "password": "password1",
         "devicetoken": "123"
         */
        let user = User()
        user.username = dic.value(forKey: "username") as! String
        user.password = dic.value(forKey: "password") as! String
        user.userID = dic.value(forKey: "id") as! String
        user.devicetoken = dic.value(forKey: "devicetoken") as! String

        return user
    }
}
class loginReq: Mi {
    @objc dynamic var username = ""
    @objc dynamic var password = ""
    
}
class registerReq: Mi {
    @objc dynamic var username = ""
    @objc dynamic var password = ""
    
}
class registerTokenReq: Mi {
    @objc dynamic var userID = ""
    @objc dynamic var deviceToken = ""
    
}
class deleteTokenReq: Mi {
    @objc dynamic var userID = ""
    
}
class pushNotificationReq: Mi {
    @objc dynamic var title = ""
    @objc dynamic var content = ""
    @objc dynamic var username = ""

}
extension Services {
    func userLogin(request : loginReq, success: @escaping ((User) -> Void), failure:@escaping ((String) -> Void)){
        services.request(api: .login, method: .post, param: request.dictionary() as Dictionary<String, AnyObject>, success: { (response) in
            
            
            success(User.parseData(dic: response.dictionaryResponse))
            
        }) { (error) in
            failure(error)
        }
    }
    func userRegister(request : registerReq, success: @escaping (() -> Void), failure:@escaping ((String) -> Void)){
        services.request(api: .register, method: .post, param: request.dictionary() as Dictionary<String, AnyObject>, success: { (response) in
            success()
            
        }) { (error) in
            failure(error)
        }
    }
    func registerToken(request : registerTokenReq, success: @escaping (() -> Void), failure:@escaping ((String) -> Void)){
        services.request(api: .registerDeviceToken, method: .post, param: request.dictionary() as Dictionary<String, AnyObject>, success: { (response) in
            success()
            
        }) { (error) in
            failure(error)
        }
    }
    
    func deleteToken(request : deleteTokenReq, success: @escaping (() -> Void), failure:@escaping ((String) -> Void)){
        services.request(api: .deleteDeviceToken, method: .post, param: request.dictionary() as Dictionary<String, AnyObject>, success: { (response) in
            success()
            
        }) { (error) in
            failure(error)
        }
    }
    func pushNotification(request : pushNotificationReq, success: @escaping (() -> Void), failure:@escaping ((String) -> Void)){
        services.request(api: .pushNotificationSingle, method: .post, param: request.dictionary() as Dictionary<String, AnyObject>, success: { (response) in
            success()
            
        }) { (error) in
            failure(error)
        }
    }
}
