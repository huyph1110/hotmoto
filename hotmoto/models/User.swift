//
//  User.swift
//  hotmoto
//
//  Created by Huy on 5/15/18.
//  Copyright © 2018 Huy. All rights reserved.
//

import UIKit

class User: Mi {
    @objc dynamic var username = ""
    @objc dynamic var password = ""

}
class loginReq: Mi {
    @objc dynamic var username = ""
    @objc dynamic var password = ""
    
}
class registerReq: Mi {
    @objc dynamic var username = ""
    @objc dynamic var password = ""
    
}
extension Services {
    func userLogin(request : loginReq, success: @escaping (() -> Void), failure:@escaping ((String) -> Void)){
        services.request(api: .login, method: .post, param: request.dictionary() as Dictionary<String, AnyObject>, success: { (response) in
            success()
            
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
}
